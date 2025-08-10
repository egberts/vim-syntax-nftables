
" Where `$`identifier Is Allowed
" Context Allowed         Example                      Notes
" Rule expressions        tcp dport $SSH_PORT          $SSH_PORT must be defined before use
" Verdict expressions     jump $CHAIN                  Used in jump, goto, accept, etc.
" Set elements            ip saddr { $HOME_NET }       For dynamic sets
" Statements (rhs_expr)   counter name $COUNTER_NAME   Used in object declarations
" Maps                    define PORTMAP = { 22 : $SSH_LABEL }  Values may reference other defined symbols
" Quoted strings          meta mark set "$MARK_VALUE"  Quoted variables are still expanded


" ('accept'|'drop'|'continue'|'return')->verdict_expr->(verdict_stmt|set_rhs_expr)
hi link   nft_verdict_expr_keywords_unchained nftHL_Command
syn match nft_verdict_expr_keywords_unchained "\v(accept|drop|continue|return)" skipwhite contained
\ nextgroup=
\    nft_EOS

" verdict_expr->(verdict_stmt|set_rhs_expr)
syn cluster nft_c_verdict_expr
\ contains=
\    nft_verdict_expr_keywords_unchained,
\    nft_verdict_expr_keywords_chain_expr,
