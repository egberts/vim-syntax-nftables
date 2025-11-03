" test_nft_ct.vim
"
" Harness to profile performance of nft_ct.vim syntax
" Run with:   vim -u NONE -S test_nft_ct.vim

" Load our syntax file (adjust path if needed)
runtime! syntax/nftables.vim

" Use a scratch buffer with nft filetype
new
setlocal filetype=nft_ct
setlocal syntax=nft_ct

" Insert some sample nftables ct statements
call setline(1, [ 'ct state new accept', 'ct original saddr 192.168.0.1', 'ct original daddr 2001:db8::1', 'ct protocol tcp', 'ct mark set 0x1234', 'ct zone set 5', 'ct helper "ftp"', 'ct expectation set ip saddr 10.0.0.1', 'ct timeout set 30s', 'ct bytes over 100M drop' ])

" Turn on syntax timing
syntime on

" Force a full syntax parse from start
syntax sync fromstart
redraw!

" Print results
syntime report

" Keep Vim open for inspection
echo "Syntax timing complete. Use :syntime report again after edits."

