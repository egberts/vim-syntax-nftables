" ~/.vim/syntax/nftables.vim
" Vim syntax file for nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     1.4.0015
" Initial Date: 2020-04-24
" Last Change:  2025-11-03
" Filenames:    nftables.conf, *.nft
" Location:     https://github.com/egberts/vim-syntax-nftables
" License:      MIT license
" Bug Report:   https://github.com/egberts/vim-syntax-nftables/issues
"
" Description:
"     nftables.vim is a nftables v1.1.4 Vimscript syntax file.
"
" Purpose: Define syntax highlighting for nftables configurations using a
" fully deterministic LL(1) full-syntax tree to ensure unambiguous, efficient
" parsing of complex nftables grammar with single-token lookahead.
"
"     Its naming convention mirrors nftables/src/parser_bison.y as closely as
"     possible.  Due to the LL(1) requirement of Vimscript syntax, translations
"     are required — most notably the intensive use of pull-ups.
"
"     Pull-ups are acts of navigating into deep expressions to note all
"     first-encountered TOKENs/keywords for that current semantic action.
"
"     This file is:
"       • A truly deterministic LL(1) syntax tree.
"       • Organized hierarchically in a two-tier structure (second-order and
"         first-order tokens).
"       • Anchored by the 'line' semantic action, which is the top-level root
"         node and the only one of two not using the 'contained' option.
"
"     Other major nexus semantic actions are 'map_stmt_expr' and 'stmt'.
"     Minor semantic nexus include: table_block, chain_block, set_block, etc.
"
"     Write statements are folded with read statements due to embedded 'set'
"     keywords, '@' map names, and 'update' commands.
"
" Vimrc Global Settings:
"    g:nftables_syntax_disabled
"    g:nft_colorscheme
"    g:nft_debug
"    g:loaded_syntax_nftables
"    g:syntax_on
"    b:current_syntax
"
" To turn debug in one of three ways:
"
"    - `vi --cmd 'let nft_debug=1' /etc/nftables.conf`
"    - insert `let nft_debug=1` into ~/.vimrc
"    - tweak nft_debug in syntax/nftables.vim
"
" Color Support:
"   This syntax supports both ANSI 256-color and ANSI TrueColor (16M colors).
"
"   For ANSI 16M TrueColor:
"     - ensure `$COLORTERM=truecolor` (or `=24bit`) at the command prompt
"     - ensure `$TERM=xterm-256color` (or `xterm+256color` in macOS)
"     - ensure `$TERM=screen-256color` (or `screen+256color` in macOS)
"
"   For ANSI 256-color:
"     - ensure `$TERM=xterm-256color` (or `xterm+256color` in macOS)
"     - ensure `$COLORTERM` is set to `color`, empty, or undefined
"
" Organization (in order):
"
"   Second-order tokens:
"     - map_stmt_list : converts list of statements into a node on parse tree
"     - expr_stmt     : expression to a statement (evoked by map_stmt_expr)
"
"   First-order tokens listed in Vimscript required most atomic to most wildy pattern:
"     - All error codes firstly
"     - *_expr        : All expressions (inside chain_block)
"     - map_stmt_expr : main nexus (inside chain_block)
"     - chain_block   : container for all chain statements
"     - rule_stmt     : write-type statements only (add/delete/insert/flush)
"     - verdict_expr  : 'accept', 'drop', 'goto', 'jump', 'continue', 'return'
"     - counter_stmt, log_stmt, limit_stmt, queue_stmt
"     - map_stmt, vmap_stmt (actual 'map'/'vmap', not nexus)
"     - functional commands: element, table, chain, ct, rule, limit, map, set
"     - family starters: ip, ip6, netdev, inet, bridge, arp
"     - management commands: delete, list, counter, create, reset, destroy,
"                            get, insert, flush, monitor, rename, replace
"     - table_block, set_block, common_block
"     - table_identifier
"     - base_cmd (add, describe, synproxy, counter, element, monitor, destroy)
"     - comments: '#' full-line, double-quote inline
"     - line (top-level semantic action, no 'contaained')
"
" Warnings:
"   - Do not use 'containedin=', computationally expensive.
"   - Do not add inline comments using a double-quote, it alters patterns.
"   - Do not use 'keepend' except in the most innermost region blocks.
"   - 'to', 'set', 'name' keywords ALL GOES thru `stmt_expr`
"   - map_stmt_expr is semantic, not the TOKEN/keyword 'map'
"
" Vimscript Limitations:
"   - doing synthetic concat of multiple statements remains a work-in-progress
"   - background setting does not change here, but if left undefined it remains unchanged
"   - colorscheme setting does not change here, but if left undefined it remains unchanged
"   - Vim 7+ attempts to guess the `background` based on term-emulation (ANSI OSC52)
"   - If background remains indeterminate, default is 'light' unless overridden in ~/.vimrc
"   - nftables variable name limit: upstream allows 256 chars; here capped at 64 chars
"   - nftables time_spec has no limit upstream; here capped at 11 chars
"         (should be at least 23 to handle '365d52w24h60m60s1000ms'; goal is 32)
"
" Vim Developer Notes:
"   - reloading this syntax will NOT update 'highlight link'/'highlight default link' statements
"   - reloading this syntax will NOT pull in 'autoload/nftables/syntax.cim'
"   - always add '\v' to any OR-combo list in `syntax match`
"   - place 'contained' keywords at EOL (code readability; ':verbose syntax list <group_name>' always place it firstly)
"   - strongly discourage use '?' in `match` statements, make multiple match statements
"   - 'contains=' ordering MATTERS in `cluster` statements
"   - nesting 'cluster' will FAIL in LL(1); must pull-up keywords to its 'nexus'
"   - inner-'region' benefits from 'keepend', not outer-regions.
"   - ordering: between 'contains=' and 'nextgroup=', first one wins
"   - ordering: within 'contains=' and 'nextgroup=', last one wins
"   - no trailing commas allowed in 'contains=' / 'nextgroup=' lists
"   - consider relocating inner_inet_expr to after th_hdr_expr
"
" File load order:
"   - syntax/nftables.vim is called before:
"       colors/nftables.vim
"       ftdetect/nftables.vim
"       ftplugin/nftables.vim
"       indent/nftables.vim

