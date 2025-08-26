# Design

## Overview
The `vim-script-nftables` project maps the nftables Extended Backus-Naur Form (EBNF) grammar into a fully deterministic LL(1) grammar for Vimscript syntax highlighting. This ensures a hierarchical, structured parse tree with explicit rule and semantic action labeling.

## Approach
The nftables grammar is derived from `src/parser_bison.y`, which defines token relationships. 

Using Bison, we generate EBNF output, visualized as Railroad diagrams via the W3C tool. 

By reviewing `scanner.c`, validation mechanisms are extracted, then enforced beyond the EBNF syntax.

A Python DHParse script extracts first-encountered deeply-nested rules for all keywords of each Vimscript LL(1) group, thus creating a deterministic parse tree (true LL(1) syntax needed by Vimscript, and later tree-sitter/LSP).

### Challenges
- **EBNF to LL(1) Translation**: Simplifying complex relationships (1:M, N:1, N:M, recursion loops) results in some detail loss (e.g., `stmt -> stmt -> stmt` cycles).  To compensate of these loss, repetition is done by virtue of Vimscript syntax redoing the entire parsing for each starting lines (of course, within its own nested region scope).
- **scanner.c Impact**: The `scanner.c` file performs secondary kernel-based validation, which was overlooked initially. I went ahead and created the 10,000+line Vimscript file based solely on this `parser_bison.y`. This oversight of mine required major adjustments to account for this required kernel-level checks.
- Terminologies
- Tracking pathways; best done by using very long group names that encodes the rule name of each steps, thus making one pathway unique.

### Syntactic Construct Terminology

- Semantic action - a state of the current token (Bison)
- Group name - a non-terminal symbol or a rule that links a token keyword to a highlighting rule (Vimscript)


### Translation Stages
1. **Keyword Grouping**: Aggregate keywords into syntax-directed semantic groups (non-terminals) at each parse tree node. (Most challenging, best done by Python DHParse)
2. **Rule Composition**: Define rules based on actual tokens, requiring extensive re-reading of the EBNF grammar.
3. **Parse Tree Construction**: Build a fully deterministic pathway to each token, ensuring LL(1) compliance. (Simplest)
4. **Rule Labeling**: Create stateful transitions for semantic actions, mapping to Vimscript very-long group names. (Tedious but straightforward).  Preserves unique pathways necessary to avoid cross-contaimination of multi-nested 'syntax region' (table-chain-set).

This process masters and incorporates both the EBNF/Railroad diagrams and its `scanner.c`’s kernel-based validation of arguments, identifiers, and fields for completeness.

## Unit Testing
Two types of unit tests are required to ensure correctness:
- **Passive Tests**: Syntax checking using `nft -c` (via `parser_bison.y`) to validate grammar without kernel interaction.
- **Active Tests**: Kernel-updating tests (via `scanner.c`) to verify runtime behavior.  Poses risk with current firewall rules in-situ.

## Vimscript Gotchas
1. **Ordering**:
   - `syntax match` statements within the same group must be ordered; the last match is tested first, potentially missing longer patterns.
   - Regex patterns (e.g., `\v(shortest|longest|shorter|longer|short|long)`) must prioritize longer patterns to avoid partial matches (e.g., `foobar` matching only `foo`).
   - `nextgroup=` ordering: Longest static patterns first, followed by wildcard patterns (e.g., `nft_delete_cmd_keyword_flowtable` before `nft_delete_cmd_keyword_table`).
2. **Scoping**:
   - `containedin=` complicates error detection and prevents use of `\zs` or `\ze` in contained matches.
   - Reusing group names across nested regions breaks multi-nesting cohesion (e.g., table-chain or table-set-element).
3. **Performance**:
   - `containedin=` is computationally expensive; minimize its use to region nesting only.
   - Regex operators `*` and `+` are costly; use bounded quantifiers like `{0,5}` or `{1,64}`.

### Best Practices
- Avoid `containedin=` for error detection; use only for nested regions (e.g., table-chain, table-set-element).
- Use unique group names for nested regions to preserve cohesion of each pair of  `start=` and `end=`.
- Prioritize specific patterns in regex and `nextgroup=` to ensure accurate highlighting and error detection.
- Detail group name composes by its sets of EBNF symbol names, separated by underscores (snake-case).

## Group Name

Group name (Vimscript syntax) is derived from its EBNF symbol(s).  If the symbol is deep in its grammar pathway or is used across region boundaries (table-chain-set), then its group name is constructed by stringing several EBNF symbols together. Simple `nft` example:

```console
    $ nft list ruleset ip
```

can be inserted into a `nft` script file (with `.nft` filetype notation):

```nftables
list ruleset ip
```

* `input` is the starting point of Bison lexical parser.  Vimscript syntax built-in does this already
* `input` EBNF symbol leads to `line` symbol.  Vimscript syntax built-in does this already
* `line` symbol leads to `base_cmd`.
* `base_cmd` symbol leads to `list_cmd`.

Its group name would be `input_line_base_cmd_list_cmd`.

For sake of less-repetitive and less-strong-typing, we removed `input` and `line` and start with `base_cmd`.

    base_cmd_list_cmd

To refer to the keyword `list`, we append "\_keyword\_" followed by its name of the keyword as a easy to read convention; makes it easier to sort keywords from longer to shorter in `contains=` and `nextgroup=`:

* `line` symbol leads to `base_cmd`.  (no need to mention `line` anymore)
* `base_cmd` symbol leads to `list_cmd`.
* 'list' keyword is in `list_cmd` symbol (as a terminal symbol/token/keyword; rest above are non-terminal symbolss).

Group name would then be:

    base_cmd_list_cmd_keyword_list  # that's 'list' in actual token-speak

As we go deeper for longer group name, we then remove `base_cmd` from its group name, and sometimes do furthertop-level removals.

Look deeper for that `ruleset` keyword after `list`:

```console
    $ nft list ruleset ip
```

* `base_cmd` symbol leads to `list_cmd`.
* 'list' keyword is in `list_cmd` symbol (as a terminal symbol/token/keyword; rest above are non-terminal symbolss).
* Also within `list_cmd`, 'list' keyword leads to `ruleset_spec` non-terminal symbol.
* `ruleset_spec` leads to an optional `family_spec_explicit`.

Complex example:

 line -> base\_cmd -> delete\_cmd -> 'table' -> table\_id\_spec -> table\_spec -> family\_spec -> family\_spec\_explicit -> 'ip')

translates into `base_cmd_delete_cmd_table_id_spec_table_spec_family_spec_family_spec_explicit`.

Yes, makes tracking of Vimscript syntax error the easiest.

## Patterns
Each Vimscript group corresponds to a an LL(1) grammar rule, mapping to a parse tree node. Keywords are grouped by semantic action, ensuring deterministic highlighting.

## Error Handling
Error detection is challenging with `containedin=`. Use distinct group names and avoid same-group multiple matches to improve error reporting. Order patterns from specific to wildcard for accurate matching.

## Color Scheme
The color scheme leverages Vim’s highlighting groups, mapping semantic actions to distinct colors for clarity. Specific patterns take precedence to ensure accurate visual feedback.  Works for both light and dark background.
