" File: add_rule_cmd.vim
" Directory: custom/nftables/add/
" In nftables v1.1.4, the **implied `rule` syntax** used at the top level of a script file (processed with `nft -f`) does not always require the `family_spec_explicit` (e.g., `ip`, `ip6`, `inet`) to avoid ambiguity, but its necessity depends on the context of the table and chain being referenced. I’ll analyze this based on `src/parser_bison.y` and clarify when `family_spec_explicit` is required, providing examples and referencing the grammar.
"
"### Implied `rule` Syntax
"- **Definition**: The implied `rule` syntax omits `add rule` or `rule`, specifying `<family> <table> <chain> <expr>` or `<table> <chain> <expr>` at the top level of a script.
"- **Example**: `ip filter input ip protocol icmp accept` or `filter input ip protocol icmp accept`.
"- **Parsing Path**: Matches `base_cmd : table_spec base_hook_stmt_list` in `parser_bison.y`.
"  ```
"  base_cmd : table_spec base_hook_stmt_list
"           {
"               $$ = cmd_alloc_rule_list(CMD_ADD, &$1->location, $1, $2);
"           }
"  ```
"
"### Role of `family_spec_explicit`
"- **Definition**: `family_spec_explicit` is a non-terminal parsing the protocol family (`ip`, `ip6`, `inet`, `arp`, `bridge`, `netdev`).
"  ```
"  family_spec_explicit : IP
"                       | IP6
"                       | INET
"                       | ARP
"                       | BRIDGE
"                       | NETDEV
"  ```
"- **In `table_spec`**:
"  ```
"  table_spec : family_spec_explicit identifier
"             {
"                 $$ = table_spec_alloc(&@$, $1, $2);
"             }
"             | identifier
"             {
"                 $$ = table_spec_alloc(&@$, NFPROTO_UNSPEC, $1);
"             }
"  ```
"  - `family_spec_explicit` is optional; if omitted, the family defaults to `NFPROTO_UNSPEC` (unspecified).
"
"- **In `base_hook_stmt_list`**:
"  - The `identifier` (chain name) and `stmt_list` (rule expression) are parsed, and the rule is added to the chain in the specified table.
"  ```
"  base_hook_stmt_list : base_hook_stmt
"                      | base_hook_stmt_list base_hook_stmt
"                      ;
"  base_hook_stmt : identifier stmt_list
"                 {
"                     $$ = rule_alloc(&@$, chain_spec_alloc(&@1, $1), $2);
"                 }
"  ```
"
"### Is `family_spec_explicit` Always Required?
"- **Short Answer**: No, `family_spec_explicit` is not always required in the implied `rule` syntax at the top level of a script file. The parser allows `table_spec` to omit the family, defaulting to `NFPROTO_UNSPEC`, and the kernel resolves the family based on the table’s definition.
"- **Conditions**:
"  - **Required**: When multiple tables with the same name exist in different families (e.g., `ip filter` and `ip6 filter`), specifying `family_spec_explicit` avoids ambiguity.
"  - **Not Required**: When the table name is unique across families or the context (e.g., chain or rule expression) implies the family, the parser and kernel can resolve it.
"
"### Analysis
"- **Parser Behavior**:
"  - If `family_spec_explicit` is omitted (e.g., `filter input ...`), `table_spec` sets `family = NFPROTO_UNSPEC`.
"  - The kernel looks up the table by name (`identifier`) and uses its defined family.
"  - If the table name is unique, no ambiguity arises.
"  - If multiple tables share the name, the kernel may reject the rule or pick the first matching table unless the family is specified.
"
"- **Ambiguity**:
"  - Ambiguity occurs only if the script defines multiple tables with the same name in different families (e.g., `table ip filter` and `table ip6 filter`).
"  - In such cases, `family_spec_explicit` (e.g., `ip` or `ip6`) ensures the correct table is targeted.
"
"- **Rule Expression Context**: The rule’s expression (e.g., `ip protocol icmp`) can provide context. For example:
"  - `ip protocol icmp` implies IPv4 (`ip` family).
"  - The parser (`ip_expr : IP PROTOCOL expr`) and kernel validate the expression against the table’s family, reducing ambiguity.
"
"### Valid Examples
"Below are examples showing when `family_spec_explicit` is required or optional, using your rule (`ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain, icmp : jump icmp-chain }`).
"
"#### 1. `family_spec_explicit` Not Required (Unique Table Name)
"**Script**:
"```
"table ip filter {
"    chain input {
"        type filter hook input priority 0; policy drop;
"    }
"    chain tcp-chain { }
"    chain udp-chain { }
"    chain icmp-chain { }
"}
"filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain, icmp : jump icmp-chain }
"```
"
"- **Explanation**:
"  - `table_spec`: `filter` (no `family_spec_explicit`, defaults to `NFPROTO_UNSPEC`).
"  - The kernel finds the `filter` table in the `ip` family (only one `filter` table exists).
"  - The `ip protocol` expression implies IPv4, aligning with the table’s family.
"  - **Valid**: No ambiguity, as `filter` is unique.
"
"#### 2. `family_spec_explicit` Required (Ambiguous Table Name)
"**Script**:
"```
"table ip filter {
"    chain input {
"        type filter hook input priority 0; policy drop;
"    }
"    chain tcp-chain { }
"    chain udp-chain { }
"    chain icmp-chain { }
"}
"table ip6 filter {
"    chain input {
"        type filter hook input priority 0; policy drop;
"    }
"}
"ip filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain, icmp : jump icmp-chain }
"```
"
"- **Explanation**:
"  - `table_spec`: `ip filter`.
"  - `family_spec_explicit`: `ip` is required to distinguish `ip filter` from `ip6 filter`.
"  - Without `ip`, `filter input ...` would be ambiguous, as two `filter` tables exist.
"  - **Valid**: `ip` ensures the rule targets the `ip filter` table.
"
"#### 3. `family_spec_explicit` Optional (Context Implies Family)
"**Script**:
"```
"table inet filter {
"    chain input {
"        type filter hook input priority 0; policy drop;
"    }
"    chain tcp-chain { }
"    chain udp-chain { }
"    chain icmp-chain { }
"}
"filter input ip protocol vmap { tcp : jump tcp-chain, udp : jump udp-chain, icmp : jump icmp-chain }
"```
"
"- **Explanation**:
"  - `table_spec`: `filter` (no `family_spec_explicit`).
"  - The `inet filter` table supports both IPv4 and IPv6, and `ip protocol` implies IPv4.
"  - The kernel validates the rule against the `inet` family, and no ambiguity arises.
"  - **Valid**: The expression `ip protocol` provides sufficient context.
"
"### When is `family_spec_explicit` Required?
"- **Required**:
"  - Multiple tables with the same name exist in different families (e.g., `ip filter` and `ip6 filter`).
"  - The rule’s expression does not imply a specific family (e.g., generic expressions like `meta mark 42` could apply to any family).
"- **Not Required**:
"  - The table name is unique across all families in the script.
"  - The rule’s expression (e.g., `ip protocol`, `ip6 nexthdr`) implies a specific family compatible with the table.
"
"### Parsing Details
"- **Grammar** (`parser_bison.y`):
"  - Implied syntax: `base_cmd : table_spec base_hook_stmt_list`.
"  - `table_spec` allows optional `family_spec_explicit`:
"    ```
"    table_spec : family_spec_explicit identifier
"               | identifier
"    ```
"  - `base_hook_stmt_list` parses the chain (`identifier`) and rule (`stmt_list`).
"- **Semantic Action**:
"  - `cmd_alloc_rule_list` creates a `struct cmd *` for adding the rule, using the table’s family (or `NFPROTO_UNSPEC` if unspecified).
"- **Lines**: `table_spec` (~300–400), `base_hook_stmt_list` (~700–800).
"
"### Validation
"- **Test**: Save examples as `rules.nft` and run `nft -f rules.nft --debug=parser`.
"- **Error Case**: If two `filter` tables exist and `family_spec_explicit` is omitted, `nft` may fail with an error like `Could not process rule: Table 'filter' is ambiguous`.
"
"### Notes
"- **Best Practice**: Include `family_spec_explicit` (e.g., `ip`, `inet`) for clarity and to avoid potential ambiguity, especially in scripts with multiple table families.
"- **Output**: `nft -f -v` typically includes `family_spec_explicit` (e.g., `add rule ip filter ...`) for explicitness.
"- **Source**: `parser_bison.y` (v1.1.4).
"
"
let s:add_rule_cmd_list_filepaths_semantic_early = []
let s:add_rule_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_add_rule_cmd')
  call nftables#syntax#log('INFO', 'Skipped add_rule_cmd (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"
