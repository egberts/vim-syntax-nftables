


Here is a refined explanation and pattern that tail-ends the rule statement correctly, matching:

* a line ending with an optional semicolon (;) if present, end there,
* or the line just before the next statement start line,
* or the closing brace (}) that ends the block,
* or a blank line (some users separate rules with blank lines).

Core idea

* The region starts on a line with one of your tokens (the first token of the rule).
* The region ends on the first line matching any of:
  * line ending with ; (semicolon),
  * blank line,
  * next statement line starting with one of your tokens,
  * closing } brace line.

Pattern (using your full token list)

    end=/;\s*$\|^\s*$\|^\s*\%(masquerade\|rtclassid\|continue\|ibriport\|iifgroup\|obriport\|oifgroup\|redirect\|synproxy\|cfgroup\|counter\|ibrname\|iifname\|iiftype\|nftrace\|notrack\|obrname\|oifname\|oiftype\|pkttype\|symhash\|udplite\|accept\|cgroup\|delete\|exthdr\|geneve\|gretap\|numgen\|reject\|return\|socket\|tproxy\|update\|icmp6\|ipsec\|jhash\|limit\|meter\|queue\|quota\|reset\|skgid\|skuid\|vxlan\|auth\|comp\|dccp\|dnat\|drop\|flow\|frag\|goto\|hour\|icmp\|igmp\|jump\|last\|mark\|meta\|sctp\|snat\|time\|vlan\|add\|cpu\|day\|dst\|dup\|esp\|eth\|fib\|fwd\|gre\|hbh\|iif\|ip6\|log\|oif\|rt0\|rt2\|rt4\|set\|udp\|tcp\|at\|ct\|ip\|mh\|rt\|th\|xt\)\>\|^\s*}/

How this works

    ;\s*$ - line ending with semicolon (rule ends here)
    ^\s*$ - blank line (rule ends before blank line)
    ^\s*\%(TOKEN_LIST)\> - next rule statement start (rule ends just before this)
    ^\s*} - block end brace

Final snippet example:

    syntax region nftRule
    \ start=/^\s*\%(masquerade\|rtclassid\|continue\|ibriport\|iifgroup\|obriport\|oifgroup\|redirect\|synproxy\|cfgroup\|counter\|ibrname\|iifname\|iiftype\|nftrace\|notrack\|obrname\|oifname\|oiftype\|pkttype\|symhash\|udplite\|accept\|cgroup\|delete\|exthdr\|geneve\|gretap\|numgen\|reject\|return\|socket\|tproxy\|update\|icmp6\|ipsec\|jhash\|limit\|meter\|queue\|quota\|reset\|skgid\|skuid\|vxlan\|auth\|comp\|dccp\|dnat\|drop\|flow\|frag\|goto\|hour\|icmp\|igmp\|jump\|last\|mark\|meta\|sctp\|snat\|time\|vlan\|add\|cpu\|day\|dst\|dup\|esp\|eth\|fib\|fwd\|gre\|hbh\|iif\|ip6\|log\|oif\|rt0\|rt2\|rt4\|set\|udp\|tcp\|at\|ct\|ip\|mh\|rt\|th\|xt\)/
    \ end=/;\s*$\|^\s*$\|^\s*\%(masquerade\|rtclassid\|continue\|ibriport\|iifgroup\|obriport\|oifgroup\|redirect\|synproxy\|cfgroup\|counter\|ibrname\|iifname\|iiftype\|nftrace\|notrack\|obrname\|oifname\|oiftype\|pkttype\|symhash\|udplite\|accept\|cgroup\|delete\|exthdr\|geneve\|gretap\|numgen\|reject\|return\|socket\|tproxy\|update\|icmp6\|ipsec\|jhash\|limit\|meter\|queue\|quota\|reset\|skgid\|skuid\|vxlan\|auth\|comp\|dccp\|dnat\|drop\|flow\|frag\|goto\|hour\|icmp\|igmp\|jump\|last\|mark\|meta\|sctp\|snat\|time\|vlan\|add\|cpu\|day\|dst\|dup\|esp\|eth\|fib\|fwd\|gre\|hbh\|iif\|ip6\|log\|oif\|rt0\|rt2\|rt4\|set\|udp\|tcp\|at\|ct\|ip\|mh\|rt\|th\|xt\)\>\|^\s*}/
    \ contains=nftKeyword,nftAction,nftAddr
    \ keepend



Alternatively, nftables.vim snippet is:

