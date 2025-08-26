# Design Document for vim-syntax-nftables

## Overview

The `vim-syntax-nftables` plugin provides syntax highlighting and checking for `nftables` configuration files (`.nft`) in Vim and NeoVim. `nftables` is a Linux kernel firewall framework succeeding `iptables`, with a complex Backus-Naur Form (BNF) grammar and context-sensitive keywords (e.g., `table`, `chain`, `meter`). This plugin enhances the editing experience by accurately highlighting `nftables` constructs and aiding debugging, leveraging Vim’s LL(1) parsing capabilities.

The design prioritizes:
- **Accurate Syntax Highlighting**: Mapping `nftables` constructs to Vim syntax groups using snake_case naming (e.g., `nft_table_def`, `nft_meter`).
- **LL(1) Grammar Compliance**: Ensuring a deterministic, single-pass parser for efficiency.
- **Syntax-Directed Semantic Grouping**: Explicitly defining snake_case syntax groups for each `nftables` construct, mirroring the Bison parser’s structure (`parser_bison.y`).
- **Debugging Support**: Facilitating error identification, as outlined in `DEBUG.md`.
- **Compatibility**: Supporting `nftables` up to `v1.1.4` and address families (`ip`, `ip6`, `inet`, `arp`, `bridge`, `netdev`).

## Design Principles

### LL(1) Grammar and Explicit Rule Labeling

Vim’s syntax highlighting uses an LL(1) grammar, a top-down, predictive parser with single-token lookahead for deterministic parsing. The `vim-syntax-nftables` plugin adopts this by defining explicit syntax rules for each `nftables` construct, ensuring unambiguous parsing.

- **Explicit Rule Labeling**: Each `nftables` construct (e.g., `table`, `chain`, `rule`, `meter`, `set`) is mapped to a unique snake_case Vim syntax group (e.g., `nft_table_def`, `nft_chain_def`). This aligns with the Bison parser’s approach in `nftables`, where each EBNF rule has a dedicated non-terminal and semantic action. For example:
  - The `table` keyword is grouped under `nft_table_def`.
  - The `arp saddr ip` expression is grouped under `nft_arp_selector`.
  - This “syntax-directed semantic grouping” aggregates tokens (keywords, identifiers, numbers) into a single syntax group for highlighting and semantic processing.
- **Deterministic Pathways**: The grammar ensures unambiguous, deeply-nested rules. For instance, `table arp Tarp { chain Carp { ... } }` is parsed hierarchically, with each level (table, chain, rule) assigned a distinct snake_case syntax group.
- **Semantic Actions**: Each syntax group is linked to a highlighting rule (e.g., `highlight nft_table_def ctermfg=White`), similar to a Bison semantic action that processes tokens into an AST node.

### Syntax-Directed Semantic Grouping

The plugin groups `nftables` keywords and constructs into snake_case Vim syntax groups to reflect their semantic roles, ensuring accurate highlighting and context awareness. For example:

- **Keywords**: `table`, `chain`, `flush`, `type`, `hook`, `priority` are grouped under `nft_keyword` or specific subgroups (e.g., `nft_table_keyword`, `nft_chain_keyword`).
- **Expressions**: Selectors like `arp saddr ip`, `ip saddr`, or `tcp dport` are grouped under `nft_selector`, with subtypes (e.g., `nft_arp_selector`, `nft_ip_selector`) for family-specific syntax.
- **Meters and Sets**: Constructs like `meter flood size 128000 { arp saddr ip limit rate 10/second }` or `set Sarp { type ipv4_addr; size 15; }` are grouped under `nft_meter` and `nft_set`, with nested rules for components (e.g., `nft_limit`, `nft_set_type`).
- **Comments and Strings**: Lines starting with `#` are grouped under `nft_comment`, and quoted strings under `nft_string`.

This grouping mirrors the `nftables` BNF grammar, where each construct is a distinct node in the parse tree, enabling single-pass parsing in Vim.

### Handling Context-Sensitive Keywords

`nftables` keywords like `filter` (used as a type, chain name, or variable) require context-aware parsing. The plugin addresses this by:
- **Context-Aware Rules**: Using Vim’s `syntax region` and `syntax match` to define context-specific patterns. For example:
  ```vim
  syntax region nft_table_def start=/table \S\+ \S\+/ end=/}/ contains=nft_keyword,nft_chain_def
  syntax keyword nft_keyword table chain contained
  ```
  This ensures `table` is highlighted correctly within a table definition.
- **Family-Specific Selectors**: Defining separate groups (e.g., `nft_arp_selector` for `arp saddr ip`, `nft_ip_selector` for `ip saddr`) to avoid conflicts, addressing errors like `ip vs. arp` seen in `list.tp.nft`.

### IPv6 Limitation Workaround

Vim 8.1 has a limitation of 9 parenthetical groupings in regular expressions, impacting IPv6 address matching (e.g., `[0-9a-fA-F:]+`). To address this:
- IPv6 patterns are split into multiple `syntax match` rules to reduce complexity.
- Example:
  ```vim
  syntax match nft_ipv6_addr /[0-9a-fA-F]\{1,4\}:\{1,7\}[0-9a-fA-F]\{1,4\}/
  syntax match nft_ipv6_addr /::[0-9a-fA-F]\{1,4\}/
  highlight link nft_ipv6_addr nft_number
  ```
