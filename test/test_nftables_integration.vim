" test_nftables_integration.vim
new
setlocal buftype=nofile
setlocal bufhidden=wipe
"setlocal filetype=nftables
"setlocal syntax=nftables

" Read I&T nftables ruleset file
silent 0read ultimate-chain-map_stmt_expr.nft

setfiletype nftables
runtime! syntax/nftables.vim

syntime on
syntax sync fromstart
redraw!
syntime report