" Enable debug mode (0 = off, >=1 = on for logging).
if !exists('g:nft_debug')
    let g:nft_debug = 4
endif
echom 'nft_debug is ' . g:nft_debug

" Store the current script’s filename for stack-based logging.
" Used in LL(1) parsing to track script context for error reporting.
call nftables#syntax#push(expand('<sfile>'))

if exists('nft_syntax_disabled')
  call nftables#syntax#log('INFO', 'nftables syntax disabled (nft_syntax_disabled).')
  finish
endif

" Debug log to mark the start of script execution.
call nftables#syntax#log('OK', 'Begin')
if exists('g:nft_debug') && g:nft_debug == 1
  echom '[syntax/nftables][OK] Begin'
endif

if !exists('g:nft_colorscheme')
    echom printf('external nft_colorscheme is: %s', execute('colorscheme')[1:])
endif

let s:nftables_start_colors_name = execute('colorscheme')[1:]
let s:nftables_start_background = &background
echom printf("INFO: vimrc (start) colorscheme: %s", s:nftables_start_colors_name)
echom printf("INFO: vimrc (start) background: %s", s:nftables_start_background)
colorscheme koehler

" Double-check for syntax loading to prevent conflicts.
" Early exit if syntax is already loaded to prevent redefinition.
" Ensures LL(1) syntax rules are not duplicated, maintaining determinism.
if exists('b:current_syntax')
  finish
endif

" --- cpo guard start ---
" Save and reset 'compatible' option to ensure consistent Vimscript behavior.
let s:cpo_save = &cpo
set cpo&vim
" -----------------------

" List of companion syntax files to load.
" These files define specific syntax groups, forming the LL(1) syntax tree.
let s:list_filepaths_semantic_early = ['common_block_early.vim']
let s:list_filepaths_semantic_later = [
\     'set.vim',
\     'limit_cmd.vim',
\     'map_block.vim',
\     'flowtable_block.vim',
\     'counter_block.vim',
\     'quota_block.vim',
\     'ct_helper_block.vim',
\     'ct_timeout_block.vim',
\     'ct_expect_block.vim',
\     'secmark_block.vim',
\     'synproxy_block.vim',
\     'describe_cmd.vim',
\     'monitor_cmd.vim',
\     'replace_cmd.vim',
\     'destroy_delete_cmds.vim',
\     'create_cmd.vim',
\     'insert_cmd.vim',
\     'rename_cmd.vim',
\     'flush_cmd.vim',
\     'reset_cmd.vim',
\     'list_cmd.vim',
\     'add_cmd.vim',
\     'get_cmd.vim',
\     'common_block.vim',
\     'table.vim',
\    ]
" 'table.vim' is last one due to first keyword being a wildcard for `table <identifier>`

let s:nftables_filepath_this_script = resolve(expand('<sfile>:p'))
let s:nftables_dirpath_root = fnameescape(fnamemodify(s:nftables_filepath_this_script, ':h:h'))

let s:nftables_dirpath_custom_syntax = resolve(s:nftables_dirpath_root . '/custom')
if !isdirectory(s:nftables_dirpath_custom_syntax)
   echom 'ERROR: Custom syntax directory does not exist: ' . s:nftables_dirpath_custom_syntax
   finish
endif

" Define the directory for custom syntax files.
" Used to source additional files that extend the LL(1) grammar.
let g:nft_nftables_syntax_dirpath_custom_nftables = resolve(s:nftables_dirpath_custom_syntax . '/nftables')
if !isdirectory(g:nft_nftables_syntax_dirpath_custom_nftables)
   echom 'ERROR: Custom nftables syntax directory does not exist: ' . g:nft_nftables_syntax_dirpath_custom_nftables
   finish
endif

" Notify user to check logs if debug mode is enabled.
if exists('g:nft_debug') && g:nft_debug == 1
  echo 'Use `:messages`, `syntax list <group_name>` for details'
  echo 'Use `:verbose highlight <group_name>` for details'
endif

" Load companion colorscheme if enabled.
" Colorscheme enhances visual distinction of LL(1) syntax groups.
echo "g:nft_colorscheme: " . g:nft_colorscheme
if exists('g:nft_colorscheme') && g:nft_colorscheme == 1
  try
    if exists('g:nft_debug') && g:nft_debug == 1
      call nftables#syntax#log('INFO', 'Loaded \'nftables\' colorscheme.')
    endif
    colorscheme nftables
  catch /^Vim\%((\a\+)\)\=:E185/
    echohl Command
    call nftables#syntax#log('WARN', 'WARNING: nftables colorscheme is missing')
    echohl None
  endtry
else
  call nftables#syntax#debug('No nftables colorscheme loaded.')
endif

" Check terminal background setting for color adjustments.
" Ensures highlight groups align with terminal capabilities for clear LL(1) token visualization.
" used to determine which color bank to use (dark/light)
let current_background = &background
if empty(current_background)
  let nft_obtained_background = 'no'
else
  let nft_obtained_background = trim(execute('set background?'))
