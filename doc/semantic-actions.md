# nftables Semantic Actions (parser_bison.y)

This document explains the key semantic actions in nftables grammar
and how they map to Vimscript syntax highlighting.

## LL(1) Background
Vimscript syntax requires strict LL(1) parsing, meaning every possible
valid keyword path must be represented in the grammar tree.
By expanding all fanout paths, Vim avoids external state machines.

Example: the `devices` keyword is only valid in a `netdev` table,
so LL(1) enforces unique parse paths for each family (`ip`, `ip6`,
`bridge`, etc.).

## Rule Entry Points
In nftables, all roads lead to `stmt`, the smallest unit of a rule.

Common parse paths:
- **File-based**: `line → base_cmd → add_cmd → 'table' → … → stmt`
- **CLI-based**: `line → base_cmd → 'add' 'rule' … → stmt`
- **Other variants**: `create chain … stmt`, `add chain … stmt`, etc.

## Core Grammar Units
- **stmt**: top-level statement in a `chain_block`
- **stmt_expr**: glue to turn a statement into an expression
- **expr**: general expression (constants, operators, sets, grouping)
- **primary_expr**: smallest atom (constant, identifier, set reference)

## Statement Variants
- **payload_stmt**: fetches packet header fields (e.g. `ip saddr`, `tcp dport`)
- **primary_stmt_expr**: allows statement-like constructs (`payload_stmt`, `meta_stmt`)
  to be used inside larger expressions (e.g. `ip protocol != tcp`)

## Major Blocks
Blocks are regions enclosed in `{ … }`.  
Common block types:
- `chain` (rules)
- `table`, `set`, `map`, `flowtable`
- `counter`, `quota`
- `ct helper`, `ct expectation`, `ct timeout`
- `limit`, `secmark`, `synproxy`, `meter`

