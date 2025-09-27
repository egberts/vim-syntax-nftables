" ~/.vim/autoload/nftables/syntax.vim
if exists('g:nft_debug') && g:nft_debug >= 2
  echomsg '[~/.vim/autoload/nftables/syntax.vim] Begin'
endif

" Initialize stack if not exists
if !exists('g:nft_script_name_stack')
  let g:nft_script_name_stack = []
endif

" Store script filename (without extension) in snake_case
let s:script_name = substitute(expand('<sfile>:t:r'), '-', '_', 'g')
let s:script_name_abs = resolve(s:script_name)
" Store parent directory name
let s:script_dir = fnamemodify(expand('<sfile>:h:t'), ':t')
let s:script_dir_abs = resolve(s:script_dir)

let s:script_file_name = s:script_dir . '/' . s:script_name
"""""""""""""let g:nft_current_script_file_name = s:script_file_name
" Mmmmm peek
" echo 'script_name is ' . s:script_name
" echo 'script_name_abs is ' . s:script_name_abs
" echo 'script_dir is ' . s:script_dir
" echo 'script_dir_abs is ' . s:script_dir_abs

function! s:FormatThrowpoint(throwpoint) abort
  let l:parts = split(a:throwpoint, '[[:space:]\[\]]\+')
  let l:pretty = ''
  for part in l:parts
    if part =~# '\.vim' || part =~# '\v^\d+$'
      let l:pretty .= (l:pretty == '' ? '' : ' -> ') . part
    endif
  endfor
  return l:pretty == '' ? a:throwpoint : l:pretty
endfunction


function! nftables#syntax#extract_until_bracket(str) abort
  let l:end = match(a:str, '\]')
  if l:end == -1
    return a:str
  endif
  return strpart(a:str, 0, l:end + 1)
endfunction


function! nftables#syntax#extract_until_last_periods(str) abort
  let l:end = match(a:str, '\.\.')
  if l:end == -1
    return a:str
  endif
  return strpart(a:str, 0, l:end + 1)
endfunction

function! s:ExtractAfterLastFunction(str) abort
  let l:last_function = strridx(a:str, 'function')
  if l:last_function == -1
    return a:str
  endif
  let l:start = l:last_function + len('function') + 1 " Skip 'function ' (note the space)
  return strpart(a:str, l:start)
endfunction

function! nftables#syntax#check_syntax_group(group_name) abort
  " Check if syntax group is defined using :syntax list
  redir => l:output
  silent! execute 'syntax list ' . a:group_name
  redir END
  if l:output =~# 'No Syntax items defined for ' . a:group_name
    call nftables#syntax#log('ERROR', 'Syntax group not defined: ' . a:group_name)
    return 0
  endif
  call nftables#syntax#log('INFO', 'Syntax group exists: ' . a:group_name)
  return 1
endfunction

function! nftables#syntax#check_highlight_name(group_name) abort
  " Check if highlight group is defined using synID
  let l:syn_id = synIDtrans(synID(a:group_name, 0, 1))
  if l:syn_id == 0
    call nftables#syntax#log('ERROR', 'Highlight group not defined: ' . a:group_name)
    return 0
  endif
  call nftables#syntax#log('INFO', 'Highlight group exists: ' . a:group_name)
  return 1
endfunction