endif
let nft_obtained_background2 = &background
call nftables#syntax#log('OK', 'Current background:   ' . current_background)
call nftables#syntax#log('OK', 'Background obtained?: ' . nft_obtained_background)
call nftables#syntax#log('OK', 'Background obtained2?: ' . nft_obtained_background2)

" Check terminal color support for truecolor or 256-color mode.
" Critical for rendering highlight groups accurately in the LL(1) syntax tree.
let nft_truecolor = 'no'
if !empty($TERM)
  call nftables#syntax#log('OK', '$TERM is defined as ' . $TERM)
  if $TERM ==# 'xterm-256color' || $TERM ==# 'xterm+256color'
    if !empty($COLORTERM)
      if $COLORTERM ==# 'truecolor' || $COLORTERM ==# '24bit'
        let nft_truecolor = 'yes'
        call nftables#syntax#log('OK', '$COLORTERM is truecolor')
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
  call nftables#syntax#log('ERROR', '$TERM is empty/undefined.')
endif

" Log terminal and color settings for debugging.
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

syn case match

" Configure iskeyword/isident to handle nftables-specific identifiers.
" Ensures accurate token boundaries for LL(1) parsing of identifiers and keywords.
setlocal isident=.,48-58,A-Z,a-z,\_

" Define default highlighting groups with version checks.
" Uses 'default' in 'hi link' to respect user customizations, critical for LL(1) group flexibility.
if v:version >= 508 || !exists('did_nftables_syn_inits')
  if v:version < 508
    let did_nftables_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " Core highlight groups for nftables syntax elements.
  " Links map LL(1) syntax groups to Vim’s standard highlight groups for clarity.
  HiLink nftHL_Type         Type
  HiLink nftHL_Number       Number
  HiLink nftHL_Comment      Comment
  HiLink nftHL_String       String
  HiLink nftHL_Label        Label
  HiLink nftHL_Boolean      Boolean
  HiLink nftHL_Float        Float
  HiLink nftHL_Identifier   Identifier
  HiLink nftHL_Constant     Constant
  HiLink nftHL_SpecialComment SpecialComment
  HiLink nftHL_Error        Error
  HiLink nftHL_Separator    Delimiter
  HiLink nftHL_Define       Define


  hi def link nftHL_String      String
  hi def link nftHL_Variable    Variable
  hi def link nftHL_Comment     Comment

  hi def link nftHL_Include     Include
  hi def link nftHL_ToDo        Todo
  hi def link nftHL_Identifier  Identifier
  hi def link nftHL_Number      Number
  hi def link nftHL_Option      Label
  hi def link nftHL_Operator    Conditional
  hi def link nftHL_Underlined  Underlined
  hi def link nftHL_Error       Error
  hi def link nftHL_Constant    Constant


  hi def link nftHL_Write       SpecialKey
  hi def link nftHL_Expression  Conditional
  hi def link nftHL_Type        Type

  hi def link nftHL_Family      Underlined
  hi def link nftHL_Table       Identifier
  hi def link nftHL_Chain       Identifier
  hi def link nftHL_Rule        Identifier
  hi def link nftHL_Map         Identifier
  hi def link nftHL_AtSetname     Variable
  hi def link nftHL_SetIdentifier Identifier
  hi def link nftHL_Element     Identifier
  hi def link nftHL_Quota       Identifier
  hi def link nftHL_Position    Number
  hi def link nftHL_Limit       Number
  hi def link nftHL_Handle      Number
  hi def link nftHL_Flowtable   Identifier
  hi def link nftHL_Device      Identifier
  hi def link nftHL_Member      Identifier
  hi def link nftHL_Unit        MoreMsg

  hi def link nftHL_Verdict     Underlined
  hi def link nftHL_Hook        Type
  hi def link nftHL_Delimiters  Normal
  hi def link nftHL_BlockDelimiters Normal
endif

" Main syntax definitions for core nftables keywords and patterns.
" Uses LL(1) grammar to define top-level tokens with single-token lookahead.
try
  " Define basic syntax groups for nftables commands and literals.

  " Load companion syntax files to extend the LL(1) syntax tree.
  call nftables#syntax#log('OK', 'files_early: ' . string(s:list_filepaths_semantic_early))
  for s:this_semantic_file in s:list_filepaths_semantic_early
    try
      call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
      " execute 'source ' . g:nft_nftables_syntax_dirpath_custom_nftables . s:this_semantic_file
      call nftables#syntax#load(s:this_semantic_file)
      call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
    catch
      call nftables#syntax#log('ERROR', 'Error loading: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
    endtry
  endfor

echom "nft_obtained_background:" . nft_obtained_background2
if nft_obtained_background2 == "dark"
  echom "Background is using dark set of highlighters"
  hi def nftHL_BlockDelimitersTable  guifg=LightBlue ctermfg=LightRed ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersChain  guifg=LightGreen ctermfg=LightGreen ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSet  ctermfg=17 guifg=#0087af ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMap  ctermfg=17 guifg=#2097af ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersFlowTable  ctermfg=LightMagenta guifg=#950000 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCounter  ctermfg=LightYellow guifg=#109100 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersQuota  ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCT  ctermfg=Red guifg=#c09000 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersLimit  ctermfg=LightMagenta ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSecMark  ctermfg=LightYellow ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSynProxy  ctermfg=DarkGrey guifg=#118100 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMeter  ctermfg=Red guifg=#720000 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersDevices  ctermfg=Blue guifg=#303030 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersVerdict  ctermfg=Red guifg=#ff553e ctermbg=Black cterm=NONE
  hi def nftHL_Command      guifg=#feea2f guibg=NONE ctermfg=227 ctermbg=NONE cterm=bold gui=bold
  hi def nftHL_Statement    guifg=#f8d001 guibg=NONE ctermfg=227 ctermbg=NONE cterm=bold gui=bold
  hi def nftHL_Substatement guifg=#ebd401 guibg=NONE ctermfg=214 ctermbg=NONE
  hi def nftHL_Keyword      guifg=#e8b414 guibg=NONE ctermfg=208 ctermbg=NONE
