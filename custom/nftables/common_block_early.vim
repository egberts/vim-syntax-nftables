" File: common_block_early.vim
" Directory: custom/nftables
" Title: common_block semantic action, early

let s:list_filepaths_semantic_early = []
let s:list_filepaths_semantic_later = []

if exists('b:did_nftables_common_block_early')
  call nftables#syntax#log('INFO', 'Skipped common_block_early.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"

" non-terminal semantic action processing
for s:this_semantic_file in s:list_filepaths_semantic_early
  call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
  call nftables#syntax#load(s:this_semantic_file)
  call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
endfor
call nftables#syntax#debug('Loading common_block_early syntax ...' )


" INSERT 'syntax match' here
" INSERT 'syntax region' here
" INSERT 'syntax cluster' here
"

for s:this_semantic_file in s:list_filepaths_semantic_later
  call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
  call nftables#syntax#load(s:this_semantic_file)
  call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
endfor
call nftables#syntax#log('INFO', 'Loaded common_block_early for buffer: ' . bufname('%'))


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_terminal = v:true
