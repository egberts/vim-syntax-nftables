# Design

## Overview
The `vim-script-nftables` project maps the nftables Extended Backus-Naur Form (EBNF) grammar into a fully deterministic LL(1) grammar for Vimscript syntax highlighting. This ensures a hierarchical, structured parse tree with explicit rule and semantic action labeling.

## Approach
The nftables grammar is derived from `src/parser_bison.y`, which defines token relationships. Using Bison, we generate EBNF output, visualized as Railroad diagrams via the W3C tool. A Python DHParse script extracts nested keywords for each Vimscript LL(1) group, creating a deterministic parse tree.

### Challenges
- **EBNF to LL(1) Translation**: Simplifying complex relationships (1:M, N:1, N:M, recursion loops) results in some detail loss (e.g., `stmt -> stmt -> stmt` cycles).
- **scanner.c Impact**: The `scanner.c` file performs secondary kernel-based validation, which was overlooked initially, leading to a 10,000-line Vimscript file based solely on `parser_bison.y`. This required adjustments to account for kernel-level checks.

### Translation Stages
1. **Keyword Grouping**: Aggregate keywords into syntax-directed semantic groups (non-terminals) at each parse tree node. (Most challenging)
2. **Rule Composition**: Define rules based on actual tokens, requiring extensive re-reading of the grammar.
3. **Parse Tree Construction**: Build a fully deterministic pathway to each token, ensuring LL(1) compliance. (Simplest)
4. **Rule Labeling**: Create stateful transitions for semantic actions, mapping to Vimscript group names. (Tedious but straightforward)

This process mastered both EBNF/Railroad diagrams and `scanner.c`’s kernel-based validation of arguments, identifiers, and fields.

## Unit Testing
Two types of unit tests ensure correctness:
- **Passive Tests**: Syntax checking using `nft -c` (via `parser_bison.y`) to validate grammar without kernel interaction.
- **Active Tests**: Kernel-updating tests (via `scanner.c`) to verify runtime behavior.

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
- Use unique group names for nested regions to preserve `start=` and `end=` cohesion.
- Prioritize specific patterns in regex and `nextgroup=` to ensure accurate highlighting and error detection.

## Patterns
Each Vimscript group corresponds to an LL(1) grammar rule, mapping to a parse tree node. Keywords are grouped by semantic action, ensuring deterministic highlighting.

## Error Handling
Error detection is challenging with `containedin=`. Use distinct group names and avoid same-group multiple matches to improve error reporting. Order patterns from specific to wildcard for accurate matching.

## Color Scheme
The color scheme leverages Vim’s highlighting groups, mapping semantic actions to distinct colors for clarity. Specific patterns take precedence to ensure accurate visual feedback.
