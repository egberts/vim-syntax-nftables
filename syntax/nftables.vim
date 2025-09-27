" ~/.vim/syntax/nftables.vim
" Vim syntax file for nftables configuration file

let g:nft_debug = 0

" TODO: Decide if parent directory is needed here
let g:nft_current_script_file_name = fnamemodify(expand('<sfile>:p'), ':p:t')
" echom 'nft_current_script_file_name: ' . g:nft_current_script_file_name

call nftables#syntax#debug('Begin')

" Standard early exit for syntax
if exists('b:current_syntax')
  finish
endif

" --- cpo guard start ---
let s:cpo_save = &cpo
set cpo&vim
" -----------------------


let s:files = ['common_block_early.vim', 'common_block.vim']

" go up to root ~/.vim, then down to 'after/syntax/nftables'
let s:dir = fnamemodify(expand('<sfile>'), ':p:h') . '/../custom/nftables/'

if exists('g:nft_debug') && g:nft_debug >= 1
  echo 'Use `:messages` for log details'
endif
" experiment with loading companion colorscheme
if exists('nft_colorscheme') && g:nft_colorscheme == 1
  try
    if exists('g:nft_debug') && g:nft_debug >= 1
      call nftables#syntax#log('INFO', 'Loaded \'nftables\' colorscheme.')
    endif
    colorscheme nftables
  catch /^Vim\%((\a\+)\)\=:E185/
    call nftables#syntax#log('WARN', 'WARNING: nftables colorscheme is missing'
    " deal with it
  endtry
else
  call nftables#syntax#debug('No nftables colorscheme loaded.')
endif

if !exists('&background') || empty(&background)
  " if you want to get value of background, use `&background ==# dark` example
  let nft_obtained_background = 'no'
else
  let nft_obtained_background = 'yes'
endif

let nft_truecolor = 'no'
if !empty($TERM)
  call nftables#syntax#log('OK', '$TERM is defined as ' . $TERM)
  if $TERM ==# 'xterm-256color' || $TERM ==# 'xterm+256color'
    if !empty($COLORTERM)
      if $COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit'
        let nft_truecolor = 'yes'
        call nftables#syntax#debug('$COLORTERM is \'truecolor\'')
      else
        call nftables#syntax#log('WARN', '$COLORTERM is not \'truecolor\'')
      endif
    else
      call nftables#syntax#debug('$COLORTERM is empty')
    endif
  else
    call nftables#syntax#debug('$TERM is not xterm-256color')
  endif
else
  call nftables#syntax#debug('$TERM is empty/undefined.')
endif

if exists(&background)
  let nft_obtained_background=execute(':set &background')
endif

if exists('b:current_syntax')
  " Quit when a (custom) syntax file was already loaded
  finish
endif

call nftables#syntax#debug('nft_obtained_background:' . nft_obtained_background)
call nftables#syntax#debug('nft_truecolor: ' . nft_truecolor)
if exists('g:saved_nft_t_Co')
  call nftables#syntax#debug('saved t_Co ' . g:saved_nft_t_Co)
else
  call nftables#syntax#debug('t_Co ' . &t_Co)
endif
if has('termguicolors')
  if &termguicolors == v:true
    call nftables#syntax#debug('Using guifg= and guibg=')
  else
    call nftables#syntax#debug('Using ctermfg= and ctermbg=')
  endif
endif


syntax sync fromstart
syn case match
syn sync clear
syn sync maxlines=1000
syn sync match nftablesSync grouphere NONE '^\s*(counter|table|rule|add {1,15}rule|table|chain|set)'
" syn sync fromstart '^(monitor|table|set)'
" syn sync fromstart

" iskeyword severely impacts '\<' and '\>' atoms
" setlocal iskeyword=.,48-58,A-Z,a-z,\_,\/,-
setlocal isident=.,48-58,A-Z,a-z,\_



" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if v:version >= 508 || !exists('did_nftables_syn_inits')
  if v:version < 508
    let did_nftables_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink nftHL_Type         Type
  HiLink nftHL_Command      Command
  HiLink nftHL_Statement    Statement
  HiLink nftHL_Number       Number
  HiLink nftHL_Comment      Comment
  HiLink nftHL_String       String
  HiLink nftHL_Label        Label
  HiLink nftHL_Keyword      Tag
  HiLink nftHL_Boolean      Boolean
  HiLink nftHL_Float        Float
  HiLink nftHL_Identifier   Identifier
  HiLink nftHL_Constant     Constant
  HiLink nftHL_SpecialComment SpecialComment
  HiLink nftHL_Error        Error
  HiLink nftHL_Separator    Delimiter
  HiLink nftHL_Define       Define

  hi link Command               Statement

hi def link nftHL_String      String
hi def link nftHL_Variable    Variable
hi def link nftHL_Comment     Uncomment

hi def link nftHL_Include     Include
hi def link nftHL_ToDo        Todo
hi def link nftHL_Identifier  Identifier
hi def link nftHL_Number      Number
hi def link nftHL_Option      Label     " could use a 2nd color here
hi def link nftHL_Operator    Conditional
hi def link nftHL_Underlined  Underlined
hi def link nftHL_Error       Error
hi def link nftHL_Constant    Constant

hi def link nftHL_Command     Command
hi def link nftHL_Statement   Statement
hi def link nftHL_Expression  Conditional
hi def link nftHL_Type        Type

hi def link nftHL_Family      Underlined   " doesn't work, stuck on dark cyan
hi def link nftHL_Table       Identifier
hi def link nftHL_Chain       Identifier
hi def link nftHL_Rule        Identifier
hi def link nftHL_Map         Identifier
hi def link nftHL_Set         Identifier
hi def link nftHL_Element     Identifier
hi def link nftHL_Quota       Identifier
hi def link nftHL_Position    Number
hi def link nftHL_Limit       Number
hi def link nftHL_Handle      Number
hi def link nftHL_Flowtable   Identifier
hi def link nftHL_Device      Identifier
hi def link nftHL_Member      Identifier

hi def link nftHL_Verdict     Underlined
hi def link nftHL_Hook        Type
hi def link nftHL_Action      Special
hi def link nftHL_Delimiters  Normal
hi def link nftHL_BlockDelimiters  Normal
hi def link nftHL_Write        NonText

endif


try
  " Main syntax definitions here
  syntax match nft_add_cmd '\vadd' skipwhite
\ nextgroup=
\    nft_common_block_keyword_define
  syntax keyword nftKeyword table chain rule add delete
  syntax match nftComment '#.*$'
  syntax match nftString '"[^"]*"'
  syntax match nftNumber '\d\+'

  highlight default link nftKeyword Keyword
  highlight default link nftComment Comment
  highlight default link nftString String
  highlight default link nftNumber Number

  call nftables#syntax#log('INFO', 'syntax/nftables.vim: files: ' . string(s:files))
  for file in s:files
    try
      call nftables#syntax#log('OK', 'syntax/nftables.vim Loading ' . file)
      execute 'source ' . s:dir . file
      call nftables#syntax#debug('syntax/nftables.vim ' . file . ' loaded.')
      " if nftables#syntax#check_syntax_group('nft_identifier')
      "   call nftables#syntax#log('OK', 'nft_identifier defined outside.')
      " else
      "   call nftables#syntax#log('ERROR', 'nft_identifier NOT DEFINED OUTSIDE!')
      " endif
    catch
      echohl ErrorMsg
      call nftables#syntax#log('ERROR', 'Error loading: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
      echohl None
    endtry
  endfor

  call nftables#syntax#debug('Main syntax definitions loaded for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define main syntax: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

      if nftables#syntax#check_syntax_group('nft_identifier')
        call nftables#syntax#log('OK', 'last pass: nft_identifier defined outside.')
      else
        call nftables#syntax#log('ERROR', 'last pass: nft_identifier NOT DEFINED OUTSIDE!')
      endif

let g:nft_current_script_file_name = empty(g:nft_script_name_stack) ? '' : remove(g:nft_script_name_stack, -1)

" --- cpo guard end ---
let &cpo = s:cpo_save
unlet s:cpo_save
" ---------------------

let b:current_syntax = 'nftables'
call nftables#syntax#debug('End')