```vim
" nftables.vim - improved syntax for nftables with multi-line rule support

if exists("b:current_syntax")
  finish
endif

" Token list sorted longest first
let s:token_list = '\vmasquerade|rtclassid|continue|ibriport|iifgroup|obriport|oifgroup|redirect|synproxy|cfgroup|counter|ibrname|iifname|iiftype|nftrace|notrack|obrname|oifname|oiftype|pkttype|symhash|udplite|accept|cgroup|delete|exthdr|geneve|gretap|numgen|reject|return|socket|tproxy|update|icmp6|ipsec|jhash|limit|meter|queue|quota|reset|skgid|skuid|vxlan|auth|comp|dccp|dnat|drop|flow|frag|goto|hour|icmp|igmp|jump|last|mark|meta|sctp|snat|time|vlan|add|cpu|day|dst|dup|esp|eth|fib|fwd|gre|hbh|iif|ip6|log|oif|rt0|rt2|rt4|set|udp|tcp|at|ct|ip|mh|rt|th|xt'

" Define syntax region for rule statements, multi-line, optional semicolon end
syntax region nftRule
  \ start=/^\s*\%(' . s:token_list . '\)/
  \ end=/;\s*$\|^\s*$\|^\s*\%(' . s:token_list . '\)\>|\s*}/
  \ contains=nftToken,nftAction,nftIP
  \ keepend

" Match tokens (keywords) via match instead of keyword
syntax match nftToken /\v\<(' . s:token_list . ')\>/

" Actions
syntax keyword nftAction add delete set update drop accept reject return contained

" Simple IP address match (IPv4 only for demo)
syntax match nftIP /\v\d{1,3}(\.\d{1,3}){3}/ contained

" Comments: lines starting with '#'
syntax match nftComment /^#.*$/

" Link contained groups
syntax cluster nftablesGroup contains=nftRule,nftToken,nftAction,nftIP,nftComment

highlight def link nftRule Statement
highlight def link nftToken Keyword
highlight def link nftAction Keyword
highlight def link nftIP Number
highlight def link nftComment Comment

let b:current_syntax = "nftables"
```

You said:
But 'tcp' has different semantic action when used as a rule statement

    'tcp port >= 22 accept'

and as a stmt_expression

   'ip saddr == 127.0.0.1 tcp syn'

ChatGPT said:

Absolutely — you want tcp highlighted differently depending on its semantic role:

* As a rule statement starter (like the first token on a rule line) → one highlight group (say, nftStmtHead)
* As part of an expression inside a rule → another highlight group (say, nftStmtExpr)

How to do that in Vim syntax?

You can distinguish them by:

* Defining the rule statement region starting on a line whose first token is one of your "statement head" tokens (e.g., tcp used as rule start).

* Inside that region, match your tokens again but highlight them as nftStmtExpr — i.e., expression tokens.

* The starting token that triggered the region can be highlighted differently using matchgroup in the start= pattern.

Practical example for your case:
```vim
" Statement head tokens (tokens that start a rule)
let s:stmt_head = 'masquerade\|rtclassid\|continue\|tcp\|udp\|ip\|icmp'  " etc.

" Statement expression tokens (tokens that can appear inside rule expressions)
let s:stmt_expr = 'tcp\|ip\|syn\|ack\|port\|saddr\|daddr'  " etc.

" Define the rule region, with 'tcp' (etc.) as start tokens
syntax region nftRule
  \ start=/^\s*\%(\%(tcp\|udp\|ip\|icmp\)\)\@<=\%(tcp\|udp\|ip\|icmp\|masquerade\|continue\|...\)/
  \ matchgroup=nftStmtHead
  \ end=/;\s*$\|^\s*$\|^\s*\%(masquerade\|rtclassid\|continue\|tcp\|udp\|ip\|icmp\|...\)\>\|^\s*}/
  \ contains=nftStmtExpr
  \ keepend

" Highlight the statement expression tokens inside the region
syntax match nftStmtExpr /\v\<(' . s:stmt_expr . ')\>/

" Highlight groups
highlight link nftStmtHead Keyword
highlight link nftStmtExpr Identifier
```

Explanation:

* The start= regex uses matchgroup=nftStmtHead — so the very first token (e.g., tcp at start of line) is highlighted as nftStmtHead.
* Inside the nftRule region, all occurrences of tokens in stmt_expr get highlighted as nftStmtExpr.
* So when tcp is first token on line → it’s nftStmtHead.
* When tcp appears later in the line (or lines) → it’s nftStmtExpr.
* This way the same token can have two different highlight groups depending on context.

Summary

* Use matchgroup= on start= pattern for the first token’s highlight group.
* Define a syntax match inside the region for expression tokens.
* Assign different highlight groups for statement heads vs expressions.

You said:
Cool,  'start=' and 'contains=' of the same 'tcp' keyword can be treated with different semantic actions (or syntaxes).

ChatGPT said:

You can have the same keyword like tcp:

* Matched in the start= of a region with one highlight group (e.g., nftStmtHead),