else
  echo "Background is using light set of highlighters"
  hi def nftHL_BlockDelimitersTable  guifg=LightBlue ctermfg=LightRed ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersChain  guifg=LightGreen ctermfg=LightGreen ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSet  ctermfg=17 guifg=#ff7850 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMap  ctermfg=17 guifg=#df6850 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersFlowTable  ctermfg=LightMagenta guifg=#6affff ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCounter  ctermfg=LightYellow guifg=#ef6eff ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersQuota  ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCT  ctermfg=Red guifg=#3f6fff ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersLimit  ctermfg=LightMagenta ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSecMark  ctermfg=LightYellow ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSynProxy  ctermfg=DarkGrey guifg=#ee7eff ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMeter  ctermfg=Red guifg=#8dffff ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersDevices  ctermfg=Blue guifg=#cfcfcf ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersVerdict  ctermfg=Red guifg=#00aac1 ctermbg=Black cterm=NONE
  hi def nftHL_Command      guifg=#00009f guibg=NONE ctermfg=227 ctermbg=NONE cterm=bold gui=bold
  hi def nftHL_Statement    guifg=#000081 guibg=NONE ctermfg=227 ctermbg=NONE cterm=bold gui=bold
  hi def nftHL_Substatement guifg=#001fdf guibg=NONE ctermfg=214 ctermbg=NONE
  hi def nftHL_Keyword      guifg=#003679 guibg=NONE ctermfg=208 ctermbg=NONE
endif

"********* Leaf tokens (NOT-contained only)
hi link   nft_EOS nftHL_Error
syn match nft_EOS /\v[^ \t]{1,6}[\n\r\#]{1,3}/ skipempty skipnl skipwhite contained

"********* Leaf tokens (contained only)
hi link   nft_ToDo nftHL_ToDo
syn keyword nft_ToDo xxx contained XXX FIXME TODO TODO: FIXME: TBS TBD TBA
\ containedby=
\    nft_InlineComment

hi link   nft_Number nftHL_Number
syn match nft_Number /\<\d\+\>/ contained

hi link   nft_IP nftHL_Constant
syn match nft_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' contained

hi link   nft_String nftHL_String
syn match nft_String /"\([^"]\|\\."\)*"/ contained

hi link   nft_Comma nftHL_BlockDelimiters
syn match nft_Comma /,/ contained

hi link   nft_InlineComment nftHL_Comment
syn match nft_InlineComment '\v\#.*$' skipwhite contained

" **** BEGIN of ERROR CONDITIONS ****
hi link   nft_UnexpectedSymbol nftHL_Error
syn match nft_UnexpectedSymbol '\v\s{1,5}\zs[^a-zA-Z0-9]{1,64}' skipwhite contained

hi link   nft_UnexpectedNewLine nftHL_Error
syn match nft_UnexpectedNewLine '\v\s{1,30}${1,7}' display contained

hi link   nft_UnexpectedHash nftHL_Error
syn match nft_UnexpectedNewLine '\v\s{1,30}${1,7}' display contained

hi link   nft_UnexpectedAtSymbol nftHL_Error
syn match nft_UnexpectedAtSymbol '\v\@' skipwhite contained

hi link   nft_UnexpectedQuote nftHL_Error
syn match nft_UnexpectedQuote '\v["\']' skipwhite contained

hi link   nft_UnexpectedVariableName nftHL_Error
syn match nft_UnexpectedVariableName '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_UnexpectedIdentifier nftHL_Error
syn match nft_UnexpectedIdentifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_UnexpectedNonIdentifier nftHL_Error
syn match nft_UnexpectedNonIdentifier '\v[a-zA-Z\/\.][\/\.a-zA-Z0-9\-_]{0,63}' skipwhite contained
" **** END of ERROR CONDITIONS ****

" === For map entries like 1 : 'value' ===
hi link   nft_MapEntry nftHL_Identifier
syn match nft_MapEntry '\v[0-9]{1,10}\s{1,32}:\s{1,32}\".{1,64}\"' contained

" === Clustered list elements ===
syn cluster nft_c_SetElements
\ contains=
\    nft_Number,
\    nft_IP,
\    nft_String,
\    nft_Comma

syn cluster nft_c_MapElements
\ contains=
\    nft_MapEntry,
\    nft_Comma

syn cluster nft_c_GenericElements
\ contains=
\    nft_Number,
\    nft_String,
\    nft_Comma

" === For map entries like '1 : "value"' ===
syn match nft_MapEntry /\d\+\s*:\s*".*"/ contained

" === Clustered list elements ===
syntax cluster nft_c_SetElements
\ contains=
\    nft_Number,
\    nft_IP,
\    nft_String,
\    nft_Comma

syntax cluster nft_c_MapElements
\ contains=
\    nft_MapEntry,
\    nft_Comma

syntax cluster nft_c_GenericElements
\ contains=
\    nft_Number,
\    nft_String,
\    nft_Comma

" === Curly blocks for set/map/elements (each with own element cluster) ===
syn region nft_SetBlock start=/{/ end=/}/ skip="#.*$" contained
\ contains=
\    @nft_c_SetElements

