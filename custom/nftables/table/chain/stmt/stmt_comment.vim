" File: stmt_comment.vim
" Directory: custom/nftables/table/chain/stmt/
"
let s:stmt_comment_list_filepaths_semantic_early = []
let s:stmt_comment_list_filepaths_semantic_later = []

if exists('b:did_nftables_stmt_comment')
  call nftables#syntax#log('INFO', 'Skipped stmt_comment (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:stmt_comment_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading stmt_comment syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "


" add_cmd 'table' table_block 'chain' chain_block comment_spec 'comment' string
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_unquoted nftHL_Comment
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_unquoted "\v[a-zA-Z][a-zA-Z0-9\\\/_\[\]]{0,63}" keepend contained

hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_double_quote nftHL_Comment
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_double_quote "\v[a-zA-Z][a-zA-Z0-9\\\/_\[\]\"]{0,63}" keepend contained

hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_single_quote nftHL_Comment
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_single_quote "\v[a-zA-Z][a-zA-Z0-9\\\/_\[\]\']{0,63}" keepend contained

hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_single nftHL_Comment
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_single start="'" skip="\\'" end="'" keepend oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_double_quote

hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_double nftHL_Comment
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_double start="\"" skip="\\\"" end="\"" keepend oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_sans_single_quote

syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_quoted_string
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_single,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_double

hi link     nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string nftHL_Comment
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_unquoted,
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_asterisk_string

" add_cmd 'table' table_block 'chain' chain_block comment_spec 'comment'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec "comment" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string


  for s:this_semantic_file in s:stmt_comment_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded stmt_comment for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define stmt_comment.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_stmt_comment = v:true