* And matched again inside the region with a different highlight group (e.g., nftStmtExpr) via contains=,

allowing Vim to semantically highlight them differently depending on where they appear.

It’s a great way to capture the context-dependent meaning of keywords without ambiguity.

Here’s a clean, concrete example of a Vim syntax snippet that implements your requirement:

* tcp (and other tokens) are highlighted as statement heads when starting a rule (in start=, with matchgroup).

* The same tokens (plus extras) inside the rule are highlighted as expression tokens (contains=).

* Multi-line rule statements are handled with the flexible end= pattern (semicolon, blank line, next statement, or }).

* Comments and some basic patterns included.

```vim
" nftables.vim - semantic highlight of rule heads vs expr tokens

if exists("b:current_syntax")
  finish
endif

" Statement head tokens (those that can start a rule line)
let s:stmt_head = 'masquerade\|rtclassid\|continue\|tcp\|udp\|ip\|icmp\|add\|delete\|set'

" Statement expression tokens (appear inside rules, including stmt heads again)
let s:stmt_expr = 'tcp\|udp\|ip\|icmp\|syn\|ack\|port\|saddr\|daddr\|accept\|drop\|reject\|return'

" Define the rule region with start= matching the first token and highlighting it as nftStmtHead
syntax region nftRule
  \ start=/^\s*\%(\%(masquerade\|rtclassid\|continue\|tcp\|udp\|ip\|icmp\|add\|delete\|set\)\)/
  \ matchgroup=nftStmtHead
  \ end=/;\s*$\|^\s*$\|^\s*\%(masquerade\|rtclassid\|continue\|tcp\|udp\|ip\|icmp\|add\|delete\|set\)\>\|^\s*}/
  \ contains=nftStmtExpr,nftComment
  \ keepend

" Highlight stmt expression tokens inside the rule region
syntax match nftStmtExpr /\v\<(' . s:stmt_expr . ')\>/ contained

" Comments
syntax match nftComment /^#.*$/

" Highlight groups
highlight default link nftStmtHead Keyword
highlight default link nftStmtExpr Identifier
highlight default link nftComment Comment

let b:current_syntax = "nftables"
```

How it works

* When a line starts with one of the stmt_head tokens, that token gets nftStmtHead highlight.
* Inside the rule body, tokens from stmt_expr get nftStmtExpr.
* Comments get Comment.
* Rules can span multiple lines, ending at ;, blank line, new statement start, or closing }.


You said:

wait a minute, 'tcp' keyword could be part of the continuation line of the same rule statement?  How do you distinguish between nftStmtHead and nftStmtExpr?

ChatGPT said:

Since your rule statements can be multi-line, and tcp can appear both as:

* The first token on the first line of a rule → nftStmtHead

* Later on any continuation line inside the same multi-line rule → nftStmtExpr

How Vim syntax handles this distinction:

* The start= pattern only applies to the very first token on the first line that begins the syntax region (nftRule).
* That first token matched by start= is assigned the matchgroup=nftStmtHead highlight.
* The rest of the rule, including all continuation lines inside the nftRule region, are parsed by contained matches.
* Inside the region, your syntax match nftStmtExpr highlights any occurrences of tcp (or other tokens) as expression tokens.
* So only the first line’s first token is nftStmtHead, all other tcp occurrences inside the region are nftStmtExpr.

Visualizing:

```nft
tcp port >= 22 accept
│^^^^^^^ ← first 'tcp' token, start= matches it, highlighted as nftStmtHead

    ip saddr == 127.0.0.1 tcp syn
                     └─ later 'tcp' inside same rule region, matched by nftStmtExpr
```

Important:

* Vim syntax regions are line-based but can span multiple lines.
* start= matches only the first line that opens the region.
* matchgroup= in start= applies only to that matched token.
* Inside the region, your contained matches apply to all lines, continuation or not.

So your tcp keyword is highlighted differently depending on context automatically — no ambiguity.

If you want, I can help craft a minimal test file + syntax to show this behavior clearly!

You said:
So, the dirty of Vimscript syntax region is the 'matchgroup='?

ChatGPT said:

Exactly — matchgroup= is the magic trick here! ✨

It lets you highlight the specific part of the start= pattern differently from the rest of the region’s content.

In your case:

* The first token that starts the syntax region (like tcp on the first line) gets matchgroup=nftStmtHead highlighting.
* Everything else inside the region is highlighted by whatever contained matches you define (like nftStmtExpr for inner tcps).

Without matchgroup=, the entire matched start= pattern would get the same highlight, losing that fine-grained semantic difference.

So yes, matchgroup= is the Vimscript syntax “dirty little secret” to selectively highlight the start token differently while still using the same token name elsewhere inside the region!

