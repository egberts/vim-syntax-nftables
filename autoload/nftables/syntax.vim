" File: autoload/nftables.vim
" Description: Hybrid syntax loader for nftables
" License: MIT License. Copyright (c) 2025 Egbert Network et al.
"
" Usage from syntax/nftables.vim:
"   call nftables#syntax#load('nftables/root')

if exists('*nftables#syntax#load')
  echom('*nftables#syntax#load exists: early quit')
  finish
endif

let s:seen = {}
let s:depth = 0
let s:loaded = 0
let s:skipped = 0
let s:roots = 0
let s:files_loaded = []

" Capture the directory of this script itself
let s:syntax_autoload_dir = expand('<sfile>:p:h')
" Go up to root, then back down to 'syntax' subdirectory
let g:syntaxdir = resolve(expand('<sfile>:p:h:h') . '/../syntax/nftables/')

if !isdirectory(syntaxdir)
  echomsg 'Directory ' . syntaxdir . ' does not exists.'
  finish
endif

" Debug printer with indentation
function! nftables#syntax#debug(msg) abort
  if get(g:, 'nft_syntax_debug', 0)
    let l:prefix = repeat('  ', s:depth)
    echomsg l:prefix . 'DEBUG: ' . a:msg
  endif
endfunction

" Improved autoload/nftables/syntax.vim
" Provides nftables#syntax#load() with rich diagnostics.
" autoload/nftables/syntax.vim

" autoload/nftables/syntax.vim

function! nftables#syntax#log(level, msg) abort
  if a:level ==# 'OK'
    echohl Directory
  elseif a:level ==# 'INFO'
    echohl Comment
  elseif a:level ==# 'WARN'
    echohl WarningMsg
  elseif a:level ==# 'FAIL'
    echohl ErrorMsg
  else
    echohl None
  endif
  echom printf('[nftables#syntax#load][%s] %s', a:level, a:msg)
  echohl None
endfunction

function! nftables#syntax#load(file) abort
  let l:start = reltime()
  " call nftables#syntax#log('INFO', 'requested=' . a:file)
  " call nftables#syntax#log('INFO', 'syntaxdir=' . g:syntaxdir)

  let l:resolved = g:syntaxdir . '/' . a:file
  " call nftables#syntax#log('INFO', 'resolved=' . l:resolved)

  if !filereadable(l:resolved)
    call nftables#syntax#log('FAIL', 'file not found: ' . l:resolved)
    return
  endif

  try
    execute 'source' fnameescape(l:resolved)
    let l:elapsed = reltimestr(reltime(l:start))
    call nftables#syntax#log('OK', printf('sourced %s (elapsed %s)', a:file, l:elapsed))
  catch /.*/
    " Extract line number from v:throwpoint
    let throwpoint = v:throwpoint
    let line_number = matchstr(throwpoint, 'line \zs\d\+')
    call nftables#syntax#log('FAIL', 'error sourcing ' . a:file . ': ' . v:exception . ' at line ' . line_number)
  endtry
endfunction

" Internal: source a file once
function! s:SourceOnce(file) abort
  if has_key(s:seen, a:file)
    let s:skipped += 1
    call nftables#syntax#debug('already loaded ' . a:file)
    return
  endif
  let s:seen[a:file] = 1
  let s:loaded += 1
  call add(s:files_loaded, a:file)

  call nftables#syntax#debug('loading ' . a:file)

  try
    execute 'source' fnameescape(a:file)
  catch /^Vim\%((\a\+)\)\=:E/
    echoerr 'nftables: Error sourcing ' . a:file
    echoerr v:exception
    echoerr v:throwpoint
  endtry
endfunction

" Final summary (once after root calls)
function! s:MaybeSummary(is_root) abort
  if a:is_root
    let s:roots -= 1
    if s:roots == 0
      let l:summary = 'nftables: final summary: ' . s:loaded . ' loaded, ' . s:skipped . ' skipped'
      if get(g:, 'nft_syntax_debug', 0)
        echomsg l:summary
        for l:file in s:files_loaded
          echomsg '  ' . l:file
        endfor
      endif
      if exists('g:nft_syntax_logfile') && !empty(g:nft_syntax_logfile)
        try
          call writefile([l:summary] + map(copy(s:files_loaded), {_,v -> '  ' . v}), g:nft_syntax_logfile, 'a')
        catch
          echoerr 'nftables: Could not write logfile ' . g:nft_syntax_logfile
        endtry
      endif
    endif
  endif
endfunction

" vim: et ts=2 sts=2 sw=2