try
  " non-terminal semantic action processing
  for s:this_semantic_file in s:add_rule_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading add_rule_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
"



  " Define rule-start keywords by length
let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_9char = join([
\   'masquerade', 'rtclassid',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_8char = join([
\   'continue', 'ibriport', 'iffgroup', 'obriport', 'redirect', 'synproxy',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_7char = join([
\   'counter', 'ibrname', 'iifname', 'iiftype', 'nftrace',
\   'notrack', 'obranme', 'oifname', 'oiftype', 'pkttype', 'udplite',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_6char = join([
\   'accept', 'cgroup', 'delete', 'geneve', 'gretap',
\   'reject', 'return', 'tproxy', 'update',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_5char = join([
\   'ether', 'icmpv6', 'limit', 'meter', 'queue',
\   'quota', 'reset', 'skgid', 'skuid', 'vxlan',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_4char = join([
\   'auth', 'comp', 'dccp', 'dnat', 'drop',
\   'flow', 'goto', 'icmp', 'igmp', 'jump', 'last',
\   'meta', 'mark', 'snat',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_3char = join([
\   'add', 'arp', 'cpu', 'day', 'dup',
\   'esp', 'fwd', 'gre', 'iif', 'ip6', 'log',
\   'oif', 'set', 'tcp', 'udp',
\ ], '\|')

let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_2char = join([
\   'at', 'ct', 'ip', 'th', 'xt',
\ ], '\|')

"  DOUBLE ESCAPE for literal * and (
let s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_1char = join([
\   '\\*', '\\(',
\ ], '\|')

let s:rule_alloc_start_regex =
\ '^\s*\%('
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_9char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_8char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_7char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_6char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_5char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_4char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_3char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_2char . '\|'
\ . s:nft_base_cmd_add_cmd_rule_alloc_stmt_rule_start_1char . '\|'
\ . '\h\w*' . '\\\)'

" ************* BEGIN rule_alloc stmt *******************************
"echom s:rule_alloc_start_regex
" ^\s*\%(masquerade\|rtclassid\|continue\|ibriport\|iifgroup\|obriport\|redirect\|synproxy\|counter\|ibrname\|iifname\|iiftype\|nftrace\|notrack\|obrname\|oifname\|oiftype\|pkttype\|udplite\|accept\|cgroup\|delete\|geneve\|gretap\|reject\|return\|tproxy\|update\|icmpv6\|ether\|limit\|meter\|queue\|quota\|reset\|skgid\|skuid\|vxlan\|auth\|comp\|dccp\|dnat\|drop\|flow\|goto\|icmp\|igmp\|jump\|last\|meta\|mark\|snat\|add\|arp\|cpu\|day\|dup\|esp\|fwd\|gre\|iif\|ip6\|log\|oif\|set\|tcp\|udp\|at\|ct\|ip\|th\|xt\|\\*\|\\(\|\h\w*\\\)

execute 'syntax region nft_add_cmd_rule_rule_alloc_stmt start=' . "'" . s:rule_alloc_start_regex . "'"
      \ . " end=';' contains=@nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster keepend contained"

" redefine nft_add_cmd_rule_rule_alloc_stmt"
hi link    nft_add_cmd_rule_rule_alloc_stmt nftHL_Statement
syn region nft_add_cmd_rule_rule_alloc_stmt end=/\ze;/ keepend contained
\ start='\v(masquerade|rtclassid|continue|ibriport|iifgroup|obriport|oifgroup|redirect|synproxy|counter|ibrname|iifname|iiftype|nftrace|notrack|obrname|oifname|oiftype|pkttype|udplite|accept|cgroup|delete|geneve|gretap|reject|return|tproxy|update|icmpv6|ether|ipsec|limit|meter|queue|quota|reset|skgid|skuid|vxlan|auth|comp|dccp|dnat|drop|flow|goto|hour|icmp|igmp|jump|last|mark|meta|snat|time|add|arp|cpu|day|dup|esp|fwd|gre|iif|ip6|log|not|oif|set|tcp|udp|at|ct|ip|th|xt)\ze(([ \t;])|($))'
\ contains=
\    @nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster,
\    nft_comment_inline
\ nextgroup=
\    nft_stmt_separator,
\    nft_Error
" ************* END rule_alloc stmt *********************

" ************* BEGIN rule_position *********************
hi link   nft_add_cmd_rule_position_num nftHL_Number
syn match nft_add_cmd_rule_position_num /\v[0-9]{1,10}/ skipwhite contained
\ nextgroup=
\    @nft_c_stmt,
\    nft_Error

hi link   nft_add_cmd_rule_position_position_spec_keyword_position nftHL_Keyword
syn match nft_add_cmd_rule_position_position_spec_keyword_position /\vposition\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error

hi link   nft_add_cmd_rule_position_handle_spec_keyword_handle nftHL_Keyword
syn match nft_add_cmd_rule_position_handle_spec_keyword_handle /handle\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error

hi link   nft_add_cmd_rule_position_index_spec_keyword_index nftHL_Keyword
syn match nft_add_cmd_rule_position_index_spec_keyword_index /\vindex\ze[ \t]/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_num,
\    nft_Error
" ************* END rule_position *********************


" THE vector point to over 73 lexical tokens/keywords, this nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative
hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_identifier nftHL_Table
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_declarative_keyword_ip,
"\    @nft_c_stmt,
" TODO: We need a split-out of super-cluster nft_add_cmd_rule_rule_alloc_stmt to interperse position_spec's keywords

syn cluster nft_c_add_cmd_rule_rule_alloc_again
\ contains=@nft_c_add_cmd_rule_rule_alloc_alloc

" base_cmd [ 'add' ] 'rule' rule_alloc comment_spec
hi link   nft_add_cmd_rule_comment_spec_string nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_string "\v[A-Za-z0-9 ]{1,64}" skipwhite contained
" TODO A BUG? What is a 'space' doing in comment?"

hi link   nft_add_cmd_rule_comment_spec_keyword_comment nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_keyword_comment "\vcomment\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_comment_spec_string

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule_alloc
\ contains=
\    nft_add_cmd_rule_comment_spec_keyword_comment,
\    @nft_c_stmt

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule
\ contains=
\    @nft_c_add_cmd_rule_rule_alloc



" ******************* BEGIN DECLARATIVE '^rule' **********************
" Do the chain identifier
hi link   nft_add_rule_declarative_rule_position_chain_spec_bridge_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_bridge_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_bridge

hi link   nft_add_rule_declarative_rule_position_chain_spec_netdev_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_netdev_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_netdev

hi link   nft_add_rule_declarative_rule_position_chain_spec_inet_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_inet_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_inet

hi link   nft_add_rule_declarative_rule_position_chain_spec_arp_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_arp_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_arp

hi link   nft_add_rule_declarative_rule_position_chain_spec_ip6_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_ip6_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_ip6

hi link   nft_add_rule_declarative_rule_position_chain_spec_ip_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_ip_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_family_ip

hi link   nft_add_rule_declarative_rule_position_chain_spec_unknown_family_identifier_chain nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_unknown_family_identifier_chain '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" Do the table identifier
hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_bridge_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_bridge_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_bridge_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_netdev_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_netdev_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_netdev_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_inet_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_inet_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_inet_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_arp_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_arp_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_arp_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip6_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip6_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_ip6_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip_identifier nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_ip_identifier,
\    nft_Error

" Do the family_spec_explicit defines
hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge '\vbridge\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_bridge_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev '\vnetdev\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_netdev_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet '\vinet\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_inet_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp '\varp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_arp_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6  '\vip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip6_identifier,
\    nft_Error

hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip nftHL_Family
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_ip_identifier,
\    nft_Error


" Declarative 'nft> rule ...'
" 'rule'->add_cmd->->base_cmd->line
hi link   nft_base_cmd_no_add_keyword_rule nftHL_Command
syn match nft_base_cmd_no_add_keyword_rule "\v^[ \t]{0,40}rule\ze[ \t]" skipnl skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_unknown_family_identifier_table,
\    nft_Error
" ******************* END DECLARATIVE '^rule' ************************

" ************** BEGIN DECLARATIVE implied 'rule' ********************
" implied rule 'nft> [<family_spec_explicit>] <identifier> <identifier> ...'
" 'rule'->add_cmd->'add'->base_cmd->line
hi link    nft_c_base_cmd_implied_rule nftHL_Command
syn cluster nft_c_base_cmd_implied_rule
\ contains=
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_unknown_family_identifier_table,
\    nft_Error
" ************** END DECLARATIVE implied 'rule' **********************

" ******************* BEGIN IMPERATIVE 'add rule' ********************
" Do the chain identifier
hi link   nft_add_rule_imperative_rule_position_chain_spec_bridge_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_bridge_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_netdev_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_netdev_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_inet_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_inet_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_arp_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_arp_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_ip6_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_ip6_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_ip_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_ip_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_add_rule_imperative_rule_position_chain_spec_unknown_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_unknown_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" Do the table identifier
hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_bridge_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_bridge_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_bridge_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_netdev_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_netdev_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_netdev_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_inet_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_inet_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_inet_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_arp_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_arp_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_arp_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip6_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip6_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_ip6_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_ip_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_unknown_family_identifier nftHL_Table
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_unknown_family_identifier '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_unknown_identifier,
\    nft_Error

" Do the family_spec_explicit defines
hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge '\vbridge\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_bridge_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev '\vnetdev\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_netdev_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet '\vinet\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_inet_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp '\varp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_arp_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6  '\vip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip6_identifier,
\    nft_Error

hi link   nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip nftHL_Family
syn match nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip '\vip\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_ip_identifier,
\    nft_Error

" IMPERATIVE 'nft> add rule ...'
" 'rule'->add_cmd->'add'->base_cmd->line
hi link   nft_add_rule_imperative_keyword_add_rule nftHL_Command
syn match nft_add_rule_imperative_keyword_add_rule '\vrule' skipnl skipwhite contained
\ nextgroup=
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_add_rule_imperative_rule_position_chain_spec_table_spec_unknown_family_identifier,
\    nft_Error
" ******************* END IMPERATIVE 'add rule' **********************

syn cluster nft_c_rule_alloc
\ contains=
\    @nft_c_stmt

syn cluster nft_c_rule
\ contains=
\    @nft_c_rule_alloc

hi link   nft_add_cmd_rule_rule_alloc_stmt_keyword_not nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_meta_stmt_meta_key_unqualified_keyword_ipsec,
\    nft_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_comment_inline,
\    nft_rule_cluster_Error

"***************** END rule/'add_cmd'/'base_cmd' *****************


  for s:this_semantic_file in s:add_rule_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded add_rule_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define add_rule_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_add_rule_cmd = v:true
