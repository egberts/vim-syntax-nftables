" File: limit.vim
" Directory: custom/nftables/
"
" "
" Syntax                    Context     Production        Valid?
" limit l1 accept           Rule        objref_stmt_limit YES
" limit l1 rate 10/second   Definition  limit_stmt         NO
" limit { rate 10/second }  Block       limit_block       YES
" add limit T L rate ...    Object      addlimit_config   YES

"            inline        object ref  define
" Context   'limit rate'  'limit L'   'limit L { rate ... }'
" base_cmd       NO            YES        YES!
"                            limit T L rate 5/second
"                                         (block not allowed)
" table_block    NO            NO         YES
"                             limit L { rate 5/second }
" chain_block    YES          YES          NO
" map_block      YES          YES          NO
" set_block      YES          YES          NO
"
"
let s:limit_list_filepaths_semantic_early = [
\        'limit/limit_block.vim',
\        'limit/limit_config.vim',
\    ]
let s:limit_list_filepaths_semantic_later = []

if exists('b:did_nftables_limit')
  call nftables#syntax#log('INFO', 'Skipped limit (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:limit_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading limit syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" base_cmd add_cmd 'limit'
" identical to 'add limit'
" for 'add limit', see add_limit_cmd.vim file
hi link   nft_base_cmd_add_cmd_keyword_limit nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_limit "\vlimit\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_family_spec,
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier



  for s:this_semantic_file in s:limit_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded limit for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define limit.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_limit = v:true
