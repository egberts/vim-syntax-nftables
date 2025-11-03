" Hybrid harness: open the real .nft test file and attach nftables syntax
" Run with: vim -u NONE -S test_nftables_hybrid.vim

" -------------------------
" test_nftables_hybrid.vim
" Fully-deterministic LL(1) syntax test harness for nftables Vimscript
" -------------------------
let s:script_dir = expand('<sfile>:p:h')

" Start clean
set nocompatible
syntax off
filetype plugin off
filetype indent off

" 1) Open scratch buffer
enew
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile

" 4) Read the test .nft file
0delete _
0read ultimate-chain-map_stmt_expr.nft

filetype detect
setlocal filetype=nftables

" 5) Enable syntax and start timing
syntax enable
syntax sync fromstart
syntime on

" 6) Force redraw to fully parse buffer
redraw!

" 7) Capture syntax timing report
redir > ~/nft_syntax_report.txt!
syntime report
redir END


" -------------------------
" Optional: keep the buffer open for visual inspection
" -------------------------
echo "Syntax test complete. Report written to ~/nft_syntax_report.txt"