- This ensures robust IPv6 highlighting without exceeding Vim’s limits.

## Syntax Groups and Highlighting

The plugin defines the following snake_case syntax groups, mapped to Vim highlight groups for a 4-bit (16-color) color scheme, supporting light and dark themes:

- **nft_table_def**: Table definitions (e.g., `table arp Tarp`), highlighted as `ctermfg=White`.
- **nft_chain_def**: Chain definitions (e.g., `chain Carp`), highlighted as `ctermfg=White`.
- **nft_keyword**: Core keywords (e.g., `table`, `chain`, `type`, `hook`), linked to `Keyword`.
- **nft_selector**: Protocol selectors (e.g., `arp saddr ip`, `ip saddr`), linked to `Identifier`.
- **nft_meter**: Meter expressions (e.g., `meter flood size 128000`), highlighted as `ctermfg=Cyan`.
- **nft_set**: Set definitions (e.g., `set Sarp { type ipv4_addr; size 15; }`), highlighted as `ctermfg=Blue`.
- **nft_set_entry**: Set elements (e.g., `192.168.1.0/24`), highlighted as `ctermfg=White`.
- **nft_comment**: Lines starting with `#`, linked to `Comment`.
- **nft_string**: Quoted strings (e.g., `"log prefix"`), linked to `String`.
- **nft_number**: Numeric values (e.g., `128000`, `10/second`), highlighted as `ctermfg=DarkCyan`.
- **nft_delimiter**: Symbols like `{`, `}`, `;`, highlighted as `ctermfg=Gray`.

Example configuration and highlighting:
```nft
table arp Tarp {
    chain Carp {
        type filter hook input priority 0; policy accept;
        arp saddr ip 192.168.1.0/24 meter flood size 128000 { arp saddr ip limit rate 10/second } drop
    }
    set Sarp {
        type ipv4_addr
        size 15
    }
}
```
- `table`, `chain`, `type`, `hook`, `priority` → `nft_keyword` (bold, white).
- `arp saddr ip 192.168.1.0/24` → `nft_arp_selector` (cyan).
- `meter flood size 128000` → `nft_meter` (cyan).
- `set Sarp` → `nft_set` (blue).
- `192.168.1.0/24`, `15` → `nft_number` (dark cyan).
- `{`, `}` → `nft_delimiter` (gray).

## Debugging Support

Debugging syntax highlighting issues is critical for complex `nftables` configurations. The plugin follows `DEBUG.md`:
- **Highlight Testing**: Use `hilinks.vim` (Dr. Chip’s plugin) to display the syntax group under the cursor, identifying mis-highlighted tokens (e.g., `arp saddr ip` as `nft_ip_selector` instead of `nft_arp_selector`).
- **Narrowing Down Errors**: Isolate problematic lines in `.nft` files and report issues with expected vs. actual highlighting.
- **Vim Commands**: `:syntax` and `:highlight` inspect active syntax groups and colors.
- Example: A semicolon in `set Sarp { ... }` highlighted as `nft_number` (dark cyan) instead of `nft_delimiter` (light green) indicates a syntax failure.

## Installation and Configuration

Per `INSTALL.md`:
- Clone the repository: `git clone https://github.com/egberts/vim-syntax-nftables`.
- Copy files to Vim’s directories:
  ```bash
  mkdir -p ~/.vim/syntax ~/.vim/ftdetect
  cp vim-syntax-nftables/syntax/nftables.vim ~/.vim/syntax/
  cp vim-syntax-nftables/ftdetect/nftables.vim ~/.vim/ftdetect/
  ```
- Enable filetype detection in `~/.vim/ftdetect/nftables.vim`:
  ```vim
  au BufRead,BufNewFile *.nft set filetype=nftables
  ```
- Use `vim-addon-manager` for Debian systems to activate the plugin.

## Challenges and Limitations

- **Context-Sensitive Keywords**: Keywords like `filter` require context-aware rules, handled via `syntax region` and `contained` keywords.
- **Vim 8.1 Limitation**: The 9-grouping limit for regular expressions necessitated splitting IPv6 patterns, impacting maintenance but not functionality.
- **nftables Version Compatibility**: Supports `nftables` up to `v1.1.4`, including `meter` and `arp saddr ip`, but users must ensure kernel support for runtime use.
- **Large Configurations**: Long `.nft` files (e.g., `list.tp.nft` with errors at line 292) may cause parsing issues in Vim if syntax groups are not scoped properly, addressed by modular `syntax region` definitions.

## Future Improvements

- **Enhanced Context Sensitivity**: Refine rules for ambiguous keywords using granular `syntax region`.
- **Dynamic Syntax Checking**: Integrate `nft -c -f` for real-time error feedback in Vim.
- **Extended Family Support**: Add groups for new `nftables` features or families.
- **Color Scheme Flexibility**: Support 24-bit (true color) terminals for richer highlighting.

## References

- `DEBUG.md`: Debugging instructions.
- `INSTALL.md`: Installation steps.
- `nftables` Wiki: https://wiki.nftables.org for grammar and reference.
- Vim Documentation: `:help syntax` for LL(1) parsing and highlighting.