function! nftables#syntax#get_caller_info() abort
  " Use g:nft_current_script_file_name if set, else parse v:throwpoint or fallback to <sfile>
  if exists('g:nft_current_script_file_name') && g:nft_current_script_file_name != ''
    """echom '#get_caller_info() g:nft_current_script_file_name: ' . g:nft_current_script_file_name
    let l:script_file = g:nft_current_script_file_name
  elseif exists('v:throwpoint') && v:throwpoint != ''
    let l:parts = split(v:throwpoint, '\.\.')
    for l:part in l:parts
      if l:part =~# 'script \S*\.vim'
        let l:script_file = matchstr(l:part, '\S*\.vim')
        return {
              \ 'name': fnamemodify(l:script_file, ':t:r'),
              \ 'dir': fnamemodify(l:script_file, ':p:h:t')
              \ }
      endif
    endfor
    let l:script_file = expand('<sfile>:p')
  else
    let l:script_file = expand('<sfile>:p')
  endif
  return {
        \ 'name': fnamemodify(l:script_file, ':t:r'),
        \ 'dir': fnamemodify(l:script_file, ':p:h:t')
        \ }
endfunction

function! nftables#syntax#log(level, msg) abort
  let l:caller_info = nftables#syntax#get_caller_info()
  if a:level ==# 'OK'
    echohl Directory
  elseif a:level ==# 'INFO'
    echohl Comment
  elseif a:level ==# 'ERROR'
    echohl ErrorMsg
  else
    echohl None
  endif
  echomsg '[' . l:caller_info.dir . '/' . l:caller_info.name . '.vim][' . a:level . '] ' . a:msg
  echohl None
endfunction

function! nftables#syntax#debug(msg) abort
  if exists('g:nft_debug') && g:nft_debug >= 1
    let l:caller_info = nftables#syntax#get_caller_info()
    """"" echom 'l:caller_info: ' . string(l:caller_info)
    let l:msg_throwpoint = s:FormatThrowpoint(v:throwpoint)
    if l:msg_throwpoint
      let l:throwpoint_str = ' at ' . l:msg_throwpoint
    endif
    echomsg '[' . l:caller_info.dir . '/' . l:caller_info.name . '.vim][debug] ' . a:msg . msg_throwpoint
  endif
endfunction

function! nftables#syntax#load(file) abort
  let l:syntax_dir = expand('~/.vim/custom/nftables/')
  let l:filepath = l:syntax_dir . a:file
  call add(g:nft_script_name_stack, exists('g:nft_current_script_file_name') ? g:nft_current_script_file_name : '')
  let g:nft_current_script_file_name = l:filepath
  if !filereadable(l:filepath)
    call nftables#syntax#log('ERROR', 'File not found: ' . l:filepath . ' at ' . s:FormatThrowpoint(v:throwpoint))
    let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)
    return
  endif
  if exists('b:did_nftables_' . substitute(a:file, '\.vim$', '', ''))
    call nftables#syntax#log('INFO', 'Skipped ' . a:file . ' (already loaded for buffer: ' . bufname('%') . ')')
    let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)
    return
  endif
  try
    let l:current_buf = bufnr('%')
    execute 'buffer ' . l:current_buf
    execute 'source ' . fnameescape(l:filepath)
    let b:did_nftables_{substitute(a:file, '\.vim$', '', '')} = 1
    call nftables#syntax#log('INFO', 'Loaded ' . a:file . ' for buffer: ' . bufname('%'))
  catch
    let l:throwpoint_stack = matchstr(v:throwpoint, '.*\ze: Vim(let):E461')  " Extract stack before error
    let l:func_name = nftables#syntax#extract_until_last_periods(l:throwpoint_stack)
    call nftables#syntax#log('ERROR', 'Failed to source ' . a:file . ': ' . v:exception . ' in ' . l:func_name)
  endtry
  let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)
endfunction