syn region nft_MapBlock start=/{/ end=/}/ skip="#.*$" contained
\ contains=
\    @nft_c_MapElements

syn region nft_ElementsBlock start=/{/ end=/}/ skip="#.*$" contained
\ contains=
\    @nft_c_GenericElements

" === Entry point rules ===
syn match nft_RhsExprForSet     /\<set\>\s\+\k\+\s*=\s*{[^}]*}/ contained
\ contains=
\    nft_SetBlock

syn match nft_RhsExprForMap /\<map\>\s\+\k\+\s*=\s*{[^}]*}/ contained
\ contains=
\    nft_MapBlock

syn match nft_RhsExprForElements /\<elements\>\s*=\s*{[^}]*}/ contained
\ contains=
\    nft_ElementsBlock



" stmt_separator (via nft_chain_block, nft_chain_stmt, @nft_c_common_block,
"                     counter_block, ct_expect_block, ct_expect_config,
"                     ct_helper_block, ct_helper_config, ct_timeout_block,
"                     ct_timeout_config, flowtable_block, limit_block,
"                     nft_line, nft_map_block, nft_quota_block,
"                     nft_secmark_block, nft_set_block, nft_synproxy_block,
"                     nft_synproxy_config, table_block )
hi link   nft_stmt_separator nftHL_Separator
syn match nft_stmt_separator '\v(\n|;)' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" hi link   nft_hash_comment nftHL_Error
" syn match nft_hash_comment '\v#.{15,65}$' skipwhite contained

" syn match nft_Set contained /{.*}/ contains=nft_SetEntry contained
" syn match nft_SetEntry contained /[a-zA-Z0-9]\+/ contained
" hi def link nft_Set nftHL_Keyword
" hi def link nft_SetEntry nftHL_Operator

"syn match nft_Number '\<[0-9A-Fa-f./:]\+\>' contained contains=nft_Mask,nft_Delimiter
" syn match nft_Hex '\<0x[0-9A-Fa-f]\+\>' contained
" syn match nft_Delimiter '[./:]' contained
" syn match nft_Mask '/[0-9.]\+' contains=nft_Delimiter contained
" hi def link nft_Number nftHL_Number
" hi def link nft_Hex nftHL_Number
" hi def link nft_Delimiter nftHL_Operator
" hi def link nft_Mask nftHL_Operator

" Uncontained, unrestricted statement goes here
"
hi link   nft_MissingDeviceVariable nftHL_Error
syn match nft_MissingDeviceVariable '\v[^ \t\$\{]{1,5}' skipwhite contained " do not use 'keepend' here

hi link   nft_MissingCurlyBrace nftHL_Error
syn match nft_MissingCurlyBrace '\v[ \t]\ze[^\{]{1,1}' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedCurlyBrace nftHL_Error
syn match nft_UnexpectedCurlyBrace '\v\s{0,7}[\{\}]' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedEmptyCurlyBraces nftHL_Error
syn match nft_UnexpectedEmptyCurlyBraces '\v\{\s*\}' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedCurrencySign nftHL_Error
syn match nft_UnexpectedCurrencySign '\v\$\s{0,5}' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedCaret nftHL_Error
syn match nft_UnexpectedCaret '\v\^\s{0,5}' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedEmptyBrackets nftHL_Error
syn match nft_UnexpectedEmptyBrackets '\v\[\s*\]' skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedIdentifierChar nftHL_Error
syn match nft_UnexpectedIdentifierChar '\v(^[a-zA-Z0-9_\n]{1,3})' contained

hi link   nft_UnexpectedNumber nftHL_Error
syn match nft_UnexpectedNumber '\v[0-9\-\+]{1,4}' skipwhite contained

hi link   nft_UnexpectedNonNumber nftHL_Error
syn match nft_UnexpectedNonNumber '\v[^ \t0-9\-\+]{1,4}' skipwhite contained

" We'll do error RED highlighting on all statement firstly, then later on
" all the options, then all the clauses.
" Uncomment following two lines for RED highlight of typos (still Beta here)
hi link   nft_UnexpectedEOS nftHL_Error
syn match nft_UnexpectedEOS contained '\v[\t ]{0,2}[\#;\n]{1,2}.{0,1}' contained

hi link   nft_UnexpectedSemicolon nftHL_Error
syn match nft_UnexpectedSemicolon '\v;{1,7}' skipwhite contained

hi link   nft_MissingSemicolon nftHL_Error
syn match nft_MissingSemicolon '\v\s{1,5}\zs[^;]{1,5}' skipwhite contained " do not use 'keepend' here


hi link   nft_Error_Always nftHL_Error
syn match nft_Error_Always /[^(\n|\r)\.]\{1,15}/ skipwhite contained

hi link   nft_rule_cluster_Error nftHL_Error
syn match nft_rule_cluster_Error /\v[\s\wa-zA-Z0-9_]{1,64}/ skipwhite contained

hi link   nft_Error nftHL_Error
syn match nft_Error /\v[\s\wa-zA-Z0-9_]{1,64}/ skipwhite contained

hi link   nft_Error_IPAddr nftHL_Error
syn match nft_Error_IPAddr /\v[\s\wa-zA-Z0-9_\.:\/]{1,64}/ skipwhite contained

