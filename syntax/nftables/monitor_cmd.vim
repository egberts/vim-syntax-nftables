" File: monitor_cmd.vim
" Directory: custom/nftables/
"
let s:monitor_cmd_list_filepaths_semantic_early = []
let s:monitor_cmd_list_filepaths_semantic_later = []

if exists('b:did_nftables_monitor_cmd')
  call nftables#syntax#log('INFO', 'Skipped monitor_cmd (already loaded for buffer: ' . bufname('%') . ')')
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
  for s:this_semantic_file in s:monitor_cmd_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading monitor_cmd syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "

" **************** START monitor_cmd ***************
" monitor_event (via monitor_cmd)
hi link   nft_monitor_cmd_monitor_format_keyword_xml nftHL_Keyword
syn match nft_monitor_cmd_monitor_format_keyword_xml '\vxml\ze[ \t;\n]' skipwhite keepend contained

hi link   nft_monitor_cmd_monitor_format_keyword_json nftHL_Keyword
syn match nft_monitor_cmd_monitor_format_keyword_json '\vjson\ze[ \t;\n]' skipwhite keepend contained

hi link   nft_monitor_cmd_monitor_format_keyword_vm_keyword_json nftHL_Keyword
syn match nft_monitor_cmd_monitor_format_keyword_vm_keyword_json '\vvm\s+json\ze[ \t;\n]' skipwhite keepend contained

" monitor_cmd monitor_object (via monitor_cmd)
hi link   nft_monitor_cmd_monitor_object_keyword_elements nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_elements '\velements\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_ruleset nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_ruleset '\vruleset\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_chains nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_chains '\vchains\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_tables nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_tables '\vtables\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_rules nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_rules '\vrules\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_trace nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_trace '\vtrace\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_sets nftHL_Keyword
syn match nft_monitor_cmd_monitor_object_keyword_sets '\vsets\ze[ \t;\n]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

" monitor_cmd monitor_event (via base_cmd)
hi link   nft_monitor_cmd_monitor_event_keyword_destroy nftHL_Keyword
syn match nft_monitor_cmd_monitor_event_keyword_destroy '\vdestroy\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_object_keyword_elements,
\    nft_monitor_cmd_monitor_object_keyword_ruleset,
\    nft_monitor_cmd_monitor_object_keyword_chains,
\    nft_monitor_cmd_monitor_object_keyword_tables,
\    nft_monitor_cmd_monitor_object_keyword_rules,
\    nft_monitor_cmd_monitor_object_keyword_trace,
\    nft_monitor_cmd_monitor_object_keyword_sets,
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_event_keyword_new nftHL_Keyword
syn match nft_monitor_cmd_monitor_event_keyword_new '\vnew\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_object_keyword_elements,
\    nft_monitor_cmd_monitor_object_keyword_ruleset,
\    nft_monitor_cmd_monitor_object_keyword_chains,
\    nft_monitor_cmd_monitor_object_keyword_tables,
\    nft_monitor_cmd_monitor_object_keyword_rules,
\    nft_monitor_cmd_monitor_object_keyword_trace,
\    nft_monitor_cmd_monitor_object_keyword_sets,
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

" 'monitor'->base_cmd->line
hi link   nft_base_cmd_keyword_monitor nftHL_Command
syn match nft_base_cmd_keyword_monitor '\vmonitor\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_object_keyword_elements,
\    nft_monitor_cmd_monitor_event_keyword_destroy,
\    nft_monitor_cmd_monitor_object_keyword_ruleset,
\    nft_monitor_cmd_monitor_object_keyword_chains,
\    nft_monitor_cmd_monitor_object_keyword_tables,
\    nft_monitor_cmd_monitor_object_keyword_trace,
\    nft_monitor_cmd_monitor_object_keyword_rules,
\    nft_monitor_cmd_monitor_object_keyword_sets,
\    nft_monitor_cmd_monitor_event_keyword_new,
\    nft_Error
" **************** END monitor_cmd ***************


  for s:this_semantic_file in s:monitor_cmd_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded monitor_cmd for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define monitor_cmd.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_monitor_cmd = v:true