function! nftables#syntax#define_match(group_name, contains_list, nextgroup_list, pattern, highlight_link, ...) abort
  let l:opts = get(a:000, 0, {})
  " echomsg 'g:nft_script_name_stack ' . string(g:nft_script_name_stack)
  " echomsg 'a:contains_list ' . string(a:contains_list)
  " echomsg 'a:nextgroup_list ' . string(a:nextgroup_list)
  " echomsg 'a:pattern ' . a:pattern
  " echomsg 'a:highlight_link ' . a:highlight_link
  " echomsg 'l:options ' . string(opts)
  call add(g:nft_script_name_stack, exists('g:nft_current_script_file_name') ? g:nft_current_script_file_name : '')
  let g:nft_current_script_file_name = nftables#syntax#extract_until_bracket(expand('<sfile>:p:t'))
  " echomsg 'g:nft_current_script_file_name ' . g:nft_current_script_file_name
  let l:child_group_name = a:group_name 
  " echomsg 'l:child_group_name ' . l:child_group_name
  let l:escaped_pattern = substitute(a:pattern, '"', '\\"', 'g')
  " echomsg 'l:escaped_pattern ' . l:escaped_pattern
  let l:cmd = 'syn match ' . l:child_group_name . ' ' . string(l:escaped_pattern)
  " echomsg 'l:cmd:  ' . l:cmd
  if !empty(a:contains_list)
    " echomsg 'a:contains_list ' . string(a:contains_list)
    let l:cmd .= ' contains=' . join(a:contains_list, ',')
    " echomsg 'l:cmd (result) ' . l:cmd
  endif
  " echomsg 'l:cmd ' . l:cmd
  if !empty(a:nextgroup_list)
    " echomsg 'a:contains_list ' . string(a:contains_list)
    let l:cmd .= ' nextgroup=' . join(a:nextgroup_list, ',')
    " echomsg 'l:cmd (result) ' . l:cmd
  endif
  " echomsg 'l:cmd ' . l:cmd
  if !empty(l:opts)
    if has_key(l:opts, 'skipwhite')
      let l:cmd .= ' skipwhite'
    endif
    " echomsg 'l:cmd ' . l:cmd
    if has_key(l:opts, 'contained')
      let l:cmd .= ' contained'
    endif
    " echomsg 'l:cmd ' . l:cmd
  else
    " echomsg 'l:cmd (final logic) ' . l:cmd
    " default option is 'skipwhite,contained'
    let l:cmd .= ' skipwhite contained'
  endif
  try
    execute l:cmd
    " echomsg 'autoload/syntax.vim: done "syntax match"'
    if !empty(a:highlight_link)
      " echomsg 'autoload/syntax.vim: got a highlight link'
      execute 'hi def link ' . l:child_group_name . ' ' . a:highlight_link
      " echomsg 'hi def link ' . l:child_group_name . ' ' . a:highlight_link
      " echomsg 'autoload/syntax.vim: finished highlighting a link'
    endif
    call nftables#syntax#log('INFO', 'Defined LL(1) match for ' . l:child_group_name)
  catch
    let l:func_name = nftables#syntax#extract_until_last_periods(v:throwpoint)
    call nftables#syntax#log('ERROR', 'Failed LL(1) match for ' . l:child_group_name . ': ' . v:exception . ' in ' . l:func_name)
  endtry
  let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)
endfunction

function! nftables#syntax#reload() abort
  call add(g:nft_script_name_stack, exists('g:nft_current_script_file_name') ? g:nft_current_script_file_name : '')
  let g:nft_current_script_file_name = expand('~/.vim/syntax/nftables.vim')
  try
    let l:current_filetype = &filetype
    let l:current_buf = bufnr('%')
    syntax clear
    for var in keys(b:)
      if var =~# '^did_nftables_'
        unlet b:[var]
      endif
    endfor
    let &filetype = l:current_filetype
    if l:current_filetype ==# 'nftables'
      execute 'source ' . fnameescape(expand('~/.vim/syntax/nftables.vim'))
      call nftables#syntax#log('OK', 'Syntax reloaded for buffer: ' . bufname('%'))
    else
      call nftables#syntax#log('INFO', 'No reload: buffer filetype is ' . l:current_filetype)
    endif
  catch
    let l:func_name = nftables#syntax#extract_after_last_function(v:throwpoint)
    call nftables#syntax#log('ERROR', 'Failed to reload syntax: ' . v:exception . ' in ' . l:func_name)
  endtry
  let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)
endfunction

if exists('g:nft_debug') && g:nft_debug >= 2
  echomsg '[~/.vim/autoload/nftables/syntax.vim] End'
endif