hi link   nft_Error_Quotes nftHL_Error
syn match nft_Error_Quotes /\v[\s\wa-zA-Z0-9_\.\'\"]{1,64}/ skipwhite contained

hi link   nft_expected_identifier nftHL_Error
syn match nft_expected_identifier /\v[^a-zA-Z]/ contained

hi link   nft_expected_equal_sign nftHL_Error
syn match nft_expected_equal_sign /\v[^=\s]/ contained

hi link   nft_expected_quote nftHL_Error
syn match nft_expected_quote /\v[^\"]/ skipwhite contained

hi link   nft_expected_dash nftHL_Error
syn match nft_expected_dash /\v[^\-]/ skipwhite contained

" Error if unexpected token appears after 'last'
hi link   nft_common_block_undefine_error nftHL_Error
syn match nft_common_block_undefine_error '\v[A-Za-z_][A-Za-z0-9_]{0,63}' contained

" Error if unexpected token appears after 'last'
hi link   nft_line_nonidentifier_error nftHL_Error
syn match nft_line_nonidentifier_error '\v[^ \#]{1,35}[^A-Za-z_]{1}' contained

hi link   nft_line_nonvariable_error nftHL_Error
syn match nft_line_nonvariable_error '\v\$[^A-Za-z][^A-Za-z0-9_\-]{0,1}' skipwhite contained


" expected end-of-line (iterator capped for speed)
syn match nft_EOL /[\n\r]\{1,16}/ skipwhite contained
syn match nft_ExpectedEOL /[\n\r]\{1,16}/ skipnl skipwhite contained

" syntax keyword nft_CounterKeyword last contained

" nft_Semicolon commented out to make way for syntax-specific semicolons
" hi link   nft_Semicolon nftHL_Operator
" syn match nft_Semicolon contained /\v\s{0,8}[;]{1,15}/  skipwhite contained

hi link   nft_identifier_exact nftHL_Identifier
syn match nft_identifier_exact '\v[a-zA-Z][a-zA-Z0-9_\.]{0,63}' contained

" We limit to 63-char maximum for identifier name (for Vim session speed)
hi link   nft_identifier nftHL_Identifier
syn match nft_identifier '\v\w{0,63}' skipwhite contained
\ contains=
\    nft_identifier_exact,
\    nft_Error

hi link   nft_variable_identifier nftHL_Variable
syn match nft_variable_identifier '\v\$[a-zA-Z][a-zA-Z0-9_]{0,63}' skipwhite contained


syn match nft_datatype_arp_op '\v((request|reply|rrequest|rreply|inrequest|inreplyh|nak)|((0x)?[0-9a-fA-F]{4})|([0-9]{1,2}))' skipwhite contained
syn match nft_datatype_ct_dir '\v((original|reply)|([0-1]{1,1}))' skipwhite contained
syn match nft_datatype_ct_event '\v((new|related|destroy|reply|assured|protoinfo|helper|mark|seqadj|secmark|label)|([0-9]{1,10}))' skipwhite contained
syn match nft_datatype_ct_label '\v[0-9]{1,40}' skipwhite contained
syn match nft_datatype_ct_state '\v((invalid|established|related|new|untracked)|([0-9]{1,10}))' skipwhite contained
syn match nft_datatype_ct_status '\v((expected|seen-reply|assured|confirmed|snat|dnat|dying)|([0-9]{1,10}))' skipwhite contained
syn match nft_datatype_ether_addr '\v((8021ad|8021q|arp|ip6|ip|vlan)|((0x)?[0-9a-fA-F]{4}))' skipwhite contained
syn match nft_datatype_ether_type '\v[0-9]{1,10}' skipwhite contained
syn match nft_datatype_gid '\v[0-9]{1,10}' skipwhite contained
syn match nft_datatype_mark '\v[0-9]{1,10}' skipwhite contained
syn match nft_datatype_ip_service_port '\v[0-9]{1,5}' skipwhite contained
syn match nft_datatype_ipv4_addr '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
syn match nft_datatype_ipv6_addr /\v((([0-9a-fA-F]{1,4}:){1,7}:)|(::([0-9a-fA-F]{1,4}:){0,6}[0-9a-fA-F]{1,4})|(([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}))/ skipwhite contained
syn match nft_datatype_packet_type '\v((host|unicast|broadcast|multicast|other)|([0-9]{1,5}))' skipwhite contained
syn match nft_datatype_realm '\v((default)|([0-9]{1,10}))' skipwhite contained
syn match nft_datatype_uid '\v(([a-z_][a-z0-9A-Z\._\-]{0,31})|([0-9]{1,10}))' skipwhite contained
syn match nft_meta_expr_datatype_devgroup '\v[0-9]{1,10}' skipwhite contained
syn match nft_meta_expr_datatype_iface_index '\v[0-9]{1,10}' skipwhite contained
syn match nft_meta_expr_datatype_ifkind '\v[a-zA-Z][a-zA-Z0-9]{1,16}' skipwhite contained
syn match nft_meta_expr_datatype_ifname '\v[a-zA-Z][a-zA-Z0-9]{1,16}' skipwhite contained
syn match nft_meta_expr_datatype_iface_type '\v((loopback|ipip6|ipgre|ipip|ether|ppp|sit)|([0-9]{1,5}))' skipwhite contained
syn match nft_meta_expr_datatype_day '\v([0-8]|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday)' skipwhite contained
syn match nft_meta_expr_datatype_hour '\v[0-2][0-9]:[0-5][0-9](:[0-5][0-9])?' skipwhite contained
syn match nft_meta_expr_datatype_time '\v(([0-9]{1,20})|iso_format)' skipwhite contained
syn match nft_payload_expr_datatype_ifname '\v[a-zA-Z][a-zA-Z0-9]{1,16}' skipwhite contained
syn match nft_payload_expr_datatype_tcp_flag '\v((fin|syn|rst|psh|ack|urg|ecn|cwr)|([0-9]{1,3}))' skipwhite contained
hi link   nft_payload_expr_ip6_nexthdr nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr '\v(hop\-by\-hop|fragment|no\-next|routing|icmpv6|dccp|dest|icmpv6|sctp|esp|tcp|udp|ah)' skipwhite contained

hi link   nft_line_separator nftHL_Define
syn match nft_line_separator  '\v[;\n]{1,16}' skipwhite contained

hi link   nft_line_stmt_separator nftHL_Separator
syn match nft_line_stmt_separator  '\v[;\n]{1,16}' skipwhite contained
" variable_expr (via chain_expr, dev_spec, extended_prio_spec, flowtable_expr,
"                    flowtable_member_expr, policy_expr, queue_expr,
"                    queue_stmt_expr_simple, set_block_expr, set_ref_expr
"                    symbol_expr

" Trickest REGEX of all, how to get wild-cardy 'table identifier' at the beginning of a
" line but without hitting a reserve TOP command (i.e., `add`, `list`, `table`), place this
" `syntax match nft_base_cmd_rule_position_table_spec_wildcard` near the beginning of this file.
" (otherwise, you would have to figure a multi-char Regex of all top-level reserve commands
" coupled with `^` begin of line.)




hi link   nft_string_unquoted nftHL_String
syn match nft_string_unquoted '\v[a-zA-Z0-9\*\/\\\[\]\$]{1,64}' skipwhite keepend contained

hi link   nft_string_sans_double_quote nftHL_String
syn match nft_string_sans_double_quote "\v[a-zA-Z0-9\/\\\[\]\"]{1,64}" keepend oneline contained

hi link   nft_string_sans_single_quote nftHL_String
syn match nft_string_sans_single_quote '\v[a-zA-Z0-9\/\\\[\]\']{1,64}' keepend oneline contained

hi link    nft_string_single nftHL_String
syn region nft_string_single start='\'' skip='\\\'' end='\'' keepend oneline contained
\ contains=
\    nft_string_sans_single_quote

hi link    nft_string_double nftHL_String
syn region nft_string_double start='\"' skip='\\\"' end='\"' keepend oneline contained
\ contains=
\    nft_string_sans_double_quote

syn cluster nft_c_quoted_string
\ contains=
\    nft_string_single,
\    nft_string_double

hi link    nft_asterisk_string nftHL_String
syn region nft_asterisk_string start='\"' end='\"' keepend oneline contained
\ contains=
\    nft_string_with_asterisk_unquoted,
\    nft_string_unquoted

syn cluster nft_c_string
\ contains=
\    nft_asterisk_string,
\    @nft_c_quoted_string,
\    nft_string_unquoted

" nft_identifier_last (via identifer)
hi link  nft_identifier_last nftHL_Keyword
syn match nft_identifier_last 'last' skipwhite contained

" identifier
syn cluster nft_identifier
\ contains=
\    nft_identifier_last,
\    @nft_c_string


hi link   nft_common_block_stmt_separator nftHL_Separator
syn match nft_common_block_stmt_separator /;/ skipwhite contained

" Region that spans from after 'last' to terminator ';' or newline
hi link    nft_common_block_undefine_extra_text nftHL_Error
syn region nft_common_block_undefine_extra_text start=/\%#\s*/ end=/\ze[;\n]/ skip="#.{0,45}$" contained transparent
\ contains=
\    nft_expected_semicolon_or_new_line,
\    nft_common_block_undefine_error




" **************** BEGIN expr ***************************************




" add_cmd 'table' table_block 'chain' chain_block rule 'rule' rule_alloc
" short-circuiting to chain_block comment_spec
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_rule_rule_alloc
\ contains=
\    @nft_c_stmt

" add_cmd 'table' table_block 'chain' chain_block rule 'rule'
" TODO unused nft_add_cmd_keyword_table_table_block_chain_chain_block_rule
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_rule nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_rule "rule" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_rule_rule_alloc,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_rule_comment_spec

hi link   nft_chainError nftHL_Error
syn match nft_chainError /"v[a-zA-Z0-9\\\/_\.;:]{1,64}/ skipwhite contained


hi link   nft_stmt_concat_stmt_expr_symbol_dot nftHL_Operator
syn match nft_stmt_concat_stmt_expr_symbol_dot '\v\.' skipwhite contained

" primary_stmt_expr referenced by shift_stmt_expr
syn cluster nft_c_shift_stmt_expr
\ contains=
\    nft_numgen_expr_keyword_numgen,
\    @nft_c_integer_expr,
\    @nft_c_boolean_expr,
\    @nft_c_payload_expr,
\    @nft_c_keyword_expr,
\    @nft_c_numgen_expr,
\    @nft_c_socket_expr,
\    @nft_c_symbol_expr,
\    @nft_c_hash_expr,
\    @nft_c_meta_expr,
\    @nft_c_osf_expr,
\    @nft_c_ct_expr,
\    @nft_c_rt_expr,
\    nft_primary_stmt_expr_block_delimiters,
\    nft_integer_expr_keyword_integer,
\    nft_symbol_expr_keyword_symbol,
\    nft_boolean_expr_keyword_boolean,
\    nft_hash_expr_keyword_hash,
\    nft_meta_expr_keyword_meta,
\    nft_primary_stmt_expr_boolean_expr_keyword_missing,
\    nft_primary_stmt_expr_boolean_expr_keyword_exists,
\    nft_payload_expr_payload_raw_expr,
\    nft_payload_expr_eth_hdr_expr_keyword_ether,
\    nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_payload_expr_ipv6_hdr_expr_keyword_ipv6,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_payload_expr_vlan_hdr_expr_keyword_vlan,
\    nft_payload_expr_arp_hdr_expr_keyword_arp,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_ct_expr_keyword_ct,
\    nft_payload_expr_ip_hdr_expr_keyword_ip,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_rt_expr_keyword_rt,

" shift_stmt_expr referenced by and_stmt_expr
syn cluster nft_c_shift_stmt_expr
\ contains=
\    @nft_c_primary_stmt_expr

" and_stmt_expr referenced by exclusive_or_stmt_expr
syn cluster nft_c_and_stmt_expr
\ contains=
\    @nft_c_shift_stmt_expr

" exclusive_or_stmt_expr referenced by basic_stmt_expr
syn cluster nft_c_exclusive_or_stmt_expr
\ contains=
\    @nft_c_and_stmt_expr

" basic_stmt_expr referenced by concat_stmt_expr
syn cluster nft_c_basic_stmt_expr
\ contains=
\    @nft_c_exclusive_or_stmt_expr

" concat_stmt_expr referenced by map_stmt_expr
syn cluster nft_c_concat_stmt_expr
\ contains=
\    @nft_c_basic_stmt_expr

" map_stmt_expr is that #1 nexus of all 'stmt'; nothing to do with map/vmap keyword
" map_stmt_expr referenced by stmt_expr
syn cluster nft_c_map_stmt_expr
\ contains=
\    nft_c_concat_stmt_expr


hi link   nft_add_rule_declarative_rule_position_chain_spec_table_spec_unknown_family_identifier_table nftHL_Table
syn match nft_add_rule_declarative_rule_position_chain_spec_table_spec_unknown_family_identifier_table '\v[a-zA-Z][a-zA-Z0-9_-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_rule_declarative_rule_position_chain_spec_unknown_family_identifier_chain,
\    nft_Error



" `line` main top-level syntax, do not add 'contained' here.
" `line` is the only syntax with '^' caret (begin of line) regex pattern
" limit to 63-char whitespaces from 1st column (for Vim syntax session speed)
hi link   nft_line Normal
syn match nft_line '^\v\s{0,63}'
\ nextgroup=
\    nft_base_cmd_keyword_describe,
\    nft_common_block_keyword_redefine,
\    nft_base_cmd_add_cmd_keyword_synproxy,
\    nft_common_block_keyword_undefine,
\    nft_base_cmd_add_cmd_keyword_counter,
\    nft_base_cmd_keyword_destroy,
\    nft_base_cmd_add_cmd_keyword_element,
\    nft_common_block_keyword_include,
\    nft_base_cmd_keyword_monitor,
\    nft_base_cmd_keyword_replace,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_base_cmd_keyword_create,
\    nft_common_block_keyword_define,
\    nft_base_cmd_keyword_delete,
\    nft_base_cmd_keyword_insert,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_keyword_rename,
\    nft_base_cmd_add_cmd_keyword_chain_declarative,
\    nft_common_block_keyword_error,
\    nft_base_cmd_keyword_flush,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_keyword_reset,
\    nft_base_cmd_keyword_table_declarative,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_base_cmd_keyword_list,
\    nft_base_cmd_no_add_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_base_cmd_keyword_get,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_add_rule_declarative_rule_position_chain_spec_table_spec_unknown_family_identifier_table,
\    nft_line_separator,
\    nft_comment_inline,
"\    nft_line_nonidentifier_error

" no secmark at top-level: nft_base_cmd_add_cmd_keyword_secmark
" practically no way to highlight an incorrect first alphanum token due
" to unquoted_table_identifier as the first token
" 'nft_Error_Always' is that catch-all for 1st token
"
" we removed nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative
"    as being untenable syntax contexting (at scanner.l level).

" Match the comment region (containing the entire line)
hi link   nft_comment_inline nftHL_Comment
syntax region nft_comment_inline start='\#' end='$' skip="#[^#.]*$"
\ contains=NONE

"*************** END OF TOP-LEVEL SYNTAXES *****************************

  " Load companion syntax files to extend the LL(1) syntax tree.
  call nftables#syntax#log('OK', 'files_later: ' . string(s:list_filepaths_semantic_later))
  for s:this_semantic_file in s:list_filepaths_semantic_later
    try
      call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
      " execute 'source ' . g:nft_nftables_syntax_dirpath_custom_nftables . s:this_semantic_file
      call nftables#syntax#load(s:this_semantic_file)
      call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file )
    catch
      call nftables#syntax#log('ERROR', 'Error loading: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
    endtry
  endfor
"********************* END OF SYNTAX ****************************


  " Log successful loading of main syntax definitions.
  call nftables#syntax#debug('Main syntax definitions loaded for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define main syntax: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry

" Configure syntax synchronization for efficient parsing.
" 'fromstart' and 'maxlines=1000' optimize LL(1) parsing for large files.
syntax sync fromstart
syn sync clear
syn sync maxlines=1000
syn sync match nftablesSync grouphere NONE '^\s*(counter|rule {1,15}rule|table|chain|set)'

let s:nftables_end_colors_name = execute('colorscheme')[1:]
let s:nftables_end_background = &background
echom printf("INFO: vimrc (end) colorscheme: %s", s:nftables_end_colors_name)
echom printf("INFO: vimrc (end) background: %s", s:nftables_end_background)

" Restore script stack after loading.
let g:nft_current_script_file_name = empty(g:nft_stack_filepath_scripts) ? '' : remove(g:nft_stack_filepath_scripts, -1)

" --- cpo guard end ---
" Restore original 'compatible' option to avoid side effects.
let &cpo = s:cpo_save
unlet s:cpo_save
" ---------------------

" Set buffer syntax to 'nftables' to activate the syntax file.
let b:current_syntax = 'nftables'
call nftables#syntax#debug('End')
