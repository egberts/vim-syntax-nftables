Ok.  I am at this last stage of doing EBNF to LL(1) translation: the `stmt` symbol.

Some preparations needed are:

* Aggregate all the first encounter of terminal symbols pointed to by this 'stmt' non-terminal symbol
* * This entails deep navigation of all pathways until each first encounter of a terminal symbol (token keyword) is found
* * DHparser tool solves this problem.
* Reconcile multiple but disparate pathways together to that same first-encounter terminal symbol (translating to LL(1)).
* * This entails smashing graph branches together (no tools available)

If we are going to master the full pathways of all keywords hanging off of 'stmt', we must observe the following limitation f Vimscript:

# Terminology
Terminology used here in this document are both derived from Bison LEX/YACC and Vimscript syntax.

| Bison | Vimscript                                                                        |
|----|----------------------------------------------------------------------------------|
| symbol | group                                                                            |
| symbol name | group name                                                                       |
| terminal symbol | `syntax match` (or  `syntax keyword` that we do not use) |
| non-terminal symbol | `syntax cluster`                                                                 |
| state transition | between a `syntax match` group name and its `nextgroup=` / `contains=` groupname |
| token | keyword                                                                          |


# Vimscript limitation with LL(1)

1. The same regex cannot be used inside as well as outside a defined block region.  Regex duplication and unique group names are a must.

Cannot reuse a Bison symbol across defined block regions (also called Vimscript 'syntax region') boundaries; must duplicate Bison symbol by prepending a different pathway prefix.

Ideal naming convention for nftable Bison 'stmt' semantic action symbolc that is 
found in the following commands:

    add chain T C <stmt>  # add_cmd
    add rule T C <stmt>  # add_cmd
    rule T C <stmt>   # add_cmd
    insert rule T C <stmt>  # insert_cmd
    replace rule T C <stmt>  # replace_cmd
    table T { chain C { <stmt>; }  # chain_block
    table T { chain C { jump { <stmt> }; }  # chain_stmt

would be to note boundaries of '{' braces as 'syntax region's. 

The 'stmt' in 'add chain' is top-level region.  So is 'add rule'.
Also 'rule T C <stmt>'.

The 'stmt' in 'table T { chain {' is in 3rd-level block region (2-nested), 
we cannot reuse the same Vimscript group name inside a different region 
without breaking its `start=`/`end=` mechanism that neatly parse the boundaries of 
each block region.

If 'stmt' symbol is to be reused deeper inside nest block(s) (eg. the chain block inside table block), 
that 'stmt' group must be duplicated and its group name would have to be 
uniquely renamed, such as 'nft_chain_block_stmt'.

Recap of NFT commands and its group name:

    add chain T C <stmt>             nft_stmt
    add rule T C <stmt>              nft_stmt
    rule T C <stmt>                  nft_stmt
    insert rule T C <stmt>           nft_stmt
    replace rule T C <stmt>          nft_stmt
    table T { chain C { <stmt>; }    nft_table_block_chain_block_chain_rule_rule_alloc_stmt
    table T { chain C { jump { <stmt> }; }   nft_table_block_chain_block_chain_rul_rule_alloc_stmt_verdict_stmt_verdict_expr_chain_expr

The nft_table_block_chain_block_stmt group (`stmt`) be reused if they share the same parent region.  
'add chain', 'add rule', and 'rule' are the same level (top-level) region nesting.

Reuse of a group is ok if they are distant but disjoint relatives, but not directly related.
This means 'nft_stmt' can be reused for 'add rule', 'rule', as well as 'add chain'.  But not 'table { chain { rule ...'.

In short, duplicate/split and rename is only needed if direct 
ancestral/descendant pathway line is seen between two points of group names; 

I thought using the more simple `nft_chain_block_stmt` instead, but we 
have multiple nestings of blocks going on throughout the nftables syntax so seeing two(2) 
blocks in the group name would be a helpful reading/debugging aid.

It is paramount to be tracking the closing curly braces (NFT syntax) delimiter to ensure that it matches up with its paired starting curly brace delimiter.



