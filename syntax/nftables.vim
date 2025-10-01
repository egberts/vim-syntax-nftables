" ~/.vim/syntax/nftables.vim
" Vim syntax file for nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     1.1.0015
" Initial Date: 2020-04-24
" Last Change:  2025-09-28
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
let g:nft_debug = 3

" Store the current script’s filename for stack-based logging.
" Used in LL(1) parsing to track script context for error reporting.
call nftables#syntax#push(expand('<sfile>'))

" Debug log to mark the start of script execution.
if exists('g:nft_debug') && g:nft_debug ==1
  echom '[syntax/nftables][OK] Begin'
endif

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
\     'table.vim',
\     'element_cmd.vim',
\     'monitor_cmd.vim',
\     'replace_cmd.vim',
\     'destroy_delete_cmds.vim',
\     'create_cmd.vim',
\     'insert_cmd.vim',
\     'rename_cmd.vim',
\     'flush_cmd.vim',
\     'quota_cmd.vim',
\     'reset_cmd.vim',
\     'add_cmd.vim',
\     'get_cmd.vim',
\     'ct_cmd.vim',
\     'common_block.vim'
\    ]

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
if exists('&background')
  if empty(&background)
    let nft_obtained_background = 'no'
  else
    let nft_obtained_background = trim(execute('set background?'))
  endif
endif
call nftables#syntax#log('OK', 'Background obtained?: ' . nft_obtained_background)

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

" Configure syntax synchronization for efficient parsing.
" 'fromstart' and 'maxlines=1000' optimize LL(1) parsing for large files.
syntax sync fromstart
syn case match
syn sync clear
syn sync maxlines=1000
syn sync match nftablesSync grouphere NONE '^\s*(counter|rule {1,15}rule|table|chain|set)'

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

  hi def nftHL_Command      guifg=#ffff60 guibg=NONE ctermfg=227 ctermbg=NONE cterm=bold gui=bold
  hi def nftHL_Statement    guifg=#ffe682 guibg=NONE ctermfg=214 ctermbg=NONE
  hi def nftHL_Keyword      guifg=#ffc986 guibg=NONE ctermfg=208 ctermbg=NONE
  hi def link nftHL_Expression  Conditional
  hi def link nftHL_Type        Type

  hi def link nftHL_Family      Underlined
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
  hi def link nftHL_Delimiters  Normal
  hi def link nftHL_BlockDelimiters Normal
  hi def link nftHL_Write       NonText
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

  "hi link nftHL_BlockDelimitersTable  Delimiter
"hi link nftHL_BlockDelimitersChain  Delimiter
"hi link nftHL_BlockDelimitersSet    Delimiter
"hi link nftHL_BlockDelimitersMap    Delimiter
"hi link nftHL_BlockDelimitersFlowTable    Delimiter
"hi link nftHL_BlockDelimitersCounter Delimiter
"hi link nftHL_BlockDelimitersQuota  Delimiter
"hi link nftHL_BlockDelimitersCT     Delimiter
"hi link nftHL_BlockDelimitersLimit  Delimiter
"hi link nftHL_BlockDelimitersSecMark Delimiter
"hi link nftHL_BlockDelimitersSynProxy Delimiter
"hi link nftHL_BlockDelimitersMeter  Delimiter
"hi link nftHL_BlockDelimitersDevices Delimiter

if exists('g:nft_colorscheme')
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
syn match nft_InlineComment '\v\# ' skipwhite contained

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
hi link   nft_stmt_separator nftHL_Normal
syn match nft_stmt_separator '\v(\n|;)' skipwhite contained

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
syn match nft_rule_cluster_Error /\v[\s\wa-zA-Z0-9_]{1,64}/ skipwhite contained  " uncontained, on purpose

hi link   nft_Error nftHL_Error
syn match nft_Error /\v[\s\wa-zA-Z0-9_]{1,64}/ skipwhite contained  " uncontained, on purpose

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
syn match nft_datatype_ip_protocol '\v((tcp|udp|udplite|esp|ah|icmpv6|icmp|comp|dccp|sctp)|([0-9]{1,3}))' skipwhite contained
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

"
" identifier->table_spec->chain_spec->rule_position->add_cmd->'add'->base_cmd
hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative_invalid_keywords nftHL_Error
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative_invalid_keywords '\v(expectation|masquerade|flowtable|rtclassid|continue|ibriport|oifgroup|redirect|cfgroup|ibrname|iifname|iiftype|nftrace|notrack|obrname|oifname|oiftype|pkttype|timeout|udplite|accept|cgroup|geneve|handle|helper|import|reject|return|tproxy|update|export|icmpv6|ether|skgid|skuid|vxlan|auth|comp|dccp|dnat|drop|flow|frag|goto|icmp|igmp|jump|last|meta|mark|snat|cpu|day|dst|dup|esp|fwd|gre|hbh|iif|log|oif|src|tcp|udp|at|mh|rt|th|xt)' skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative nftHL_Identifier
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative '\v[A-Za-z][A-Za-z0-9_]{0,63}' skipwhite contained
\ contains=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative_invalid_keywords
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_identifier,
\    nft_line_nonidentifier_error


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
" nft_c_string must be the LAST contains= (via nft_unquoted_string)
hi link   nft_device_index_set_element_separator nftHL_Separator
syn match nft_device_index_set_element_separator /,/ skipwhite contained
\ nextgroup=
\    nft_device_index_set_quoted_identifier,
\    nft_device_index_set_number,
\    nft_Error
hi link   nft_device_index_set_quoted_identifier nftHL_String
syn match nft_device_index_set_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"' skipwhite contained
\ nextgroup= nft_device_index_set_element_separator, nft_Error
syn match nft_device_index_set_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'' skipwhite contained
\ nextgroup= nft_device_index_set_element_separator, nft_Error

hi link   nft_device_index_set_number Define
syn match nft_device_index_set_number '\v[0-9]{1,5}' skipwhite contained
\ nextgroup= nft_device_index_set_element_separator, nft_Error

hi link    nft_device_index_set_block nftHL_BlockDelimitersSet
syn region nft_device_index_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\     nft_device_index_set_quoted_identifier,
\     nft_device_index_set_number,
\     nft_Error
hi link   nft_device_index_named_set_identifier nftHL_Set
syn match nft_device_index_named_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained
syn match nft_device_index_number '\v[0-9]{1,3}\ze[ \t;]' skipwhite contained

hi link   nft_device_index_number Define
syn match nft_device_index_number '\v[0-9]{1,3}\ze[ \t;]' skipwhite contained
hi link   nft_device_index_quoted_identifier nftHL_String
syn match nft_device_index_quoted_identifier '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"[\ze[ \t;]' skipwhite contained
syn match nft_device_index_quoted_identifier '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\'[\ze[ \t;]' skipwhite contained
hi link   nft_device_index_identifier nftHL_Identifier
syn match nft_device_index_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained

" equality operators support scalar, inline set
hi link   nft_device_index_operators_equality nftHL_Operator
syn match nft_device_index_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_device_index_named_set_identifier,
\    nft_device_index_quoted_identifier,
\    nft_device_index_set_block,
\    nft_device_index_identifier,
\    nft_device_index_number,
\    nft_Error
hi link   nft_device_index_set_operator_in nftHL_Operator
syn match nft_device_index_set_operator_in '\vin\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_device_index_named_set_identifier,
\    nft_device_index_set_block,
\    nft_Error
hi link   nft_device_index_operator_keyword_not nftHL_Operator
syn match nft_device_index_operator_keyword_not '\vnot\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_device_index_set_operator_in,
\    nft_device_index_set_block,
\    nft_Error
hi link   nft_device_index_keyword_any nftHL_Operator
syn match nft_device_index_keyword_any '\vany\ze[ \t;]' skipwhite contained

syn cluster nft_c_device_index
\ contains=
\    nft_device_index_keyword_any,
\    nft_device_index_operator_keyword_not,
\    nft_device_index_operators_equality,
\    nft_device_index_set_operator_in,
\    nft_device_index_quoted_identifier,
\    nft_device_index_identifier,
\    nft_device_index_number,

hi link   nft_interface_type_set_identifier nftHL_Set
syn match nft_interface_type_set_identifier '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}[\ze[ \t;]' skipwhite contained

hi link   nft_interface_type_number Define
syn match nft_interface_type_number '\v[0-9]{1,3}\ze[ \t;]' skipwhite contained

hi link   nft_interface_type_operators nftHL_Operator
syn match nft_interface_type_operators '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_interface_type_set_identifier,
\    nft_interface_type_set_block,
\    nft_interface_type_number,
\    nft_Error
hi link   nft_interface_type_operators_discrete nftHL_Operator
syn match nft_interface_type_operators_discrete '\v(\<|\>)\=' skipwhite contained
\ nextgroup=
\    nft_interface_type_number,
\    nft_Error

syn cluster nft_c_interface_type
\ contains=
\    nft_meta_expr_datatype_iface_type,
\    nft_interface_type_operators_discrete,
\    nft_interface_type_operators,
\    nft_interface_type_set_identifier,
\    nft_interface_type_number,

hi link   nft_interface_name_regex_string_quoted nftHL_String
syn match nft_interface_name_regex_string_quoted '\v\"\S{1,64}\"' skipwhite contained
syn match nft_interface_name_regex_string_quoted '\v\'\S{1,64}\'' skipwhite contained
hi link   nft_interface_name_operator_regex_match nftHL_Operator
syn match nft_interface_name_operator_regex_match '\v\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error
hi link   nft_interface_name_operator_regex_not_match nftHL_Operator
syn match nft_interface_name_operator_regex_not_match '\v\!\~' skipwhite contained
\ nextgroup= nft_interface_name_regex_string_quoted, nft_Error
hi link   nft_interface_name_operator_special_any nftHL_Operator
syn match nft_interface_name_operator_special_any '\vany' skipwhite contained
hi link   nft_interface_name_set_element_separator nftHL_Separator
syn match nft_interface_name_set_element_separator /,/ skipwhite contained
\ nextgroup= nft_interface_name_set_block_element_string_quoted, nft_Error
hi link   nft_interface_name_set_block_element_string_quoted nftHL_String
syn match nft_interface_name_set_block_element_string_quoted '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,63}\"' skipwhite contained
\ nextgroup= nft_interface_name_set_element_separator, nft_Error
syn match nft_interface_name_set_block_element_string_quoted '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,63}\'' skipwhite contained
\ nextgroup= nft_interface_name_set_element_separator, nft_Error
hi link    nft_interface_name_set_block  nftHL_BlockDelimitersSet
syn region nft_interface_name_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_interface_name_set_block_element_string_quoted,
\    nft_Error
" 'any' keyword is not supported inside a set

hi link   nft_interface_name_namedset  nftHL_Identifier
syn match nft_interface_name_namedset '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_interface_name_quote_string_asterisk  nftHL_String
syn match nft_interface_name_quote_string_asterisk '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\"\ze[ \t;]' skipwhite contained
syn match nft_interface_name_quote_string_asterisk '\v\'[a-zA-Z][a-zA-Z0-9\-_\*]{0,15}\'\ze[ \t;]' skipwhite contained

hi link   nft_interface_name_quote_mandatory  nftHL_String
syn match nft_interface_name_quote_mandatory '\v\"[a-zA-Z][a-zA-Z0-9\-_]{0,15}\"\ze[ \t;]' skipwhite contained
syn match nft_interface_name_quote_mandatory '\v\'[a-zA-Z][a-zA-Z0-9\-_]{0,15}\'\ze[ \t;]' skipwhite contained

hi link   nft_interface_name_device_name  nftHL_Device
syn match nft_interface_name_device_name '\v[a-zA-Z][a-zA-Z0-9\-_]{0,15}\ze[ \t;]' skipwhite contained

hi link   nft_interface_name_operators_equality nftHL_Operator
syn match nft_interface_name_operators_equality '\v(\!|\=)\=' skipwhite contained
\ nextgroup=
\    nft_interface_name_quote_mandatory,
\    nft_interface_name_namedset,
\    nft_interface_name_set_block,
\    nft_Error

syn cluster nft_c_interface_name
\ contains=
\    nft_interface_name_operator_special_any,
\    nft_interface_name_operators_equality,
\    nft_interface_name_operator_regex_not_match,
\    nft_interface_name_operator_regex_match,
\    nft_interface_name_quote_string_asterisk,
\    nft_interface_name_device_name

syn cluster nft_c_interface_name_or_wildcard
\ contains=
\    nft_interface_name_operator_special_any,
\    nft_interface_name_operators_equality,
\    nft_interface_name_operator_regex_not_match,
\    nft_interface_name_operator_regex_match,
\    nft_interface_name_set_block,
\    nft_interface_name_quote_string_asterisk,
\    nft_interface_name_device_name

hi link   nft_common_block_stmt_separator nftHL_Separator
syn match nft_common_block_stmt_separator /;/ skipwhite contained

" Region that spans from after 'last' to terminator ';' or newline
hi link    nft_common_block_undefine_extra_text nftHL_Error
syn region nft_common_block_undefine_extra_text start=/\%#\s*/ end=/\ze[;\n]/ skip="#.{0,45}$" contained transparent
\ contains=
\    nft_expected_semicolon_or_new_line,
\    nft_common_block_undefine_error



hi link   nft_comment_spec_string_content nftHL_Comment
syn match nft_comment_spec_string_content '\v\S{1,64}' skipwhite contained


hi link    nft_comment_spec_string_quoted_double nftHL_Comment
syn region nft_comment_spec_string_quoted_double start='\"' end='\"' skip='\\\"' keepend oneline skipwhite contained
\ contains=
\   nft_comment_spec_string_content,
\   nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
" used only at top-level, never inside 'blocks'
hi link   nft_comment_spec_keyword_comment nftHL_Statement
syn match nft_comment_spec_keyword_comment '\vcomment' skipwhite contained
\ nextgroup=
\   nft_comment_spec_string_quoted_double,
\   nft_Error

" **************** BEGIN expr ***************************************
" **************** BEGIN socket_expr ********************************
" socket_expr -> primary_expr
" socket_expr -> primary_stmt_expr
hi link   nft_socket_expr_keyword_socket nftHL_Command
syn match nft_socket_expr_keyword_socket '\vsocket\ze[ \t]' skipwhite contained
" ***************** END socket_expr **********************************

" ***************** BEGIN numgen_expr ********************************
" numgen_expr -> primary_expr
" numgen_expr -> primary_stmt_expr
hi link   nft_chain_block_primary_expr_numgen_expr_keyword_numgen nftHL_Command
syn match nft_numgen_expr_keyword_numgen '\vnumgen\ze[ \t]' skipwhite contained
" **************** END numgen_expr ***********************************

" **************** BEGIN meta_expr ***********************************
" meta_expr - trying for a generic Vim syntax group (to reside ONLY within chain_block)
"   used by primary_expr and primary_stmt_expr
syn cluster nft_c_meta_key_qualified
\ contains=
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random

syn cluster nft_c_meta_key_unqualified
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif

" meta_key, used by meta_expr & meta_stmt
syn cluster nft_c_meta_key
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_qualified_keyword_protocol,
\    nft_meta_key_qualified_keyword_priority,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_qualified_keyword_secmark,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_qualified_keyword_length,
\    nft_meta_key_qualified_keyword_random,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif,

hi link   nft_meta_key_unqualified_keywords nftHL_Command
syn match nft_meta_key_unqualified_keywords '\v(rtclassid|iifgroup|oifgroup|ibrname|ibrport|iifname|iiftype|nftrace|obrname|obrport|oifname|oiftype|pkttype|cgroup|ipsec|skgid|skuid|hour|mark|time|cpu|day|iif|oif)' skipwhite contained

hi link   nft_meta_expr_keyword_meta_string nftHL_String
syn match nft_meta_expr_keyword_meta_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_meta_expr_keyword_meta nftHL_Command
syn match nft_meta_expr_keyword_meta '\vmeta\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_meta_key,
\    nft_meta_expr_keyword_meta_string

syn cluster nft_c_meta_expr_template
\ contains=
\    nft_meta_key_unqualified_keyword_rtclassid,
\    nft_meta_key_unqualified_keyword_iifgroup,
\    nft_meta_key_unqualified_keyword_oifgroup,
\    nft_meta_key_unqualified_keyword_ibrname,
\    nft_meta_key_unqualified_keyword_ibrport,
\    nft_meta_key_unqualified_keyword_iifname,
\    nft_meta_key_unqualified_keyword_iiftype,
\    nft_meta_key_unqualified_keyword_nftrace,
\    nft_meta_key_unqualified_keyword_obrname,
\    nft_meta_key_unqualified_keyword_obrport,
\    nft_meta_key_unqualified_keyword_oifname,
\    nft_meta_key_unqualified_keyword_oiftype,
\    nft_meta_key_unqualified_keyword_pkttype,
\    nft_meta_key_unqualified_keyword_cgroup,
\    nft_meta_key_unqualified_keyword_ipsec,
\    nft_meta_key_unqualified_keyword_skgid,
\    nft_meta_key_unqualified_keyword_skuid,
\    nft_meta_key_unqualified_keyword_hour,
\    nft_meta_key_unqualified_keyword_mark,
\    nft_meta_expr_keyword_meta,
\    nft_meta_key_unqualified_keyword_time,
\    nft_meta_key_unqualified_keyword_cpu,
\    nft_meta_key_unqualified_keyword_day,
\    nft_meta_key_unqualified_keyword_iif,
\    nft_meta_key_unqualified_keyword_oif

syn cluster nft_c_meta_expr
\ contains=
\    nft_meta_key_unqualified_keywords,
\    nft_meta_expr_keyword_meta
" **************** END meta_expr *************************************


" **************** BEGIN payload_raw_expr ***************************
" Inside chain_block
" '@ih,0,8 48'
hi link   nft_payload_raw_expr_payload_raw_len nftHL_Integer
syn match nft_payload_raw_expr_payload_raw_len '\v(0x[0-9a-fA-F]{1,8})|([0-9]{1,10})' skipwhite contained

" '@ih,0,8'
hi link   nft_payload_raw_expr_num2 nftHL_Integer
syn match nft_payload_raw_expr_num2 '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})' skipwhite contained
\ nextgroup=
\    nft_payload_raw_expr_payload_raw_len

" '@ih,0,'
hi link   nft_payload_raw_expr_comma2_symbol nftHL_Element
syn match nft_payload_raw_expr_comma2_symbol '\v,' contained
\ nextgroup=
\    nft_payload_raw_expr_num2

" '@ih,0'
hi link   nft_payload_raw_expr_num1 nftHL_Integer
syn match nft_payload_raw_expr_num1 '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})' contained
\ nextgroup=
\    nft_payload_raw_expr_comma2_symbol

" '@ih,'
hi link   nft_payload_raw_expr_comma1_symbol nftHL_Element
syn match nft_payload_raw_expr_comma1_symbol '\v,' contained
\ nextgroup=
\    nft_payload_raw_expr_num1

" Predefined payload base: @ih, @ll, @nh, @th
" payload_raw_expr/payload_expr/primary_expr/basic_expr/concat_expr/relational_expr/match_stmt/stmt/rule_alloc/rule/chain_block ...
" '@ih,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_ih nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_ih '\v\@ih' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@ll,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_ll nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_ll '\v\@ll' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@nh,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_nh nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_nh '\v\@nh' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@th,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_th nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_th '\v\@th' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error

" '@<string>,9,9 99'
hi link   nft_payload_raw_expr_payload_base_spec_keyword_at_string nftHL_Statement
syn match nft_payload_raw_expr_payload_base_spec_keyword_at_string '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,15}\ze,' contained
\ nextgroup=
\    nft_payload_raw_expr_comma1_symbol, nft_Error
" ************************* END payload_raw_expr' *************************

" ************************* BEGIN payload_expr' *************************
" ************************* BEGIN ip_hdr_expr' *************************
hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type '\v(lsrr|ssrr|ra|rr)' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option '\voption' skipwhite contained
\ nextgroup=
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_option_type,
\    nft_chainError

hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b '\v((0x[0-9a-fA-F]{1})|([0-9]{1,2}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_int_hex_32b '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_setname nftHL_Element
syn match nft_close_scope_ip_primary_expr_constant_expr_setname '\v\@[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
hi link   nft_close_scope_ip_primary_expr_constant_expr_ip nftHL_Integer
syn match nft_close_scope_ip_primary_expr_constant_expr_ip '\v[0-9]{1,3}(\.([0-9]{1,3})){3}' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength '\vhdrlength' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_4b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum '\vchecksum' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol '\vprotocol' skipwhite contained
\ nextgroup=
\    nft_datatype_ip_protocol,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off '\vfrag\-off' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version '\vversion' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_8b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length '\vlength' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_map_expr_keyword_map,
\    nft_close_scope_ip_primary_expr_constant_expr_int_hex_16b

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr '\vdaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_ip

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr '\vsaddr' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_close_scope_ip_primary_expr_constant_expr_ip

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp '\vdscp' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn '\vecn' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl '\vttl' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id '\vid' skipwhite contained

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field nftHL_Keyword
syn match nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field '\v(hdrlength|checksum|protocol|frag\-off|version|length|daddr|saddr|dscp|ecn|ttl|id)' skipwhite contained

" ip nexthdr: tcp, udp, icmp, igmp, esp, ah, sctp, dccp, gre, ipip, ipv6.
" ip protocol: tcp, udp, icmp, igmp, esp, ah, sctp, dccp, gre, ipip, ipv6.
" icmp protocol: echo-reply, destination-unreachable, source-quench, redirect, echo-request, router-advertisement, router-solicitation, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply.
" Takeaway: corresponding 'ip[6] nexthdr' and 'ip[6] protocol' are identical
" Enforce 'ip protocol' and 'ip6 nexthdr'
hi link   nft_primary_stmt_expr_payload_expr_keyword_ip nftHL_Statement
syn match nft_primary_stmt_expr_payload_expr_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_hdrlength,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_checksum,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_protocol,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_frag_off,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_version,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_length,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_keyword_option,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_daddr,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_saddr,
\    nft_payload_expr_ip_protocol_keyword_dccp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_dscp,
\    nft_payload_expr_ip_protocol_keyword_icmp,
\    nft_payload_expr_ip_protocol_keyword_igmp,
\    nft_payload_expr_ip_protocol_keyword_ipip,
\    nft_payload_expr_ip_protocol_keyword_ipv6,
\    nft_payload_expr_ip_protocol_keyword_sctp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ecn,
\    nft_payload_expr_ip_protocol_keyword_esp,
\    nft_payload_expr_ip_protocol_keyword_gre,
\    nft_payload_expr_ip_protocol_keyword_tcp,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_ttl,
\    nft_payload_expr_ip_protocol_keyword_udp,
\    nft_payload_expr_ip_protocol_keyword_ah,
\    nft_primary_stmt_expr_payload_expr_keyword_ip_ip_hdr_expr_ip_hdr_field_id,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip_hdr_expr_named_set,
\    nft_chainError
" ************************* END ip_hdr_expr' *************************

" ************************* BEGIN ip6_hdr_expr' *************************
" ************************* BEGIN ip6 flowlabel' *************************
hi link   nft_payload_expr_ip6_flowlabel_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_flowlabel_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' skipwhite contained

hi link   nft_payload_expr_ip6_flowlabel_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_flowlabel_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_flowlabel_hex_value
hi link   nft_payload_expr_ip6_flowlabel_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_flowlabel_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_in_set_block

hi link   nft_payload_expr_ip6_flowlabel_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_flowlabel_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_flowlabel_operator_2char '\v([\>\<])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_flowlabel_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_flowlabel_named_set nftHL_Set
syn match nft_payload_expr_ip6_flowlabel_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel '\vflowlabel' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_flowlabel_keyword_not,
\    nft_payload_expr_ip6_flowlabel_named_set,
\    nft_payload_expr_ip6_flowlabel_keyword_in,
\    nft_payload_expr_ip6_flowlabel_operator_2char,
\    nft_payload_expr_ip6_flowlabel_hex_value,
\    nft_payload_expr_ip6_flowlabel_operator_1char,
\    nft_chainError
" ************************* END ip6 flowlabel' *************************

" ************************* BEGIN ip6 hoplimit' *************************
hi link   nft_payload_expr_ip6_hoplimit_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_hoplimit_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' skipwhite contained

hi link   nft_payload_expr_ip6_hoplimit_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_hoplimit_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_hoplimit_hex_value

hi link   nft_payload_expr_ip6_hoplimit_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_hoplimit_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_in_set_block

hi link   nft_payload_expr_ip6_hoplimit_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_hoplimit_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_hoplimit_operator_2char '\v([\>\<])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_hoplimit_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_chainError

hi link   nft_payload_expr_ip6_hoplimit_named_set nftHL_Set
syn match nft_payload_expr_ip6_hoplimit_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit '\vhoplimit' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_hoplimit_keyword_not,
\    nft_payload_expr_ip6_hoplimit_named_set,
\    nft_payload_expr_ip6_hoplimit_keyword_in,
\    nft_payload_expr_ip6_hoplimit_operator_2char,
\    nft_payload_expr_ip6_hoplimit_hex_value,
\    nft_payload_expr_ip6_hoplimit_operator_1char,
\    nft_chainError
" ************************* END ip6 hoplimit' *************************

" ************************* BEGIN ip6 nexthdr' *************************
" this section covers options specific to ip6 nexthdr'
" ************************* BEGIN ip6 nexthdr hop-by-hop' *************************
hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t;\n]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data '\vopt\-data\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_hex_value,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type '\vopt\-type\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_integer,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len '\vopt\-len\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_packet_length_integer,
\    nft_Error

hi link   nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop '\vhop\-by\-hop\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len,
\    nft_chainError
" ************************* END ip6 nexthdr hop-by-hop' *************************

" ************************* BEGIN ip6 nexthdr fragment' *************************
" ip6 nexthdr fragment: offset, more-fragments, id
hi link   nft_payload_expr_ip6_named_set_fragment_id nftHL_Integer
syn match nft_payload_expr_ip6_named_set_fragment_id '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t;$,]' skipwhite contained

hi link   nft_payload_expr_ip6_fragment_id nftHL_Integer
syn match nft_payload_expr_ip6_fragment_id '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_fragment_dash_symbol nftHL_Integer
syn match nft_payload_expr_ip6_fragment_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id,
\    nft_Error

hi link   nft_payload_expr_ip6_fragment_id_or_id_range nftHL_Integer
syn match nft_payload_expr_ip6_fragment_id_or_id_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_dash_symbol

hi link   nft_payload_expr_ip6_fragment_in_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_fragment_in_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_named_set_fragment_id

hi link   nft_payload_expr_ip6_fragment_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_in_set_block

hi link   nft_payload_expr_ip6_fragment_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_fragment_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_fragment_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_more_fragments nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_more_fragments '\vmore\-fragments\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_offset nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_offset '\voffset\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_id nftHL_Keyword
syn match nft_payload_expr_ip6_fragment_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_operator_2char,
\    nft_payload_expr_ip6_fragment_keyword_in,
\    nft_payload_expr_ip6_fragment_named_set,
\    nft_payload_expr_ip6_fragment_id_or_id_range,
\    nft_payload_expr_ip6_fragment_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_fragment_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_keyword_more_fragments,
\    nft_payload_expr_ip6_fragment_keyword_offset,
\    nft_payload_expr_ip6_fragment_keyword_id,
\    nft_chainError

hi link   nft_payload_expr_ip6_fragment_named_set nftHL_Set
syn match nft_payload_expr_ip6_fragment_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_keyword_fragment nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_fragment '\vfragment\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_fragment_keyword_more_fragments,
\    nft_payload_expr_ip6_fragment_keyword_offset,
\    nft_payload_expr_ip6_fragment_keyword_not,
\    nft_payload_expr_ip6_fragment_keyword_id,
\    nft_chainError
" ************************* END ip6 nexthdr fragment' *************************

" ************************* BEGIN ip6 nexthdr no-next' *************************
hi link   nft_payload_expr_ip6_nexthdr_keyword_no_next nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_no_next '\vno\-next\ze[ \t]' skipwhite contained
" ************************* END ip6 nexthdr no-next' *************************

" ************************* BEGIN ip6 nexthdr routing' *************************
" ip6 nexthdr routing: type, segments-left, addr
" ip6 nexthdr routing type 1
hi link   nft_payload_expr_ip6_nexthdr_routing_named_set nftHL_Set
syn match nft_payload_expr_ip6_nexthdr_routing_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_nexthdr_routing_type nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_type '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained

" ip6 nexthdr routing type in { 1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_type_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_type_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_type

" ip6 nexthdr routing type in
hi link   nft_payload_expr_ip6_nexthdr_routing_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type_set_block

" ip6 nexthdr routing type >
hi link   nft_payload_expr_ip6_nexthdr_routing_type_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_chainError

" ip6 nexthdr routing type >=
hi link   nft_payload_expr_ip6_nexthdr_routing_type_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_chainError

" ip6 nexthdr routing type
hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_type nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_type_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_type_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_type,
\    nft_payload_expr_ip6_nexthdr_routing_type_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained

" ip6 nexthdr routing segments_left in { 1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left

" ip6 nexthdr routing segments_left in
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_set_block

" ip6 nexthdr routing segments_left >
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_chainError

" ip6 nexthdr routing segments_left >=
hi link   nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_chainError

" ip6 nexthdr routing segments_left
hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left '\vsegments\-left\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left '\vsegments\-left\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_segments_left_operator_1char,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix '\v([0-9a-fA-F]{1,4}::{0,7}){1,7}[0-9a-fA-F]{1,4}' skipwhite contained

" ip6 nexthdr routing addr in { fffe:::1 }
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_set_block nftHL_BlockDelimitersSet
syn region nft_payload_expr_ip6_nexthdr_routing_addr_set_block start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix

" ip6 nexthdr routing addr in
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_set_block

" ip6 nexthdr routing addr >
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

" ip6 nexthdr routing addr >=
hi link   nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char nftHL_Expression
syn match nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_addr nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_addr '\vaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_addr_operator_2char,
\    nft_payload_expr_ip6_nexthdr_routing_addr_keyword_in,
\    nft_payload_expr_ip6_nexthdr_routing_named_set,
\    nft_payload_expr_ip6_nexthdr_routing_addr_operator_1char,
\    nft_payload_expr_ip6_nexthdr_routing_addr_ip6_addr_or_addr_prefix,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_routing_keyword_not nftHL_Operator
syn match nft_payload_expr_ip6_nexthdr_routing_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_offset,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_id,
\    nft_chainError

hi link   nft_payload_expr_ip6_nexthdr_keyword_routing nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_routing '\vrouting\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_routing_keyword_segments_left,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_addr,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_type,
\    nft_payload_expr_ip6_nexthdr_routing_keyword_not,
\    nft_chainError
" ************************* END ip6 nexthdr routing' *************************

" ************************* BEGIN icmp' expression *************************
" Often prepended with 'ip6 nexthdr icmp'
" type, code, checksum, type-specific fields (e.g., id, sequence)
hi link   nft_payload_expr_icmp_named_set nftHL_Set
syn match nft_payload_expr_icmp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t;$]' skipwhite contained

" ************************* BEGIN icmp checksum' expression *************************
hi link   nft_payload_expr_icmp_checksum_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_icmp_checksum_inline_set_checksum '\v(0x[0-9a-fA-F]{1,8})|([0-9]{1,10})\ze[ \t,\}$]' skipwhite contained

syn cluster nft_c_payload_expr_icmp_expressions
\ contains=
\    nft_payload_expr_icmp_keyword_checksum,
\    nft_payload_expr_icmp_keyword_sequence,
\    nft_payload_expr_icmp_keyword_gateway,
\    nft_payload_expr_icmp_keyword_code,
\    nft_payload_expr_icmp_keyword_type,
\    nft_payload_expr_icmp_keyword_mtu,
\    nft_payload_expr_icmp_keyword_id,

" 'icmp checksum in { 1 }'
hi link   nft_payload_expr_icmp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_checksum_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_checksum_inline_set_checksum
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp checksum in'
hi link   nft_payload_expr_icmp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_checksum nftHL_Integer
syn match nft_payload_expr_icmp_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp checksum >'
hi link   nft_payload_expr_icmp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum,
\    nft_chainError

" 'icmp checksum >='
hi link   nft_payload_expr_icmp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum,
\    nft_chainError

" 'icmp checksum'
hi link   nft_payload_expr_icmp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_checksum_operator_2char,
\    nft_payload_expr_icmp_checksum_keyword_in,
\    nft_payload_expr_icmp_checksum_operator_1char,
\    nft_payload_expr_icmp_checksum_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_checksum,
\    nft_chainError
" ************************* END icmp checksum' expression *************************

" ************************* BEGIN icmp gateway' expression *************************
hi link   nft_payload_expr_icmp_gateway_inline_set_gateway nftHL_Integer
syn match nft_payload_expr_icmp_gateway_inline_set_gateway '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}$]' skipwhite contained

" 'icmp gateway in { 1 }'
hi link    nft_payload_expr_icmp_gateway_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_gateway_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_gateway_inline_set_gateway
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp gateway in'
hi link   nft_payload_expr_icmp_gateway_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_gateway_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_gateway nftHL_Integer
syn match nft_payload_expr_icmp_gateway '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp gateway >'
hi link   nft_payload_expr_icmp_gateway_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_gateway_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway,
\    nft_chainError

" 'icmp gateway >='
hi link   nft_payload_expr_icmp_gateway_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_gateway_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway,
\    nft_chainError

" 'icmp gateway'
hi link   nft_payload_expr_icmp_keyword_gateway nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_gateway '\vgateway\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_gateway_operator_2char,
\    nft_payload_expr_icmp_gateway_keyword_in,
\    nft_payload_expr_icmp_gateway_operator_1char,
\    nft_payload_expr_icmp_gateway_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_gateway,
\    nft_chainError
" ************************* END icmp gateway' expression *************************

" ************************* BEGIN icmp sequence' expression *************************
hi link   nft_payload_expr_icmp_sequence_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_icmp_sequence_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}$]' skipwhite contained

" 'icmp sequence in { 1 }'
hi link    nft_payload_expr_icmp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_sequence_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_sequence_inline_set_sequence
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp sequence in'
hi link   nft_payload_expr_icmp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_sequence nftHL_Integer
syn match nft_payload_expr_icmp_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp sequence >'
hi link   nft_payload_expr_icmp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_sequence_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence,
\    nft_chainError

" 'icmp sequence >='
hi link   nft_payload_expr_icmp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_sequence_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence,
\    nft_chainError

" 'icmp sequence'
hi link   nft_payload_expr_icmp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_sequence_operator_2char,
\    nft_payload_expr_icmp_sequence_keyword_in,
\    nft_payload_expr_icmp_sequence_operator_1char,
\    nft_payload_expr_icmp_sequence_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_sequence,
\    nft_chainError
" ************************* END icmp sequence' expression *************************

" ************************* BEGIN icmp code' expression *************************
" 'icmp code { 1 }'
hi link   nft_payload_expr_icmp_code_inline_set_num nftHL_Integer
syn match nft_payload_expr_icmp_code_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,\}$]' skipwhite contained

" 'icmp code in { }'
hi link    nft_payload_expr_icmp_code_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_code_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_code_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp code in'
hi link   nft_payload_expr_icmp_code_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_code_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_inline_set

" 'icmp code 1'
hi link   nft_payload_expr_icmp_code_num nftHL_Integer
syn match nft_payload_expr_icmp_code_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'icmp code >'
hi link   nft_payload_expr_icmp_code_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_code_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_num,
\    nft_chainError

" 'icmp code >='
hi link   nft_payload_expr_icmp_code_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_code_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_num,
\    nft_chainError

" 'icmp code'
hi link   nft_payload_expr_icmp_keyword_code nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_code '\vcode\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_code_operator_2char,
\    nft_payload_expr_icmp_code_keyword_in,
\    nft_payload_expr_icmp_code_operator_1char,
\    nft_payload_expr_icmp_code_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_code_num,
\    nft_chainError
" ************************* END icmp code' expression *************************

" ************************* BEGIN icmp type' expression *************************
" ip6 nexthdr icmp type <type_name>
hi link   nft_payload_expr_icmp_type_inline_set_type_num Define
syn match nft_payload_expr_icmp_type_inline_set_type_num '\v[0-9]{1,3}\ze[ \t,\}$]' skipwhite contained

hi link   nft_payload_expr_icmp_type_inline_set_type_defines Define
syn match nft_payload_expr_icmp_type_inline_set_type_defines '\v(destination\-unreachable|address\-mask\-request|router\-advertisement|info\-request|router\-solicitation|address\-mask\-reply|info\-reply|parameter\-problem|timestamp\-request|timestamp\-reply|source\-quench|time\-exceeded|echo\-request|echo\-reply|redirect)\ze[ \t,\}$]' skipwhite contained

" ip6 nexthdr icmp type in { 1 }
hi link    nft_payload_expr_icmp_type_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_type_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_type_inline_set_type_defines,
\    nft_payload_expr_icmp_type_inline_set_type_num
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions


" ip6 nexthdr icmp type in
hi link   nft_payload_expr_icmp_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_inline_set

hi link   nft_payload_expr_icmp_type_num Define
syn match nft_payload_expr_icmp_type_num '\v[0-9]{1,3}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

hi link   nft_payload_expr_icmp_type_defines Define
syn match nft_payload_expr_icmp_type_defines '\v(destination\-unreachable|address\-mask\-request|router\-advertisement|info\-request|router\-solicitation|address\-mask\-reply|info\-reply|parameter\-problem|timestamp\-request|timestamp\-reply|source\-quench|time\-exceeded|echo\-request|echo\-reply|redirect)\ze[ \t]' skipwhite contained
\ skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" 'ip6 nexthdr icmp type >'
hi link   nft_payload_expr_icmp_type_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError

" 'icmp type >='
hi link   nft_payload_expr_icmp_type_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError

" 'icmp type'
hi link   nft_payload_expr_icmp_keyword_type nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_type_defines,
\    nft_payload_expr_icmp_type_operator_2char,
\    nft_payload_expr_icmp_type_keyword_in,
\    nft_payload_expr_icmp_type_operator_1char,
\    nft_payload_expr_icmp_type_inline_set,
\    nft_payload_expr_named_set,
\    nft_payload_expr_icmp_type_num,
\    nft_chainError
" ************************* END icmp type' expression *************************

" ************************* BEGIN icmp mtu' expression *************************
" ip6 nexthdr icmp mtu in { 1,127,255 }
hi link   nft_payload_expr_icmp_inline_set_mtu nftHL_Integer
syn match nft_payload_expr_icmp_inline_set_mtu '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}$]' skipwhite contained

" ip6 nexthdr icmp mtu in {  }
hi link    nft_payload_expr_icmp_mtu_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_mtu_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_inline_set_mtu
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp mtu in
hi link   nft_payload_expr_icmp_mtu_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_mtu_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_inline_set

hi link   nft_payload_expr_icmp_mtu_num nftHL_Integer
syn match nft_payload_expr_icmp_mtu_num '\v[0-9]{1,5}\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp mtu >
hi link   nft_payload_expr_icmp_mtu_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_mtu_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError

" ip6 nexthdr icmp mtu >=
hi link   nft_payload_expr_icmp_mtu_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_mtu_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError

" ip6 nexthdr icmp mtu
hi link   nft_payload_expr_icmp_keyword_mtu nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_mtu '\vmtu\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_mtu_operator_2char,
\    nft_payload_expr_icmp_mtu_keyword_in,
\    nft_payload_expr_icmp_mtu_operator_1char,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_mtu_inline_set,
\    nft_payload_expr_icmp_mtu_num,
\    nft_chainError
" ************************* END icmp mtu' expression *************************

" ************************* BEGIN icmp id' expression *************************
" ip6 nexthdr icmp id in { 1,127,255 }
hi link   nft_payload_expr_icmp_id_inline_set_num nftHL_Integer
syn match nft_payload_expr_icmp_id_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,$]' skipwhite contained

" ip6 nexthdr icmp id in {  }
hi link    nft_payload_expr_icmp_id_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmp_id_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmp_id_inline_set_num
\ nextgroup=
\    nft_c_payload_expr_icmp_expressions

" ip6 nexthdr icmp id in
hi link   nft_payload_expr_icmp_id_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmp_id_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_inline_set

hi link   nft_payload_expr_icmp_id_num nftHL_Integer
syn match nft_payload_expr_icmp_id_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmp_expressions
" ip6 nexthdr icmp id >
hi link   nft_payload_expr_icmp_id_operator_1char nftHL_Expression
syn match nft_payload_expr_icmp_id_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_num,
\    nft_chainError

" ip6 nexthdr icmp id >=
hi link   nft_payload_expr_icmp_id_operator_2char nftHL_Expression
syn match nft_payload_expr_icmp_id_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_num,
\    nft_chainError

" ip6 nexthdr icmp id
hi link   nft_payload_expr_icmp_keyword_id nftHL_Keyword
syn match nft_payload_expr_icmp_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_id_operator_2char,
\    nft_payload_expr_icmp_id_keyword_in,
\    nft_payload_expr_icmp_id_operator_1char,
\    nft_payload_expr_icmp_id_inline_set,
\    nft_payload_expr_icmp_named_set,
\    nft_payload_expr_icmp_id_num,
\    nft_chainError
" ************************* END icmp id' expression *************************

" icmp nexthdr: echo-reply, destination-unreachable, source-quench, redirect, echo-request, router-advertisement, router-solicitation, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply.
" 'icmp': type, code, checksum, id, sequence, gateway, mtu
hi link   nft_payload_expr_icmp_hdr_expr_keyword_icmp nftHL_Command
syn match nft_payload_expr_icmp_hdr_expr_keyword_icmp '\vicmp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmp_keyword_sequence,
\    nft_payload_expr_icmp_keyword_checksum,
\    nft_payload_expr_icmp_keyword_gateway,
\    nft_payload_expr_icmp_keyword_code,
\    nft_payload_expr_icmp_keyword_type,
\    nft_payload_expr_icmp_keyword_mtu,
\    nft_payload_expr_icmp_keyword_id,
\    nft_chainError
" ************************* END icmp' expression *************************

" ************************* BEGIN icmpv6' expression *************************
" Often prepended with 'ip6 nexthdr icmpv6'
" type, code, checksum, type-specific fields (e.g., id, sequence)
hi link   nft_payload_expr_icmpv6_named_set nftHL_Set
syn match nft_payload_expr_icmpv6_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t;$]' skipwhite contained

syn cluster nft_c_payload_expr_icmpv6_expressions
\ contains=
\    nft_payload_expr_icmpv6_keyword_checksum,
\    nft_payload_expr_icmpv6_keyword_sequence,
\    nft_payload_expr_icmpv6_keyword_gateway,
\    nft_payload_expr_icmpv6_keyword_code,
\    nft_payload_expr_icmpv6_keyword_type,
\    nft_payload_expr_icmpv6_keyword_mtu,
\    nft_payload_expr_icmpv6_keyword_id,

" ************************* BEGIN icmpv6 sequence' expression *************************
hi link   nft_payload_expr_icmpv6_sequence_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_icmpv6_sequence_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,;$]' skipwhite contained

" 'icmpv6 sequence in { 1 }'
hi link    nft_payload_expr_icmpv6_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmpv6_sequence_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmpv6_sequence_inline_set_sequence
\ nextgroup=
\    nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 sequence in'
hi link   nft_payload_expr_icmpv6_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmpv6_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_sequence_inline_set

" 'icmpv6 code 1'
hi link   nft_payload_expr_icmpv6_sequence nftHL_Integer
syn match nft_payload_expr_icmpv6_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 sequence >'
hi link   nft_payload_expr_icmpv6_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_icmpv6_sequence_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_sequence,
\    nft_chainError

" 'icmpv6 sequence >='
hi link   nft_payload_expr_icmpv6_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_icmpv6_sequence_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_sequence,
\    nft_chainError

" 'icmpv6 sequence'
hi link   nft_payload_expr_icmpv6_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_icmpv6_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_sequence_operator_2char,
\    nft_payload_expr_icmpv6_sequence_keyword_in,
\    nft_payload_expr_icmpv6_sequence,
\    nft_payload_expr_icmpv6_sequence_operator_1char,
\    nft_payload_expr_icmpv6_named_set,
\    nft_chainError
" ************************* END icmpv6 sequence' expression *************************

" ************************* BEGIN icmpv6 checksum' expression *************************
hi link   nft_payload_expr_icmpv6_checksum_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_icmpv6_checksum_inline_set_checksum '\v(0x[0-9a-fA-F]{1,8})|([0-9]{1,10})\ze[ \t,;$]' skipwhite contained

" 'icmpv6 checksum in { 1 }'
hi link    nft_payload_expr_icmpv6_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmpv6_checksum_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmpv6_checksum_inline_set_checksum
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 checksum in'
hi link   nft_payload_expr_icmpv6_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmpv6_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_checksum_inline_set

" 'icmpv6 code 1'
hi link   nft_payload_expr_icmpv6_checksum nftHL_Integer
syn match nft_payload_expr_icmpv6_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 checksum >'
hi link   nft_payload_expr_icmpv6_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_icmpv6_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_checksum,
\    nft_chainError

" 'icmpv6 checksum >='
hi link   nft_payload_expr_icmpv6_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_icmpv6_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_checksum,
\    nft_chainError

" 'icmpv6 checksum'
hi link   nft_payload_expr_icmpv6_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_icmpv6_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_checksum_operator_2char,
\    nft_payload_expr_icmpv6_checksum_keyword_in,
\    nft_payload_expr_icmpv6_checksum,
\    nft_payload_expr_icmpv6_checksum_operator_1char,
\    nft_payload_expr_icmpv6_named_set,
\    nft_payload_expr_icmpv6_checksum_inline_set,
\    nft_chainError
" ************************* END icmpv6 checksum' expression *************************

" ************************* BEGIN icmpv6 code' expression *************************
hi link   nft_payload_expr_icmpv6_code_inline_set_num nftHL_Integer
syn match nft_payload_expr_icmpv6_code_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained

" 'icmpv6 code in { 1 }'
hi link   nft_payload_expr_icmpv6_code_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmpv6_code_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmpv6_code_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 code in'
hi link   nft_payload_expr_icmpv6_code_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmpv6_code_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_code_inline_set

" 'icmpv6 code 1'
hi link   nft_payload_expr_icmpv6_code_num nftHL_Integer
syn match nft_payload_expr_icmpv6_code_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" 'icmpv6 code >'
hi link   nft_payload_expr_icmpv6_code_operator_1char nftHL_Expression
syn match nft_payload_expr_icmpv6_code_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_code_num,
\    nft_chainError

" 'icmpv6 code >='
hi link   nft_payload_expr_icmpv6_code_operator_2char nftHL_Expression
syn match nft_payload_expr_icmpv6_code_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_code_num,
\    nft_chainError

" 'icmpv6 code'
hi link   nft_payload_expr_icmpv6_keyword_code nftHL_Keyword
syn match nft_payload_expr_icmpv6_keyword_code '\vcode\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_code_operator_2char,
\    nft_payload_expr_icmpv6_code_keyword_in,
\    nft_payload_expr_icmpv6_code_num,
\    nft_payload_expr_icmpv6_code_operator_1char,
\    nft_payload_expr_icmpv6_code_inline_set,
\    nft_payload_expr_icmpv6_named_set,
\    nft_chainError
" ************************* END icmpv6 code' expression *************************

" ************************* BEGIN icmpv6 type' expression *************************
hi link   nft_payload_expr_icmpv6_inline_set_type_num nftHL_Integer
syn match nft_payload_expr_icmpv6_inline_set_type_num '\v[0-9]{1,3}\ze[ \t\},$]' skipwhite contained

hi link   nft_payload_expr_icmpv6_inline_set_type_defines nftHL_Define
syn match nft_payload_expr_icmpv6_inline_set_type_defines
\ '\v(destination\-unreachable|mld\-listener\-reduction|nd\-neighbor\-solicit|mld\-listener\-report|nd\-neighbor\-advert|mld\-listener\-query|nd\-router\-solicit|parameter\-problem|nd\-router\-advert|packet\-too\-big|time\-exceeded|nd\-redirect|echo\-request|echo\-reply)\ze[ \t\},$]'
\ skipwhite contained

" ip6 nexthdr icmpv6 type in { 1 }
hi link    nft_payload_expr_icmpv6_type_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmpv6_type_inline_set start=+{+ end=+}+ skip="#.{0,45}$" skipwhite contained
\ contains=
\    nft_payload_expr_icmpv6_inline_set_type_defines,
\    nft_payload_expr_icmpv6_inline_set_type_num
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" ip6 nexthdr icmpv6 type in
hi link   nft_payload_expr_icmpv6_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmpv6_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_type_inline_set,
\    nft_Error

hi link   nft_payload_expr_icmpv6_type_num nftHL_Integer
syn match nft_payload_expr_icmpv6_type_num '\v[0-9]{1,3}\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

hi link   nft_payload_expr_icmpv6_type_defines nftHL_Define
syn match nft_payload_expr_icmpv6_type_defines
\ '\v(destination\-unreachable|mld\-listener\-reduction|nd\-neighbor\-solicit|mld\-listener\-report|nd\-neighbor\-advert|mld\-listener\-query|nd\-router\-solicit|parameter\-problem|nd\-router\-advert|packet\-too\-big|time\-exceeded|nd\-redirect|echo\-request|echo\-reply)'
\ skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" ip6 nexthdr icmpv6 type >
hi link   nft_payload_expr_icmpv6_type_operator_1char nftHL_Expression
syn match nft_payload_expr_icmpv6_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_type_defines,
\    nft_payload_expr_icmpv6_type_num,
\    nft_chainError

" ip6 nexthdr icmpv6 type >=
hi link   nft_payload_expr_icmpv6_type_operator_2char nftHL_Expression
syn match nft_payload_expr_icmpv6_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_type_defines,
\    nft_payload_expr_icmpv6_type_num,
\    nft_chainError

" ip6 nexthdr icmpv6 type
hi link   nft_payload_expr_icmpv6_keyword_type nftHL_Keyword
syn match nft_payload_expr_icmpv6_keyword_type '\vtype\ze[ \t$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_type_operator_2char,
\    nft_payload_expr_icmpv6_type_keyword_in,
\    nft_payload_expr_icmpv6_type_defines,
\    nft_payload_expr_icmpv6_type_operator_1char,
\    nft_payload_expr_icmpv6_type_inline_set,
\    nft_payload_expr_icmpv6_named_set,
\    nft_payload_expr_icmpv6_type_num,
\    nft_chainError
" ************************* END icmpv6 type' expression *************************

" ************************* BEGIN icmpv6 id' expression *************************
" ip6 nexthdr icmpv6 id in { 1,127,255 }
hi link   nft_payload_expr_icmpv6_inline_set_id nftHL_Integer
syn match nft_payload_expr_icmpv6_inline_set_id '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,$\}]' skipwhite contained

" ip6 nexthdr icmpv6 id in {  }
hi link    nft_payload_expr_icmpv6_id_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_icmpv6_id_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_icmpv6_inline_set_id
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" ip6 nexthdr icmpv6 id in
hi link   nft_payload_expr_icmpv6_id_keyword_in nftHL_Keyword
syn match nft_payload_expr_icmpv6_id_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_id_inline_set,
\    nft_Error

hi link   nft_payload_expr_icmpv6_id nftHL_Integer
syn match nft_payload_expr_icmpv6_id '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t$]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_icmpv6_expressions

" ip6 nexthdr icmpv6 id >
hi link   nft_payload_expr_icmpv6_id_operator_1char nftHL_Expression
syn match nft_payload_expr_icmpv6_id_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_id,
\    nft_chainError

" ip6 nexthdr icmpv6 id >=
hi link   nft_payload_expr_icmpv6_id_operator_2char nftHL_Expression
syn match nft_payload_expr_icmpv6_id_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_id,
\    nft_chainError

" ip6 nexthdr icmpv6 id
hi link   nft_payload_expr_icmpv6_keyword_id nftHL_Keyword
syn match nft_payload_expr_icmpv6_keyword_id '\vid\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_id_operator_2char,
\    nft_payload_expr_icmpv6_id_keyword_in,
\    nft_payload_expr_icmpv6_id_operator_1char,
\    nft_payload_expr_icmpv6_id,
\    nft_payload_expr_named_set,
\    nft_payload_expr_icmpv6_id_inline_set,
\    nft_chainError
" ************************* END icmpv6 id' expression *************************

syn cluster nft_c_payload_expr_icmpv6_expressions
\ contains=
\    nft_payload_expr_icmpv6_keyword_sequence,
\    nft_payload_expr_icmpv6_keyword_checksum,
\    nft_payload_expr_icmpv6_keyword_code,
\    nft_payload_expr_icmpv6_keyword_type,
\    nft_payload_expr_icmpv6_keyword_id

" 'icmpv6', or 'ip6 nexthdr icmpv6 icmpv6'
hi link   nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6 nftHL_Command
syn match nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6 '\vicmpv6' skipwhite contained
\ nextgroup=
\    nft_payload_expr_icmpv6_keyword_sequence,
\    nft_payload_expr_icmpv6_keyword_checksum,
\    nft_payload_expr_icmpv6_keyword_code,
\    nft_payload_expr_icmpv6_keyword_type,
\    nft_payload_expr_icmpv6_keyword_id,
\    nft_chainError
" ************************* END icmpv6' expression *************************

" ************************* BEGIN dccp' expression *************************
" dccp: sport, dport, type, checksum

" ************************* BEGIN dccp checksum' *************************
" 'dccp checksum 0xffffffff'
hi link   nft_payload_expr_dccp_checksum nftHL_Integer
syn match nft_payload_expr_dccp_checksum '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp checksum in { 1,127,255 }"
hi link   nft_payload_expr_dccp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,;$\}]' skipwhite contained

" 'dccp checksum in {  }'
hi link    nft_payload_expr_dccp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_checksum

" 'dccp checksum in'
hi link   nft_payload_expr_dccp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum_inline_set

" 'dccp checksum >'
hi link   nft_payload_expr_dccp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum,
\    nft_chainError

" 'dccp checksum >='
hi link   nft_payload_expr_dccp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum,
\    nft_chainError

" 'dccp checksum'
hi link   nft_payload_expr_dccp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_checksum_operator_2char,
\    nft_payload_expr_dccp_checksum_keyword_in,
\    nft_payload_expr_dccp_checksum_operator_1char,
\    nft_payload_expr_dccp_checksum,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END ip6 nexthdr dccp checksum' *************************

" ************************* BEGIN ip6 nexthdr dccp dport' *************************
" 'dccp dport'
hi link   nft_payload_expr_dccp_dport nftHL_Integer
syn match nft_payload_expr_dccp_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp dport in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,;$\}]' skipwhite contained

" 'dccp dport in {  }'
hi link    nft_payload_expr_dccp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_dport

" 'dccp dport in'
hi link   nft_payload_expr_dccp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport_inline_set

" 'dccp dport >'
hi link   nft_payload_expr_dccp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport,
\    nft_chainError

" 'dccp dport >='
hi link   nft_payload_expr_dccp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport,
\    nft_chainError

" 'dccp dport'
hi link   nft_payload_expr_dccp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_dport_operator_2char,
\    nft_payload_expr_dccp_dport_keyword_in,
\    nft_payload_expr_dccp_dport_operator_1char,
\    nft_payload_expr_dccp_dport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END dccp dport' *************************

" ************************* BEGIN dccp sport' *************************
" 'dccp sport"
hi link   nft_payload_expr_dccp_sport nftHL_Integer
syn match nft_payload_expr_dccp_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_type,

" 'dccp sport in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,;$\}]' skipwhite contained

" 'dccp sport in {  }'
hi link    nft_payload_expr_dccp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_sport

" 'dccp sport in'
hi link   nft_payload_expr_dccp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport_inline_set

" 'dccp sport >'
hi link   nft_payload_expr_dccp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport,
\    nft_chainError

" 'dccp sport >='
hi link   nft_payload_expr_dccp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport,
\    nft_chainError

" 'dccp sport"
hi link   nft_payload_expr_dccp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_sport_operator_2char,
\    nft_payload_expr_dccp_sport_keyword_in,
\    nft_payload_expr_dccp_sport_operator_1char,
\    nft_payload_expr_dccp_sport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END dccp sport' *************************

" ************************* BEGIN dccp type' *************************
hi link   nft_payload_expr_dccp_type nftHL_Define
syn match nft_payload_expr_dccp_type '\v(closereq|response|dataack|request|syncack|close|reset|data|sync|ack)' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,

" ' dccp type 14'
hi link   nft_payload_expr_dccp_type_int nftHL_Integer
syn match nft_payload_expr_dccp_type_int '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,1}))\ze[ \t,;$\}]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,

" 'dccp type in { 1,127,255 }'
hi link   nft_payload_expr_dccp_inline_set_type nftHL_Define
syn match nft_payload_expr_dccp_inline_set_type '\v(closereq|response|dataack|request|syncack|close|reset|data|sync|ack)' skipwhite contained
hi link   nft_payload_expr_dccp_inline_set_type_int nftHL_Integer
syn match nft_payload_expr_dccp_inline_set_type_int '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,;$\}]' skipwhite contained

" ip6 nexthdr dccp type in {  }
hi link    nft_payload_expr_dccp_type_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_dccp_type_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_dccp_inline_set_type,
\    nft_payload_expr_dccp_inline_set_type_int

" 'dccp type in'
hi link   nft_payload_expr_dccp_type_keyword_in nftHL_Keyword
syn match nft_payload_expr_dccp_type_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type_inline_set

" 'dccp type >'
hi link   nft_payload_expr_dccp_type_operator_1char nftHL_Expression
syn match nft_payload_expr_dccp_type_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError

" 'dccp type >='
hi link   nft_payload_expr_dccp_type_operator_2char nftHL_Expression
syn match nft_payload_expr_dccp_type_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError

" 'dccp type'
hi link   nft_payload_expr_dccp_keyword_type nftHL_Keyword
syn match nft_payload_expr_dccp_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_type,
\    nft_payload_expr_dccp_type_operator_2char,
\    nft_payload_expr_dccp_type_keyword_in,
\    nft_payload_expr_named_set,
\    nft_payload_expr_dccp_type_operator_1char,
\    nft_payload_expr_dccp_type_int,
\    nft_chainError
" ************************* END dccp type' *************************

hi link   nft_payload_expr_dccp_hdr_expr_keyword_dccp nftHL_Statement
syn match nft_payload_expr_dccp_hdr_expr_keyword_dccp '\vdccp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_dccp_keyword_checksum,
\    nft_payload_expr_dccp_keyword_dport,
\    nft_payload_expr_dccp_keyword_sport,
\    nft_payload_expr_dccp_keyword_type,
\    nft_chainError
" ************************* END dccp' *************************

" ************************* BEGIN dest' *************************
"  dest: opt-type, opt-len, opt-data
hi link   nft_payload_expr_ip6_nexthdr_keyword_dest nftHL_Keyword
syn match nft_payload_expr_ip6_nexthdr_keyword_dest '\vdest\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_data,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_type,
\    nft_payload_expr_ip6_nexthdr_hop_by_hop_keyword_opt_len,
\    nft_chainError
" ************************* END dest' *************************

" ************************* BEGIN sctp' payload expression *************************
"  sctp: sport, dport, vtag, checksum
" ************************* BEGIN sctp checksum' *************************
"  sctp checksum
hi link   nft_payload_expr_sctp_checksum_second nftHL_Integer
syn match nft_payload_expr_sctp_checksum_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag

hi link   nft_payload_expr_sctp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_sctp_checksum_dash_symbol '\v\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_second,
\    nft_chainError

hi link   nft_payload_expr_sctp_checksum nftHL_Integer
syn match nft_payload_expr_sctp_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;\-$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_dash_symbol,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,

"  'sctp checksum in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,;$\}]' skipwhite contained

" 'sctp checksum in {  }'
hi link    nft_payload_expr_sctp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_checksum

" 'sctp checksum in'
hi link   nft_payload_expr_sctp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_inline_set

" 'sctp checksum >'
hi link   nft_payload_expr_sctp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum,
\    nft_chainError

" 'sctp checksum >='
hi link   nft_payload_expr_sctp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum,
\    nft_chainError

" 'sctp checksum'
hi link   nft_payload_expr_sctp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_checksum_operator_2char,
\    nft_payload_expr_sctp_checksum_keyword_in,
\    nft_payload_expr_sctp_checksum_operator_1char,
\    nft_payload_expr_sctp_checksum,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp checksum' *************************

" ************************* BEGIN sctp dport' *************************
" 'sctp dport'
hi link   nft_payload_expr_sctp_dport nftHL_Integer
syn match nft_payload_expr_sctp_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,

" 'sctp dport in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,;$\}]' skipwhite contained

" 'sctp dport in {  }'
hi link    nft_payload_expr_sctp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_dport

" 'sctp dport in'
hi link   nft_payload_expr_sctp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport_inline_set

" 'sctp dport >'
hi link   nft_payload_expr_sctp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport,
\    nft_chainError

" 'sctp dport >='
hi link   nft_payload_expr_sctp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport,
\    nft_chainError

" 'sctp dport'
hi link   nft_payload_expr_sctp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_dport_operator_2char,
\    nft_payload_expr_sctp_dport_keyword_in,
\    nft_payload_expr_sctp_dport_operator_1char,
\    nft_payload_expr_sctp_dport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  sctp dport' *************************

" ************************* BEGIN  sctp sport' *************************
" 'sctp sport'
hi link   nft_payload_expr_sctp_sport nftHL_Integer
syn match nft_payload_expr_sctp_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_vtag,

" 'sctp sport in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,;$\}]' skipwhite contained

" 'sctp sport in {  }'
hi link    nft_payload_expr_sctp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_sport

" 'sctp sport in'
hi link   nft_payload_expr_sctp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport_inline_set

" 'sctp sport >'
hi link   nft_payload_expr_sctp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport,
\    nft_chainError

" 'sctp sport >='
hi link   nft_payload_expr_sctp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport,
\    nft_chainError

" 'sctp sport'
hi link   nft_payload_expr_sctp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_sport_operator_2char,
\    nft_payload_expr_sctp_sport_keyword_in,
\    nft_payload_expr_sctp_sport_operator_1char,
\    nft_payload_expr_sctp_sport,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp sport' *************************

" ************************* BEGIN sctp vtag' *************************
" 'sctp vtag 1-2'
hi link   nft_payload_expr_sctp_vtag_second nftHL_Integer
syn match nft_payload_expr_sctp_vtag_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag

" 'sctp vtag 1-'
hi link   nft_payload_expr_sctp_vtag_dash_symbol nftHL_Expression
syn match nft_payload_expr_sctp_vtag_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_second,
\    nft_chainError

" 'sctp vtag 1'
hi link   nft_payload_expr_sctp_vtag nftHL_Integer
syn match nft_payload_expr_sctp_vtag '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_vtag,
\    nft_payload_expr_sctp_vtag_dash_symbol,

" 'sctp vtag in { 1,127,255 }'
hi link   nft_payload_expr_sctp_inline_set_vtag nftHL_Integer
syn match nft_payload_expr_sctp_inline_set_vtag '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,;$\}]' contained

" 'sctp vtag in {  }'
hi link    nft_payload_expr_sctp_vtag_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_sctp_vtag_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_sctp_inline_set_vtag,

" 'sctp vtag in'
hi link   nft_payload_expr_sctp_vtag_keyword_in nftHL_Keyword
syn match nft_payload_expr_sctp_vtag_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_inline_set

" 'sctp vtag >'
hi link   nft_payload_expr_sctp_vtag_operator_1char nftHL_Expression
syn match nft_payload_expr_sctp_vtag_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag,
\    nft_chainError

" 'sctp vtag >='
hi link   nft_payload_expr_sctp_vtag_operator_2char nftHL_Expression
syn match nft_payload_expr_sctp_vtag_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag,
\    nft_chainError

" 'sctp vtag'
hi link   nft_payload_expr_sctp_keyword_vtag nftHL_Keyword
syn match nft_payload_expr_sctp_keyword_vtag '\vvtag\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_vtag_operator_2char,
\    nft_payload_expr_sctp_vtag_keyword_in,
\    nft_payload_expr_sctp_vtag_operator_1char,
\    nft_payload_expr_sctp_vtag,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END sctp vtag' *************************

hi link   nft_payload_expr_sctp_hdr_expr_keyword_sctp nftHL_Statement
syn match nft_payload_expr_sctp_hdr_expr_keyword_sctp '\vsctp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_sctp_keyword_checksum,
\    nft_payload_expr_sctp_keyword_dport,
\    nft_payload_expr_sctp_keyword_sport,
\    nft_payload_expr_sctp_keyword_vtag,
\    nft_chainError
" ************************* END  sctp' *************************

" ************************* BEGIN ether_hdr_expr' *************************
hi link   nft_ether_hdr_expr_types nftHL_Number
syn match nft_ether_hdr_expr_types '\v((0[xX][0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained

" this 'set' is not a Command/Statement, it is an 'Action'/expression/write-only
hi link   nft_payload_expr_ether_hdr_expr_keyword_set nftHL_Write
syn match nft_payload_expr_ether_hdr_expr_keyword_set '\vset' skipwhite contained
\ nextgroup=
\    @nft_c_stmt_expr,
\    nft_ether_hdr_expr_macaddr

hi link   nft_ether_hdr_expr_macaddr nftHL_Number
syn match nft_ether_hdr_expr_macaddr '\v[0-9a-fA-F]{1,2}(:[0-9a-fA-F]{1,2}){5}' skipwhite contained

hi link   nft_ether_hdr_expr_keyword_daddr nftHL_Keyword
syn match nft_ether_hdr_expr_keyword_daddr '\vdaddr' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ether_hdr_expr_keyword_set,
\    nft_ether_hdr_expr_macaddr

hi link   nft_ether_hdr_expr_keyword_saddr nftHL_Keyword
syn match nft_ether_hdr_expr_keyword_saddr '\vsaddr' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ether_hdr_expr_keyword_set,
\    nft_ether_hdr_expr_macaddr

hi link   nft_ether_hdr_expr_keyword_type nftHL_Keyword
syn match nft_ether_hdr_expr_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_ether_hdr_expr_types

hi link   nft_payload_expr_ether_hdr_expr_keyword_ether nftHL_Statement
syn match nft_payload_expr_ether_hdr_expr_keyword_ether '\vether' skipwhite contained
\ nextgroup=
\    nft_ether_hdr_expr_keyword_daddr,
\    nft_ether_hdr_expr_keyword_saddr,
\    nft_ether_hdr_expr_keyword_type,
\    nft_chainError
" ************************* END ether_hdr_expr' *****************

" ************************* Begin payload_expr esp_hdr_expr *********
"  esp: spi, sequence
" ************************* BEGIN  esp sequence' ****************
"  esp sequence
hi link   nft_payload_expr_esp_sequence_second nftHL_Integer
syn match nft_payload_expr_esp_sequence_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_spi,

hi link   nft_payload_expr_esp_sequence_dash_symbol nftHL_Expression
syn match nft_payload_expr_esp_sequence_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_second,
\    nft_chainError

hi link   nft_payload_expr_esp_sequence nftHL_Integer
syn match nft_payload_expr_esp_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_spi,
\    nft_payload_expr_esp_sequence_dash_symbol

"  esp sequence in { 1,127,255 }
hi link   nft_payload_expr_esp_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_esp_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,;$\}]' contained

"  esp sequence in {  }
hi link    nft_payload_expr_esp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_esp_sequence_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_esp_inline_set_sequence

"  esp sequence in
hi link   nft_payload_expr_esp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_esp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_inline_set

"  esp sequence >
hi link   nft_payload_expr_esp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_esp_sequence_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence,
\    nft_chainError

"  esp sequence >=
hi link   nft_payload_expr_esp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_esp_sequence_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence,
\    nft_chainError

"  esp sequence
hi link   nft_payload_expr_esp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_esp_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_sequence_operator_2char,
\    nft_payload_expr_esp_sequence_keyword_in,
\    nft_payload_expr_esp_sequence_operator_1char,
\    nft_payload_expr_esp_sequence,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  esp sequence' *************************

" ************************* BEGIN  esp spi' *************************
"  esp spi
hi link   nft_payload_expr_esp_spi_second nftHL_Integer
syn match nft_payload_expr_esp_spi_second '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,

hi link   nft_payload_expr_esp_spi_dash_symbol nftHL_Expression
syn match nft_payload_expr_esp_spi_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_esp_spi_second,
\    nft_chainError

hi link   nft_payload_expr_esp_spi nftHL_Integer
syn match nft_payload_expr_esp_spi '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))' contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_spi_dash_symbol,

"  esp spi in { 1,127,255 }
hi link   nft_payload_expr_esp_inline_set_spi nftHL_Integer
syn match nft_payload_expr_esp_inline_set_spi '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,;$\}]' contained

"  esp spi in {  }
hi link    nft_payload_expr_esp_spi_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_esp_spi_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_esp_inline_set_spi,

"  esp spi >
hi link   nft_payload_expr_esp_spi_operator_1char nftHL_Expression
syn match nft_payload_expr_esp_spi_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi,
\    nft_chainError

"  esp spi >=
hi link   nft_payload_expr_esp_spi_operator_2char nftHL_Expression
syn match nft_payload_expr_esp_spi_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi,
\    nft_chainError

"  esp spi in
hi link   nft_payload_expr_esp_spi_keyword_in nftHL_Keyword
syn match nft_payload_expr_esp_spi_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi_inline_set

"  esp spi
hi link   nft_payload_expr_esp_keyword_spi nftHL_Keyword
syn match nft_payload_expr_esp_keyword_spi '\vspi' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_spi_operator_2char,
\    nft_payload_expr_esp_spi_keyword_in,
\    nft_payload_expr_esp_spi_operator_1char,
\    nft_payload_expr_esp_spi,
\    nft_payload_expr_named_set,
\    nft_chainError
" ************************* END  esp spi' *************************

hi link   nft_payload_expr_esp_hdr_expr_keyword_esp nftHL_Statement
syn match nft_payload_expr_esp_hdr_expr_keyword_esp '\vesp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_keyword_spi,
\    nft_chainError
" ************************* END  esp' *************************

" ************************* BEGIN  tcp' *************************
"  tcp: sport, dport, sequence, ackseq, doff, flags, window, checksum, urgptr
syn cluster nft_c_payload_expr_tcp_expressions
\ contains=
\    nft_payload_expr_tcp_keyword_sequence,
\    nft_payload_expr_tcp_keyword_ackseq,
\    nft_payload_expr_tcp_keyword_urgptr,
\    nft_payload_expr_tcp_keyword_window,
\    nft_payload_expr_tcp_keyword_dport,
\    nft_payload_expr_tcp_keyword_flags,
\    nft_payload_expr_tcp_keyword_sport,
\    nft_payload_expr_tcp_keyword_doff

hi link   nft_payload_expr_tcp_named_set nftHL_Set
syn match nft_payload_expr_tcp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_primary_expr_symbol_expr nftHL_Variable
syn match nft_payload_expr_primary_expr_symbol_expr '\v[\$\@][a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

" ************************* BEGIN tcp checksum' *************************
"  tcp checksum in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_checksum '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}n]' skipwhite contained

"  tcp checksum in {  }
hi link    nft_payload_expr_tcp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_checksum
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp checksum in
hi link   nft_payload_expr_tcp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_inline_set

"  tcp checksum
hi link   nft_payload_expr_tcp_checksum_num2 nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_checksum_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_checksum_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_checksum_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_checksum_dash_symbol

"  tcp checksum >
hi link   nft_payload_expr_tcp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum >=
hi link   nft_payload_expr_tcp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError

"  tcp checksum
hi link   nft_payload_expr_tcp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_checksum '\vchecksum\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_checksum_operator_2char,
\    nft_payload_expr_tcp_checksum_keyword_in,
\    nft_payload_expr_tcp_checksum_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_checksum_inline_set,
\    nft_payload_expr_tcp_checksum_num_or_range,
\    nft_chainError
" ************************* END  tcp checksum' *************************

" ************************* BEGIN  tcp sequence' *************************
"  tcp sequence in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_sequence nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_sequence '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp sequence in {  }
hi link    nft_payload_expr_tcp_sequence_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_sequence_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_sequence
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp sequence in
hi link   nft_payload_expr_tcp_sequence_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_sequence_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_inline_set

hi link   nft_payload_expr_tcp_sequence_num2 nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_sequence_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_sequence_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_sequence_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_sequence_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp sequence >
hi link   nft_payload_expr_tcp_sequence_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_1char '\v([\>\<\!])'  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence >=
hi link   nft_payload_expr_tcp_sequence_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_sequence_operator_2char '\v([\>\<\!])\='  skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError

"  tcp sequence
hi link   nft_payload_expr_tcp_keyword_sequence nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_sequence '\vsequence\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sequence_operator_2char,
\    nft_payload_expr_tcp_sequence_keyword_in,
\    nft_payload_expr_tcp_sequence_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_sequence_inline_set,
\    nft_payload_expr_tcp_sequence_num_or_range,
\    nft_chainError
" ************************* END  tcp sequence' *************************

" ************************* BEGIN  tcp ackseq' *************************
"  tcp ackseq in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_ackseq nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_ackseq '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  tcp ackseq in {  }
hi link    nft_payload_expr_tcp_ackseq_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_ackseq_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_ackseq
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp ackseq in
hi link   nft_payload_expr_tcp_ackseq_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_ackseq_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_inline_set

hi link   nft_payload_expr_tcp_ackseq_num2 nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_ackseq_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_ackseq_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_ackseq_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_ackseq_dash_symbol

"  tcp ackseq >
hi link   nft_payload_expr_tcp_ackseq_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq >=
hi link   nft_payload_expr_tcp_ackseq_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_ackseq_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError

"  tcp ackseq
hi link   nft_payload_expr_tcp_keyword_ackseq nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_ackseq '\vackseq\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_ackseq_operator_2char,
\    nft_payload_expr_tcp_ackseq_keyword_in,
\    nft_payload_expr_tcp_ackseq_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_ackseq_inline_set,
\    nft_payload_expr_tcp_ackseq_num_or_range,
\    nft_chainError
" ************************* END  tcp ackseq' *************************

" ************************* BEGIN  tcp urgptr' *************************
"  tcp urgptr in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_urgptr nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_urgptr '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp urgptr in {  }
hi link    nft_payload_expr_tcp_urgptr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_urgptr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_urgptr
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp urgptr in
hi link   nft_payload_expr_tcp_urgptr_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_urgptr_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_inline_set

hi link   nft_payload_expr_tcp_urgptr_num2 nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_urgptr_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num2,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_urgptr_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_urgptr_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_urgptr_dash_symbol

"  tcp urgptr >
hi link   nft_payload_expr_tcp_urgptr_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr >=
hi link   nft_payload_expr_tcp_urgptr_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_urgptr_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError

"  tcp urgptr
hi link   nft_payload_expr_tcp_keyword_urgptr nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_urgptr '\vurgptr\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_urgptr_operator_2char,
\    nft_payload_expr_tcp_urgptr_keyword_in,
\    nft_payload_expr_tcp_urgptr_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_urgptr_inline_set,
\    nft_payload_expr_tcp_urgptr_num_or_range,
\    nft_chainError
" ************************* END  tcp urgptr' *************************

" ************************* BEGIN  tcp window' *************************
"  tcp window in { 1,127,255 }
hi link   nft_payload_expr_tcp_window_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_window_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp window in {  }
hi link    nft_payload_expr_tcp_window_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_window_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_window_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp window in
hi link   nft_payload_expr_tcp_window_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_window_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_inline_set

hi link   nft_payload_expr_tcp_window_num2 nftHL_Integer
syn match nft_payload_expr_tcp_window_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_window_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_window_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_window_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_window_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

"  tcp window >
hi link   nft_payload_expr_tcp_window_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window >=
hi link   nft_payload_expr_tcp_window_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_window_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError

"  tcp window
hi link   nft_payload_expr_tcp_keyword_window nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_window '\vwindow\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_window_operator_2char,
\    nft_payload_expr_tcp_window_keyword_in,
\    nft_payload_expr_tcp_window_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_window_inline_set,
\    nft_payload_expr_tcp_window_num_or_range,
\    nft_chainError
" ************************* END  tcp window' *************************

" ************************* BEGIN  tcp dport' *************************
"  tcp dport in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_dport nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_dport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp dport in {  }
hi link    nft_payload_expr_tcp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_dport
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp dport in
hi link   nft_payload_expr_tcp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_inline_set

hi link   nft_payload_expr_tcp_dport_num2 nftHL_Integer
syn match nft_payload_expr_tcp_dport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_dport_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_dport_enums nftHL_Define
syn match nft_payload_expr_tcp_dport_enums '\v(clc\-build\-daemon|kerberos\-master|afs3\-fileserver|zabbix\-trapper|passwd\-server|ms\-wbt\-server|gsigatekeeper|f5\-globalsite|dhcpv6\-server|dhcpv6\-client|afs3\-vlserver|afs3\-prserver|afs3\-kaserver|afs3\-callback|zabbix\-agent|moira\-update|microsoft\-ds|kerberos\-adm|iscsi\-target|gnutella\-svc|gnutella\-rtr|font\-service|xmpp\-server|xmpp\-client|submissions|sge\-qmaster|sa\-msg\-port|rpc2portmap|rmiregistry|radmin\-port|radius\-acct|ptp\-general|netbios\-ssn|netbios\-dgm|mysql\-proxy|ipsec\-nat\-t|datametrics|afs3\-volser|afs3\-update|afs3\-rmtsys|zephyr\-srv|zephyr\-clt|syslog\-tls|supfilesrv|supfiledbg|submission|rtcm\-sc104|postgresql|netbios\-ns|moira\-ureg|ingreslock|cvspserver|codasrv\-se|cmip\-agent|cisco\-sccp|bacula\-dir|afpovertcp|zephyr\-hm|snmp\-trap|sge\-execd|sane\-port|ptp\-event|lotusnote|kerberos4|groupwise|ftps\-data|f5\-iquery|dircproxy|codaauth2|clearcase|bacula\-sd|bacula\-fd|amidxtape|amandaidx|zope\-ftp|zebrasrv|venus\-se|sgi\-crsd|sgi\-cmsd|poppassd|ms\-sql\-s|ms\-sql\-m|moira\-db|krb\-prop|kerberos|iso\-tsap|http\-alt|ftp\-data|domain\-s|cmip\-man|cfengine|asf\-rmcp|afs3\-bos|acr\-nema|telnets|skkserv|sip\-tls|sgi\-gcd|sgi\-cad|printer|predict|pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|syslog|svrloc|sunrpc|rmtcfg|ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs\-u|gsiftp|gopher|gnunet|gds\-db|gdomap|finger|domain|distcc|db\-lsp|csync2|bootps|bootpc|amanda|zserv|zebra|z3950|xtelw|xmms2|xdmcp|x11\-7|x11\-6|x11\-5|x11\-4|x11\-3|x11\-2|x11\-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s|ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel|wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|rtmp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns|ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|biff|bgpd|auth|amqp|zip|x11|who|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f|ipx|ipp|iax|hkp|git|ftp|fsp|fax|bgp|bbs|asp)' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_dport_dash_symbol

"   tcp dport
hi link   nft_payload_expr_tcp_dport_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_dport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained

"  tcp dport >
hi link   nft_payload_expr_tcp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

"  tcp dport >=
hi link   nft_payload_expr_tcp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError

" tcp dport map ...
hi link   nft_stmt_expr_map_stmt_expr_keyword_map nftHL_Keyword
syn match nft_stmt_expr_map_stmt_expr_keyword_map '\vmap' skipwhite contained
\ nextgroup=
\    @nft_c_map_expr_rhs_expr

"  tcp dport
hi link   nft_payload_expr_tcp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_dport_enums,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_payload_expr_tcp_dport_operator_2char,
\    nft_payload_expr_tcp_dport_keyword_in,
\    nft_payload_expr_tcp_dport_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_primary_expr_symbol_expr,
\    nft_payload_expr_tcp_dport_inline_set,
\    nft_payload_expr_tcp_dport_num_or_range,
\    nft_chainError
" ************************* END  tcp dport' *************************

" ************************* BEGIN  tcp flags' *************************
" flags: syn, ack, fin, rst, psh, urg, ecn, cwr or 0 to 0xFF.
"  tcp flags in { 1,127,255 }
hi link   nft_payload_expr_tcp_flags_inline_set_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_inline_set_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t,\}\n]'  skipwhite contained

hi link   nft_payload_expr_tcp_flags_inline_set_num nftHL_Integer
syn match nft_payload_expr_tcp_flags_inline_set_num '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t,\}\n]' skipwhite contained

"  tcp flags in {  }
hi link    nft_payload_expr_tcp_flags_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_flags_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_flags_inline_set_defines,
\    nft_payload_expr_tcp_flags_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp flags in
hi link   nft_payload_expr_tcp_flags_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_flags_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_inline_set

hi link   nft_payload_expr_tcp_flags_num2 nftHL_Integer
syn match nft_payload_expr_tcp_flags_num2 '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_flags_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_flags_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_num2,
\    nft_chainError

hi link   nft_payload_expr_tcp_flags_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_flags_num_or_range '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t\-]'  skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sequence_dash_symbol

hi link   nft_payload_expr_tcp_flags_defines nftHL_Define
syn match nft_payload_expr_tcp_flags_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t]'  contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp flags >
hi link   nft_payload_expr_tcp_flags_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

"  tcp flags >=
hi link   nft_payload_expr_tcp_flags_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_flags_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError

hi link   nft_payload_expr_tcp_keyword_flags nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_flags_defines,
\    nft_payload_expr_tcp_flags_operator_2char,
\    nft_payload_expr_tcp_flags_keyword_in,
\    nft_payload_expr_tcp_flags_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_flags_inline_set,
\    nft_payload_expr_tcp_flags_num_or_range,
\    nft_chainError
" ************************* END tcp flags' *************************

" ************************* BEGIN tcp sport' *************************
"  tcp sport in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_sport '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp sport in {  }
hi link    nft_payload_expr_tcp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_sport
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp sport in
hi link   nft_payload_expr_tcp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_inline_set

hi link   nft_payload_expr_tcp_sport_num2 nftHL_Integer
syn match nft_payload_expr_tcp_sport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_sport_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num2,
\    nft_chainError

"   tcp sport
hi link   nft_payload_expr_tcp_sport_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_sport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_sport_dash_symbol

"  tcp sport >
hi link   nft_payload_expr_tcp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError

"  tcp sport >=
hi link   nft_payload_expr_tcp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError

"  tcp sport
hi link   nft_payload_expr_tcp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_sport_operator_2char,
\    nft_payload_expr_tcp_sport_keyword_in,
\    nft_payload_expr_tcp_sport_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_sport_inline_set,
\    nft_payload_expr_tcp_sport_num_or_range,
\    nft_chainError
" ************************* END tcp sport' *************************

" ************************* BEGIN  tcp doff' *************************
"  tcp doff in { 1,127,255 }
hi link   nft_payload_expr_tcp_inline_set_doff nftHL_Integer
syn match nft_payload_expr_tcp_inline_set_doff '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  tcp doff in {  }
hi link    nft_payload_expr_tcp_doff_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_doff_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_tcp_inline_set_doff
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

"  tcp doff in
hi link   nft_payload_expr_tcp_doff_keyword_in nftHL_Keyword
syn match nft_payload_expr_tcp_doff_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_inline_set

hi link   nft_payload_expr_tcp_doff_num2 nftHL_Integer
syn match nft_payload_expr_tcp_doff_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions

hi link   nft_payload_expr_tcp_doff_dash_symbol nftHL_Expression
syn match nft_payload_expr_tcp_doff_dash_symbol '\v\-\ze[0-9]' contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num2,
\    nft_chainError

"   tcp doff
hi link   nft_payload_expr_tcp_doff_num_or_range nftHL_Integer
syn match nft_payload_expr_tcp_doff_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_tcp_expressions,
\    nft_payload_expr_tcp_doff_dash_symbol

"  tcp doff >
hi link   nft_payload_expr_tcp_doff_operator_1char nftHL_Expression
syn match nft_payload_expr_tcp_doff_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError

"  tcp doff >=
hi link   nft_payload_expr_tcp_doff_operator_2char nftHL_Expression
syn match nft_payload_expr_tcp_doff_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError

"  tcp doff
hi link   nft_payload_expr_tcp_keyword_doff nftHL_Keyword
syn match nft_payload_expr_tcp_keyword_doff '\vdoff\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_doff_operator_2char,
\    nft_payload_expr_tcp_doff_keyword_in,
\    nft_payload_expr_tcp_doff_operator_1char,
\    nft_payload_expr_tcp_named_set,
\    nft_payload_expr_tcp_doff_inline_set,
\    nft_payload_expr_tcp_doff_num_or_range,
\    nft_chainError
" *************** End of payload_expr tcp_hdr_expr 'tcp doff' *************************

hi link   nft_payload_expr_tcp_hdr_expr_keyword_tcp nftHL_Statement
syn match nft_payload_expr_tcp_hdr_expr_keyword_tcp '\v[ \t]\zstcp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_keyword_checksum,
\    nft_payload_expr_tcp_keyword_sequence,
\    nft_payload_expr_tcp_keyword_ackseq,
\    nft_payload_expr_tcp_keyword_urgptr,
\    nft_payload_expr_tcp_keyword_window,
\    nft_payload_expr_tcp_keyword_dport,
\    nft_payload_expr_tcp_keyword_flags,
\    nft_payload_expr_tcp_keyword_sport,
\    nft_payload_expr_tcp_keyword_doff,
\    nft_chainError
" *************** End of payload_expr tcp_hdr_expr 'tcp' *************************

" ************************* BEGIN  udp' *************************
"  udp: sport, dport, length, checksum
syn cluster nft_c_payload_expr_udp_expressions
\ contains=
\    nft_payload_expr_udp_keyword_checksum,
\    nft_payload_expr_udp_keyword_length,
\    nft_payload_expr_udp_keyword_dport,
\    nft_payload_expr_udp_keyword_sport

hi link   nft_payload_expr_udp_named_set nftHL_Set
syn match nft_payload_expr_udp_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

" ************************* BEGIN  udp checksum' *************************
"  udp checksum in { 1,127,255 }
hi link   nft_payload_expr_udp_checksum_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_checksum_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp checksum in {  }
hi link    nft_payload_expr_udp_checksum_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_checksum_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_checksum_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp checksum in
hi link   nft_payload_expr_udp_checksum_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_checksum_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_inline_set

hi link   nft_payload_expr_udp_checksum_num2 nftHL_Integer
syn match nft_payload_expr_udp_checksum_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_checksum_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num2,
\    nft_chainError

hi link   nft_payload_expr_udp_checksum_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_checksum_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_udp_checksum_dash_symbol

"  udp checksum >
hi link   nft_payload_expr_udp_checksum_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_checksum_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_chainError

"  udp checksum >=
hi link   nft_payload_expr_udp_checksum_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_checksum_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_chainError

"  udp checksum
hi link   nft_payload_expr_udp_keyword_checksum nftHL_Keyword
syn match nft_payload_expr_udp_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_checksum_operator_2char,
\    nft_payload_expr_udp_checksum_keyword_in,
\    nft_payload_expr_udp_checksum_operator_1char,
\    nft_payload_expr_udp_checksum_inline_set,
\    nft_payload_expr_udp_checksum_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp checksum' *************************

" ************************* BEGIN  udp length' *************************
"  udp length in { 1,127,255 }
hi link   nft_payload_expr_udp_length_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_length_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp length in {  }
hi link    nft_payload_expr_udp_length_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_length_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_length_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp length in
hi link   nft_payload_expr_udp_length_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_length_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_inline_set

"  udp length
hi link   nft_payload_expr_udp_length_num2 nftHL_Integer
syn match nft_payload_expr_udp_length_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_length_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_length_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num2,
\    nft_chainError

hi link   nft_payload_expr_udp_length_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_length_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_udp_length_dash_symbol

"  udp length >
hi link   nft_payload_expr_udp_length_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_length_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num_or_range,
\    nft_chainError

"  udp length >=
hi link   nft_payload_expr_udp_length_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_length_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_num_or_range,
\    nft_chainError

"  udp length
hi link   nft_payload_expr_udp_keyword_length nftHL_Keyword
syn match nft_payload_expr_udp_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_length_operator_2char,
\    nft_payload_expr_udp_length_keyword_in,
\    nft_payload_expr_udp_length_operator_1char,
\    nft_payload_expr_udp_length_inline_set,
\    nft_payload_expr_udp_length_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp length' *************************

" ************************* BEGIN  udp dport' *************************
"  udp dport in { 1,127,255 }
hi link   nft_payload_expr_udp_dport_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_dport_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp dport in {  }
hi link    nft_payload_expr_udp_dport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_dport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_dport_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp dport in
hi link   nft_payload_expr_udp_dport_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_dport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_inline_set

hi link   nft_payload_expr_udp_dport_num2 nftHL_Integer
syn match nft_payload_expr_udp_dport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_dport_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num2,
\    nft_chainError

"   udp dport
hi link   nft_payload_expr_udp_dport_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_dport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_tcp_dport_dash_symbol

"  udp dport >
hi link   nft_payload_expr_udp_dport_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_dport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_chainError

"  udp dport >=
hi link   nft_payload_expr_udp_dport_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_dport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_chainError

"  udp dport
hi link   nft_payload_expr_udp_keyword_dport nftHL_Keyword
syn match nft_payload_expr_udp_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_dport_operator_2char,
\    nft_payload_expr_udp_dport_keyword_in,
\    nft_payload_expr_udp_dport_operator_1char,
\    nft_payload_expr_udp_dport_inline_set,
\    nft_payload_expr_udp_dport_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END udp dport' *************************

" ************************* BEGIN udp sport' *************************
"  udp sport in { 1,127,255 }
hi link   nft_payload_expr_udp_sport_inline_set_num nftHL_Integer
syn match nft_payload_expr_udp_sport_inline_set_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t,\}\n]' skipwhite contained

"  udp sport in {  }
hi link    nft_payload_expr_udp_sport_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_sport_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_udp_sport_inline_set_num
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

"  udp sport in
hi link   nft_payload_expr_udp_sport_keyword_in nftHL_Keyword
syn match nft_payload_expr_udp_sport_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_inline_set

hi link   nft_payload_expr_udp_sport_num2 nftHL_Integer
syn match nft_payload_expr_udp_sport_num2 '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions

hi link   nft_payload_expr_udp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_udp_sport_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num2,
\    nft_chainError

"   udp sport
hi link   nft_payload_expr_udp_sport_num_or_range nftHL_Integer
syn match nft_payload_expr_udp_sport_num_or_range '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    @nft_c_payload_expr_udp_expressions,
\    nft_payload_expr_tcp_sport_dash_symbol

"  udp sport >
hi link   nft_payload_expr_udp_sport_operator_1char nftHL_Expression
syn match nft_payload_expr_udp_sport_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_chainError

"  udp sport >=
hi link   nft_payload_expr_udp_sport_operator_2char nftHL_Expression
syn match nft_payload_expr_udp_sport_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_chainError

"  udp sport
hi link   nft_payload_expr_udp_keyword_sport nftHL_Keyword
syn match nft_payload_expr_udp_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_sport_operator_2char,
\    nft_payload_expr_udp_sport_keyword_in,
\    nft_payload_expr_udp_sport_operator_1char,
\    nft_payload_expr_udp_sport_inline_set,
\    nft_payload_expr_udp_sport_num_or_range,
\    nft_payload_expr_udp_named_set,
\    nft_chainError
" ************************* END  udp sport' *************************

hi link   nft_payload_expr_udp_hdr_expr_keyword_udp nftHL_Statement
syn match nft_payload_expr_udp_hdr_expr_keyword_udp '\v[ \t]\zsudp' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_keyword_checksum,
\    nft_payload_expr_udp_keyword_length,
\    nft_payload_expr_udp_keyword_dport,
\    nft_payload_expr_udp_keyword_sport,
\    nft_chainError
" ************************* END  udp' *************************

" ************************* BEGIN  ah' *************************
"  ah: spi, sequence
hi link   nft_payload_expr_ah_hdr_expr_keyword_ah nftHL_Statement
syn match nft_payload_expr_ah_hdr_expr_keyword_ah '\vah\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_esp_keyword_sequence,
\    nft_payload_expr_esp_keyword_spi,
\    nft_chainError
" ************************* END  ah' *************************

" ************************* BEGIN ip6 nexthdr' *************************
" WOW, duplicate this, rename w/o 'nexthdr',
" make it point to new one,
" then stick all of the originals back into the chain_block
" It is not a payload_stmt (has a required 'set' keyword)

" ip6 protocol: tcp, udp, icmpv6, sctp, dccp, esp, ah, hop-by-hop, dest, routing, fragment, no-next.
" Explicit form
" nexthdr = Protocol selector
" following identical keyword is begin of protocol expression"

" 'ip6 nexthdr 47'
hi link   nft_payload_expr_ip6_nexthdr_num nftHL_Integer
syn match nft_payload_expr_ip6_nexthdr_num '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,5}))' skipwhite contained

" 'ip6 nexthdr <option-less-header>'
hi link   nft_payload_raw_expr_payload_base_spec_optionless_keywords nftHL_Keyword
syn match nft_payload_raw_expr_payload_base_spec_optionless_keywords '\v(no\-next|icmpv6|dccp|sctp|esp|tcp|udp|ah)' skipwhite contained

" 'ip6 nexthdr' and their follow-on options
hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr '\vnexthdr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_nexthdr_keyword_hop_by_hop,
\    nft_payload_expr_ip6_nexthdr_keyword_fragment,
\    nft_payload_raw_expr_payload_base_spec_optionless_keywords,
\    nft_payload_expr_ip6_nexthdr_keyword_no_next,
\    nft_payload_expr_ip6_nexthdr_keyword_routing,
\    nft_payload_expr_ip6_nexthdr_keyword_dest,
\    nft_payload_expr_ip6_nexthdr_keyword_tcp,
\    nft_payload_expr_ip6_nexthdr_keyword_udp,
\    nft_payload_expr_ip6_nexthdr_keyword_ah,
\    nft_payload_expr_ip6_nexthdr_num,
\    nft_chainError
" ************************* END ip6 nexthdr' *************************

" ************************* BEGIN ip6 version' *************************
" formerly nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_version
hi link   nft_payload_expr_ip6_version nftHL_Integer
syn match nft_payload_expr_ip6_version '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_version nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_version '\vversion\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_version,
\    nft_Error
" ************************* END ip6 version' *************************

" ************************* BEGIN ip6 length' *************************
hi link   nft_payload_expr_ip6_length nftHL_Integer
syn match nft_payload_expr_ip6_length '\v((0x[0-9a-fA-F]{1,1})|([0-9]{1,1}))\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_length nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_length,
\    nft_Error
" ************************* END ip6 length' *************************

" ************************* BEGIN ip6 daddr' *************************
hi link   nft_payload_expr_ip6_daddr nftHL_Integer
syn match nft_payload_expr_ip6_daddr '\v([0-9a-fA-F]{1,4}::{0,7}){1,7}[0-9a-fA-F]{1,4}' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_daddr nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_daddr,
\    nft_stmt_expr_map_stmt_expr_keyword_map,
\    nft_Error
" ************************* END ip6 daddr' *************************

" ************************* BEGIN ip6 saddr' *************************
hi link   nft_payload_expr_ip6_saddr nftHL_Integer
syn match nft_payload_expr_ip6_saddr '\v([0-9a-fA-F]{1,4}::{0,7}){1,7}[0-9a-fA-F]{1,4}' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_saddr nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_close_scope_ip_primary_expr_constant_expr_setname,
\    nft_payload_expr_ip6_saddr,
\    nft_Error
" ************************* END ip6 saddr' *************************

" ************************* BEGIN ip6 dscp' *************************
hi link   nft_payload_expr_ip6_dscp nftHL_Integer
syn match nft_payload_expr_ip6_dscp '\v((0x[0-9a-fA-F]{1,2})|([0-9]{1,3}))\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_dscp nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_dscp '\vdscp\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_dscp,
\    nft_Error
" ************************* END ip6 dscp' *************************

" ************************* Begin ip6_hdr_expr 'ip6 ecn' *************************
hi link   nft_payload_expr_ip6_ecn nftHL_Integer
syn match nft_payload_expr_ip6_ecn '\v((0x[0-9a-fA-F]{1,4})|([0-9]{1,10}))\ze[ \t;$]' skipwhite contained

hi link   nft_payload_expr_ip6_keyword_ecn nftHL_Keyword
syn match nft_payload_expr_ip6_keyword_ecn '\vecn\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_ip6_ecn,
\    nft_Error
" ************************* End ip6_hdr_expr 'ip6 ecn' *************************

"*************** BEGIN th_hdr_expr *******************************
hi link   nft_th_hdr_expr_th_hdr_field_keyword_dport nftHL_Keyword
syn match nft_th_hdr_expr_th_hdr_field_keyword_dport '\vdport' skipwhite contained

hi link   nft_th_hdr_expr_th_hdr_field_keyword_sport nftHL_Keyword
syn match nft_th_hdr_expr_th_hdr_field_keyword_sport '\vsport' skipwhite contained

hi link   nft_payload_expr_th_hdr_expr_keyword_th nftHL_Expression
syn match nft_payload_expr_th_hdr_expr_keyword_th '\vth' skipwhite contained
\ nextgroup=
\    nft_th_hdr_expr_th_hdr_field_keyword_dport,
\    nft_th_hdr_expr_th_hdr_field_keyword_sport
"*************** BEGIN th_hdr_expr *******************************

"*************** BEGIN payload_expr *******************************
hi link   nft_c_payload_expr nftHL_Expression
syn cluster nft_c_payload_expr
\ contains=
\    nft_payload_expr_udplite_hdr_expr_keyword_udplite,
\    nft_payload_expr_geneve_hdr_expr_keyword_geneve,
\    nft_payload_expr_gretap_hdr_expr_keyword_gretap,
\    nft_payload_expr_icmpv6_hdr_expr_keyword_icmpv6,
\    nft_payload_expr_ether_hdr_expr_keyword_ether,
\    nft_payload_expr_vxlan_hdr_expr_keyword_vxlan,
\    nft_payload_expr_auth_hdr_expr_keyword_auth,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_payload_expr_comp_hdr_expr_keyword_comp,
\    nft_payload_expr_icmp_hdr_expr_keyword_icmp,
\    nft_payload_expr_igmp_hdr_expr_keyword_igmp,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_payload_expr_vlan_hdr_expr_keyword_vlan,
\    nft_payload_expr_arp_hdr_expr_keyword_arp,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_payload_expr_gre_hdr_expr_keyword_gre,
\    nft_payload_expr_ip6_hdr_expr_keyword_ip6,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ip_hdr_expr_keyword_ip,
\    nft_payload_expr_th_hdr_expr_keyword_th
"*************** END payload_expr *******************************

hi link   nft_primary_stmt_expr_payload_expr_keyword_ip6 nftHL_Statement
syn match nft_primary_stmt_expr_payload_expr_keyword_ip6 '\vip6\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_flowlabel,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_hoplimit,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_nexthdr,
\    nft_payload_expr_ip6_keyword_version,
\    nft_payload_expr_ip6_keyword_length,
\    nft_payload_expr_ip6_keyword_daddr,
\    nft_payload_expr_ip6_keyword_saddr,
\    nft_payload_expr_ip6_keyword_dscp,
\    nft_payload_expr_ip6_keyword_ecn,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_ttl,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip6_hdr_expr_ip6_hdr_field_keyword_id,
\    nft_chainError
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_stmt_expr_payload_expr_ip_hdr_expr_named_set,
" ************************* END ip6_hdr_expr' *************************

hi link   nft_payload_expr_ip_protocol_keyword_dccp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_dccp '\vdccp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_icmp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_icmp '\vicmp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_igmp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_igmp '\vigmp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ipip nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ipip '\vipip' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ipv6 nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ipv6 '\vipv6' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_sctp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_sctp '\vsctp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_esp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_esp '\vesp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_gre nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_gre '\vgre' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_tcp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_tcp '\vtcp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_udp nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_udp '\vudp' skipwhite contained
hi link   nft_payload_expr_ip_protocol_keyword_ah nftHL_Keyword
syn match nft_payload_expr_ip_protocol_keyword_ah '\vah' skipwhite contained

hi link   nft_payload_expr_ip_protocol nftHL_Keyword
syn match nft_payload_expr_ip_protocol '\v(dccp|icmp|igmp|ipip|ipv6|sctp|esp|gre|tcp|udp|ah)' skipwhite contained
" ************************* END payload_expr' *************************

" ************************* BEGIN fib' expression *************************
" fib (Forward Information Base) is about routing decision.
hi link   nft_primary_expr_fib_named_set nftHL_Set
syn match nft_primary_expr_fib_named_set '\v\@[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib
" fib expression can only handle one field per 'fib'
" no expressions cluster needed if sharing the same 'fib' expression as multiple fibs on same line

" ************************* BEGIN fib oifname' expression *************************
" oifname	Output interface name (string).
"  'fib [key] oifname in { 1,127,255 }'
" no wildcard device name (asterisk) support within inline set; just regular device name
hi link   nft_primary_expr_fib_oifname_inline_set_interface nftHL_Device
syn match nft_primary_expr_fib_oifname_inline_set_interface '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t,\}\n]' skipwhite contained

"  'fib [key] oifname in { }'
hi link    nft_primary_expr_fib_oifname_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_oifname_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_oifname_inline_set_interface,
\    nft_Error
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"   fib [key] oifname 'br*'
hi link   nft_primary_expr_fib_oifname_device_interface_wildcard nftHL_String
syn match nft_primary_expr_fib_oifname_device_interface_wildcard '\v\"[a-zA-Z][a-zA-Z0-9\-_\*]{0,63}\"\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"   'fib [key] oifname eth0'
hi link   nft_primary_expr_fib_oifname_device_interface_name nftHL_Device
syn match nft_primary_expr_fib_oifname_device_interface_name '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib [key] oifname in'
hi link   nft_primary_expr_fib_oifname_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_oifname_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_inline_set

"  fib [key] oifname >
hi link   nft_primary_expr_fib_oifname_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_oifname_operator_1char '\v\!' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError

"  fib [key] oifname >=
hi link   nft_primary_expr_fib_oifname_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_oifname_operator_2char '\v[\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError

"  'fib [key] oifname not in'
hi link   nft_primary_expr_fib_oifname_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_oifname_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_in

"  fib [key] oifname
hi link   nft_primary_expr_fib_oifname_keyword_oifname nftHL_Keyword
syn match nft_primary_expr_fib_oifname_keyword_oifname '\voifname\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_not,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_oifname_operator_2char,
\    nft_primary_expr_fib_oifname_keyword_in,
\    nft_primary_expr_fib_oifname_operator_1char,
\    nft_primary_expr_fib_oifname_inline_set,
\    nft_primary_expr_fib_oifname_device_interface_wildcard,
\    nft_primary_expr_fib_oifname_device_interface_name,
\    nft_chainError
" ************************* END fib oifname' expression *************************

" ************************* BEGIN fib daddr' expression *************************
"  fib daddr
hi link   nft_primary_expr_fib_keyword_daddr nftHL_Keyword
syn match nft_primary_expr_fib_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib daddr' expression *************************

" ************************* BEGIN fib flags' expression *************************
" flags	Route flags (dynamic, dead, onlink, etc. — bitmask from kernel fib flags).
hi link   nft_primary_expr_fib_flags_inline_set_defines nftHL_Define
syn match nft_primary_expr_fib_flags_inline_set_defines '\v(unreachable|blackhole|broadcast|multicast|prohibit|anycast|offload|unicast|unspec|local|dead|dyn)\ze[ ,\t\n\}]' skipwhite contained

"  fib [key] flags in {  }
hi link    nft_primary_expr_fib_flags_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_flags_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_flags_inline_set_defines
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"  fib [key] flags in
hi link   nft_primary_expr_fib_flags_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_flags_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_inline_set

hi link   nft_primary_expr_fib_flags_defines nftHL_Define
syn match nft_primary_expr_fib_flags_defines '\v(unreachable|blackhole|broadcast|multicast|prohibit|anycast|offload|unicast|unspec|local|dead|dyn)\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib [key] flags !'
hi link   nft_primary_expr_fib_flags_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_flags_operator_1char '\v\!' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError

"  fib [key] flags >=
hi link   nft_primary_expr_fib_flags_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_flags_operator_2char '\v[\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError

hi link   nft_primary_expr_fib_flags_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_flags_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_keyword_in,

"  fib [key] flags
hi link   nft_primary_expr_fib_flags_keyword_flags nftHL_Keyword
syn match nft_primary_expr_fib_flags_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_keyword_not,
\    nft_primary_expr_fib_flags_operator_2char,
\    nft_primary_expr_fib_flags_keyword_in,
\    nft_primary_expr_fib_flags_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_flags_inline_set,
\    nft_primary_expr_fib_flags_defines,
\    nft_chainError
" ************************* END fib flags' expression *************************

" ************************* BEGIN fib saddr' expression *************************
"  tcp doff
hi link   nft_primary_expr_fib_keyword_saddr nftHL_Keyword
syn match nft_primary_expr_fib_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib saddr' expression *************************

" ************************* BEGIN fib [key] scope' expression *************************
" scope	Route scope (host, link, site, universe).
hi link   nft_primary_expr_fib_scope_inline_set_defines nftHL_Define
syn match nft_primary_expr_fib_scope_inline_set_defines '\v(universe|nowhere|global|host|link|site)\ze[ ,\t\n\}]' skipwhite contained

hi link   nft_primary_expr_fib_scope_inline_set_num nftHL_Define
syn match nft_primary_expr_fib_scope_inline_set_num '\v[0-9]{1,3}\ze[ ,\t\n\}]' skipwhite contained

"  fib scope in {  }
hi link    nft_primary_expr_fib_scope_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_scope_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_scope_inline_set_defines,
\    nft_primary_expr_fib_scope_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

"  fib scope in
hi link   nft_primary_expr_fib_scope_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_scope_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_inline_set

hi link   nft_primary_expr_fib_scope_defines nftHL_Define
syn match nft_primary_expr_fib_scope_defines '\v(universe|nowhere|global|host|link|site)\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

hi link   nft_primary_expr_fib_scope_num nftHL_Integer
syn match nft_primary_expr_fib_scope_num '\v[0-9]{1,3}\ze[ ,\t\n\}]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  'fib scope !'
hi link   nft_primary_expr_fib_scope_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_scope_operator_1char '\v[\!\>\<]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError

"  tcp doff >=
hi link   nft_primary_expr_fib_scope_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_scope_operator_2char '\v[\>\<\!\=]\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError

hi link   nft_primary_expr_fib_scope_keyword_not nftHL_Operator
syn match nft_primary_expr_fib_scope_keyword_not '\vnot' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_keyword_in,

"  fib [key] scope
hi link   nft_primary_expr_fib_scope_keyword_scope nftHL_Keyword
syn match nft_primary_expr_fib_scope_keyword_scope '\vscope\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_scope_defines,
\    nft_primary_expr_fib_scope_keyword_not,
\    nft_primary_expr_fib_scope_operator_2char,
\    nft_primary_expr_fib_scope_keyword_in,
\    nft_primary_expr_fib_scope_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_scope_inline_set,
\    nft_primary_expr_fib_scope_num,
\    nft_chainError
" ************************* END fib scope' expression *************************

" ************************* BEGIN fib mark' expression *************************
" mark	Routing mark lookup (uses fwmark, useful with policy routing).
"  fib mark in { 0x80000001  }
hi link   nft_primary_expr_fib_mark_inline_set_num nftHL_Integer
syn match nft_primary_expr_fib_mark_inline_set_num '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  fib mark in {  }
hi link    nft_primary_expr_fib_mark_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_mark_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_mark_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  fib mark in
hi link   nft_primary_expr_fib_mark_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_mark_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_inline_set

hi link   nft_primary_expr_fib_mark_num2 nftHL_Integer
syn match nft_primary_expr_fib_mark_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

hi link   nft_primary_expr_fib_mark_dash_symbol nftHL_Expression
syn match nft_primary_expr_fib_mark_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num2,
\    nft_chainError

hi link   nft_primary_expr_fib_mark_num_or_range nftHL_Integer
syn match nft_primary_expr_fib_mark_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_primary_expr_fib_mark_dash_symbol

"  fib mark >
hi link   nft_primary_expr_fib_mark_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_mark_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

"  fib mark >=
hi link   nft_primary_expr_fib_mark_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_mark_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

"  fib [key] mark
hi link   nft_primary_expr_fib_mark_keyword_mark nftHL_Keyword
syn match nft_primary_expr_fib_mark_keyword_mark '\vmark\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_mark_operator_2char,
\    nft_primary_expr_fib_mark_keyword_in,
\    nft_primary_expr_fib_mark_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_mark_inline_set,
\    nft_primary_expr_fib_mark_num_or_range,
\    nft_chainError

hi link   nft_primary_expr_fib_keyword_mark nftHL_Keyword
syn match nft_primary_expr_fib_keyword_mark '\vmark\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib mark' expression *************************

" ************************* BEGIN fib [key] type' expression *************************
"  fib [key] type
hi link   nft_primary_expr_fib_type_keyword_type nftHL_Keyword
syn match nft_primary_expr_fib_type_keyword_type '\vtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_flags_defines,
\    nft_primary_expr_fib_flags_keyword_not,
\    nft_primary_expr_fib_flags_operator_2char,
\    nft_primary_expr_fib_flags_keyword_in,
\    nft_primary_expr_fib_flags_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_flags_inline_set,
\    nft_primary_expr_fib_flags_num,
\    nft_chainError
" ************************* END fib [key] type' expression *************************

" ************************* BEGIN fib iif' expression *************************
" iif	Input interface index.
"  fib iif in { 0x80000001  }
hi link   nft_primary_expr_fib_iif_inline_set_num nftHL_Integer
syn match nft_primary_expr_fib_iif_inline_set_num '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t,\}\n]' skipwhite contained

"  fib iif in {  }
hi link    nft_primary_expr_fib_iif_inline_set nftHL_BlockDelimitersSet
syn region nft_primary_expr_fib_iif_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_primary_expr_fib_iif_inline_set_num
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,

"  fib iif in
hi link   nft_primary_expr_fib_iif_keyword_in nftHL_Keyword
syn match nft_primary_expr_fib_iif_keyword_in '\vin' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_inline_set

hi link   nft_primary_expr_fib_iif_num2 nftHL_Integer
syn match nft_primary_expr_fib_iif_num2 '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib

hi link   nft_primary_expr_fib_iif_dash_symbol nftHL_Expression
syn match nft_primary_expr_fib_iif_dash_symbol '\v\-\ze[0-9]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num2,
\    nft_chainError

hi link   nft_primary_expr_fib_iif_num_or_range nftHL_Integer
syn match nft_primary_expr_fib_iif_num_or_range '\v((0x[0-9a-fA-F]{1,8})|([0-9]{1,10}))\ze[ \t\-]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_primary_expr_fib_iif_dash_symbol

"  fib iif >
hi link   nft_primary_expr_fib_iif_operator_1char nftHL_Expression
syn match nft_primary_expr_fib_iif_operator_1char '\v([\>\<\!])' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif >=
hi link   nft_primary_expr_fib_iif_operator_2char nftHL_Expression
syn match nft_primary_expr_fib_iif_operator_2char '\v([\>\<\!])\=' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif
hi link   nft_primary_expr_fib_iif_keyword_iif nftHL_Keyword
syn match nft_primary_expr_fib_iif_keyword_iif '\viif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_operator_2char,
\    nft_primary_expr_fib_iif_keyword_in,
\    nft_primary_expr_fib_iif_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_iif_inline_set,
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

"  fib iif
hi link   nft_primary_expr_fib_keyword_iif nftHL_Keyword
syn match nft_primary_expr_fib_keyword_iif '\viif\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" ************************* END fib iif' expression *************************

" ************************* BEGIN fib oif' expression *************************
" oif	Output interface index.
"  fib iif
hi link   nft_primary_expr_fib_oif_keyword_oif nftHL_Keyword
syn match nft_primary_expr_fib_oif_keyword_oif '\voif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_iif_operator_2char,
\    nft_primary_expr_fib_iif_keyword_in,
\    nft_primary_expr_fib_iif_operator_1char,
\    nft_primary_expr_fib_named_set,
\    nft_primary_expr_fib_iif_inline_set,
\    nft_primary_expr_fib_iif_num_or_range,
\    nft_chainError

hi link   nft_primary_expr_fib_keyword_oif nftHL_Keyword
syn match nft_primary_expr_fib_keyword_oif '\voif\ze[ \t\>\<\!\=]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_oifname_keyword_oifname,
\    nft_primary_expr_fib_flags_keyword_flags,
\    nft_primary_expr_fib_scope_keyword_scope,
\    nft_primary_expr_fib_mark_keyword_mark,
\    nft_primary_expr_fib_type_keyword_type,
\    nft_primary_expr_fib_oif_keyword_oif,
\    nft_chainError
" **************** END fib oif' expression *************

hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib nftHL_Statement
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib '\vfib\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_primary_expr_fib_keyword_daddr,
\    nft_primary_expr_fib_keyword_saddr,
\    nft_primary_expr_fib_keyword_mark,
\    nft_primary_expr_fib_keyword_iif,
\    nft_primary_expr_fib_keyword_oif
" **************** END fib_expr **************************************

" **************** BEGIN verdict_map_expr ****************************
hi link    nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters nftHL_BlockDelimitersSet
syn region nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters start=+{+ end=+}+ keepend skipwhite contained

hi link   nft_verdict_stmt_verdict_map_stmt_keyword_vmap nftHL_Keyword
syn match nft_verdict_stmt_verdict_map_stmt_keyword_vmap '\vvmap' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_verdict_map_expr_delimiters
" **************** END verdict_map_expr ******************************

" **************** BEGIN primary_expr ********************************
syn cluster nft_c_primary_expr
\ contains=
\    nft_chain_block_primary_expr_numgen_expr_keyword_numgen
" **************** END primary_expr **********************************
"***************** END expr ****************************************************

"**************** BEGIN stmt_expr **********************************************
" stmt_expr - trying for a generic Vim syntax group (to reside ONLY within chain_block)
"   used by ct_stmt dup_stmt fwd_stmt masq_stmt_args meta_stmt nat_stmt
"           objref_stmt_counter objref_stmt_ct objref_stmt_limit
"           objref_stmt_quota objref_stmt_synproxy payload_stmt
"           redir_stmt_arg tproxy_stmt
"   points to map_stmt_expr, multion_stmt_expr, and symbol_stmt_expr
hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr nftHL_Variable
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_string nftHL_String
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_integer_expr_num nftHL_Integer
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_integer_expr_num '\v[0-9]{1,10}' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keywords nftHL_Define
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keywords '\v(missing|exists)' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_missing nftHL_Define
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_missing '\vmissing' skipwhite contained

hi link   nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists nftHL_Define
syn match nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists '\vexists' skipwhite contained

hi link   nft_symbol_stmt_expr_symbol_expr_variable_expr_variable nftHL_Variable
syn match nft_symbol_stmt_expr_symbol_expr_variable_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained

hi link   nft_symbol_stmt_expr_symbol_expr_quoted_string nftHL_String
syn region nft_symbol_stmt_expr_symbol_expr_quoted_string start='\"' end='\"' oneline skipwhite contained

syn cluster nft_c_symbol_stmt_expr
\ contains=
\    nft_symbol_stmt_expr_symbol_expr_variable_expr_variable,
\    nft_symbol_stmt_expr_symbol_expr_quoted_string

" stmt_expr; referenced by referenced by: ct_stmt dup_stmt fwd_stmt masq_stmt_args
"     meta_stmt nat_stmt objref_stmt_counter objref_stmt_ct objref_stmt_limit
"     objref_stmt_quota objref_stmt_synproxy payload_stmt redir_stmt_arg tproxy_stmt
syn cluster nft_c_stmt_expr
\ contains=
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_missing,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_boolean_expr_keyword_exists,
\    @nft_c_multion_stmt_expr,
\    @nft_c_symbol_stmt_expr,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_variable_expr,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_symbol_expr_string,
\    nft_stmt_expr_map_stmt_expr_concat_stmt_expr_basic_stmt_expr_exclusive_or_stmt_expr_and_stmt_expr_shift_stmt_expr_primary_stmt_expr_integer_expr_num,
\    nft_stmt_expr_map_stmt_expr_set_expr_set_ref_expr_set_symbol_ref_expr_keyword_at_identifier,
\    nft_stmt_expr_map_stmt_expr_set_expr,
\    nft_stmt_expr_map_stmt_expr_set_expr_set_ref_expr_set_symbol_ref_expr_variable
"***************** END stmt_expr *************************************

"***************** BEGIN 'map' rhs_expr ************************************
hi link   nft_map_expr_rhs_expr_concat_rhs_expr nftHL_Keyword
syn match nft_map_expr_rhs_expr_concat_rhs_expr 'x' skipwhite contained

hi link    nft_map_expr_rhs_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_map_expr_rhs_expr_set_expr start=+{+ end=+}+ skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOL,
\    nft_Error

hi link   nft_map_expr_rhs_expr_set_ref_symbol_expr nftHL_Keyword
syn match nft_map_expr_rhs_expr_set_ref_symbol_expr 'y' skipwhite contained

syn cluster nft_c_map_expr_rhs_expr
\ contains=
\    nft_map_expr_rhs_expr_concat_rhs_expr,
\    nft_map_expr_rhs_expr_set_expr,
\    nft_map_expr_rhs_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_expr_rhs_expr_primary_expr,
\    nft_map_expr_rhs_expr_range_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_rhs_expr_integer_expr,
"***************** END 'map' rhs_expr **************************************

" ************************* BEGIN stmt' *************************
" ************************* BEGIN log_stmt' *************************
hi link   nft_stmt_log_stmt_log_arg_num nftHL_Integer
syn match nft_stmt_log_stmt_log_arg_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,

hi link   nft_stmt_log_stmt_log_arg_keyword_queue_threshold nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_queue_threshold '\vqueue\-threshold\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_snaplen nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_snaplen '\vsnaplen\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid nftHL_String
syn match nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid '\v[ a-zA-Z0-9_\-:;~!@#\$%^&\*\(\)\+\|\}\{\?><`=\\\]\[\'\/\.,]{1,64}' skipwhite contained

syn region nft_stmt_log_stmt_log_arg_keyword_prefix_string start='\"' end='\"' skipwhite contained
\ contains=
\    nft_stmt_log_stmt_log_arg_keyword_prefix_string_valid
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,

hi link   nft_stmt_log_stmt_log_arg_keyword_prefix nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_prefix '\vprefix\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix_string,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_level_defines nftHL_Define
syn match nft_stmt_log_stmt_log_arg_keyword_level_defines '\v(notice|alert|debug|emerg|crit|info|warn|err)' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_stmt_log_stmt_log_arg_keyword_flags,

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_ether nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_ether '\vether' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid '\vskuid' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_all nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_all '\vall' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma nftHL_Element
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma /,/ skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence,
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options '\voptions' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence '\vsequence' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_symbol_comma,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp '\vtcp' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_sequence,
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_tcp_keyword_options,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options nftHL_Define
syn match nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options '\voptions' skipwhite contained

hi link   nft_stmt_log_stmt_log_arg_log_flags_keyword_ip nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_log_flags_keyword_ip '\vip' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_log_flag_ip_keyword_options,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_flags nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_ether,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_skuid,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_all,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_tcp,
\    nft_stmt_log_stmt_log_arg_log_flags_keyword_ip,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_group nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_group '\vgroup\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_num,
\    nft_Error

hi link   nft_stmt_log_stmt_log_arg_keyword_level nftHL_Keyword
syn match nft_stmt_log_stmt_log_arg_keyword_level '\vlevel\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_level_defines,
\    nft_Error

hi link   nft_stmt_log_stmt_log_stmt_alloc_keyword_log nftHL_Command
syn match nft_stmt_log_stmt_log_stmt_alloc_keyword_log '\vlog\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_stmt_log_stmt_log_arg_keyword_queue_threshold,
\    nft_stmt_log_stmt_log_arg_keyword_snaplen,
\    nft_stmt_log_stmt_log_arg_keyword_prefix,
\    nft_stmt_log_stmt_log_arg_keyword_flags,
\    nft_stmt_log_stmt_log_arg_keyword_group,
\    nft_stmt_log_stmt_log_arg_keyword_level,
\    nft_expected_semicolon_or_new_line
" no error handling
" ************************* END log_stmt *****************************

" ************************* BEGIN reject_stmt ************************
hi link   nft_reject_stmt_reject_opts_icmp_num nftHL_Define
syn match nft_reject_stmt_reject_opts_icmp_num '\v[0-9]{1,2}' skipwhite contained

hi link   nft_reject_stmt_reject_opts_icmpx_types_enum nftHL_Define
syn match nft_reject_stmt_reject_opts_icmpx_types_enum
\ '\v(addr\-unreachable|admin\-prohibited|port\-unreachable|not\-neighbour|reject\-route|policy\-fail|no\-route)' skipwhite contained

hi link   nft_reject_stmt_reject_opts_icmp_types_enum nftHL_Define
syn match nft_reject_stmt_reject_opts_icmp_types_enum
\ '\v(fragmentation\-needed|host\-unreachable\-tos|precedence\-violation|protocol\-unreachable|net\-unreachable\-tos|source\-route\-failed|precedence\-cutoff|admin\-prohibited|host\-unreachable|port\-unreachable|net\-unreachable|host\-isolated|host\-unknown|net\-unknown|host\-anon|net\-anon)' skipwhite contained

hi link   nft_reject_stmt_reject_opts_icmp_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmp_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmp_types_enum,
\    nft_reject_stmt_reject_opts_icmp_num,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_icmpx_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmpx_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_types_enum,
\    nft_reject_stmt_reject_opts_icmp_num,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_icmpv6_keyword_type nftHL_Keyword
syn match nft_reject_stmt_reject_opts_icmpv6_keyword_type '\vtype' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_types_enum,
\    nft_reject_stmt_reject_opts_icmp_num,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_reset nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_reset '\vreset' skipwhite contained

hi link   nft_reject_stmt_reject_opts_keyword_icmp nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_icmp '\vicmp' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmp_keyword_type,
\    nft_reject_stmt_reject_opts_icmp_types_enum,
\    nft_reject_stmt_reject_opts_icmp_types_num,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_icmpx nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_icmpx '\vicmpx' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpx_keyword_type,
\    nft_reject_stmt_reject_opts_icmpx_types_enum,
\    nft_reject_stmt_reject_opts_icmpx_types_num,
\    nft_Error

hi link   nft_reject_stmt_reject_opts_keyword_icmpv6 nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_icmpv6 '\vicmpv6' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_icmpv6_types,
\    nft_reject_stmt_reject_opts_icmpv6_keyword_type

hi link   nft_reject_stmt_reject_opts_keyword_tcp nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_tcp '\vtcp' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_reset

hi link   nft_reject_stmt_reject_opts_keyword_with nftHL_Keyword
syn match nft_reject_stmt_reject_opts_keyword_with '\vwith' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_icmpv6,
\    nft_reject_stmt_reject_opts_keyword_icmpx,
\    nft_reject_stmt_reject_opts_keyword_icmp,
\    nft_reject_stmt_reject_opts_keyword_tcp,
\    nft_Error

hi link   nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject nftHL_Command
syn match nft_stmt_reject_stmt_reject_stmt_alloc_keyword_reject '\vreject\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    nft_reject_stmt_reject_opts_keyword_with,
\    nft_expected_semicolon_or_new_line
" ************************* END reject_stmt **************************

" ************************* BEGIN set_stmt ***************************
hi link    nft_set_stmt_and_map_stmt_delimiters nftHL_BlockDelimitersSet
syn region nft_set_stmt_and_map_stmt_delimiters start=+{+ end=+}+ keepend skipnl skipwhite contained

hi link   nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier nftHL_Element
syn match nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier '\v\@[a-zA-Z][a-zA-Z0-9\_-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_stmt_and_map_stmt_delimiters

hi link   nft_map_stmt_set_ref_expr_set_variable nftHL_Variable
syn match nft_map_stmt_set_ref_expr_set_variable '\v\$[a-zA-Z][a-zA-Z0-9\_-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_set_stmt_and_map_stmt_delimiters

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_delete nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_delete '\vdelete' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_update nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_update '\vupdate' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable

hi link   nft_stmt_set_stmt_set_stmt_op_keyword_add nftHL_Statement
syn match nft_stmt_set_stmt_set_stmt_op_keyword_add '\vadd\ze ' skipwhite contained
\ nextgroup=
\    nft_map_stmt_set_ref_expr_set_ref_symbol_expr_keyword_at_identifier,
\    nft_map_stmt_set_ref_expr_set_variable
" ************************* END set_stmt *****************************

" ************************* BEGIN ct_stmt **************************** SLE
hi link   nft_stmt_keyword_ct nftHL_Statement
syn match nft_stmt_keyword_ct '\vct[ \t]' skipwhite contained
\ nextgroup=
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_expectation,
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_expiration,
\    nft_stmt_ct_common_ct_key_keyword_direction,
\    nft_stmt_ct_common_ct_key_keyword_proto_dst,
\    nft_stmt_ct_common_ct_key_keyword_proto_src,
\    nft_primary_expr_ct_expr_ct_dir_keyword_original,
\    nft_stmt_ct_common_ct_key_keyword_protocol,
\    nft_stmt_ct_common_ct_key_keyword_l3proto,
\    nft_stmt_ct_common_ct_key_keyword_packets,
\    nft_stmt_ct_common_ct_key_keyword_secmark,
\    nft_stmt_objref_stmt_objref_stmt_ct_keyword_timeout,
\    nft_stmt_ct_common_ct_key_keyword_avgpkt,
\    nft_stmt_ct_common_ct_key_keyword_helper,
\    nft_stmt_ct_common_ct_key_keyword_status,
\    nft_stmt_ct_common_ct_key_keyword_bytes,
\    nft_add_cmd_set_block_stateful_stmt_list_stateful_stmt_connlimit_stmt_keyword_count,
\    nft_stmt_ct_common_ct_key_keyword_daddr,
\    nft_stmt_ct_common_ct_key_keyword_event,
\    nft_stmt_ct_common_ct_key_keyword_label,
\    nft_primary_expr_ct_expr_ct_dir_keyword_reply,
\    nft_stmt_ct_common_ct_key_keyword_saddr,
\    nft_stmt_ct_common_ct_key_keyword_state,
\    nft_stmt_ct_common_ct_key_keyword_mark,
\    nft_stmt_ct_common_ct_key_keyword_zone,
\    nft_stmt_ct_common_ct_key_keyword_id,
\    nft_Error

" ************************* END ct_stmt ******************************

syn cluster nft_c_stmt
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_common_block_keyword_include,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec,
\    nft_stmt_keyword_counter,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_keyword_devices,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_verdict_expr_keyword_accept,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_common_block_keyword_define,
\    nft_stmt_set_stmt_set_stmt_op_keyword_delete,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy,
\    nft_stmt_keyword_quota,
\    nft_verdict_expr_keyword_return,
\    nft_stmt_set_stmt_set_stmt_op_keyword_update,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_keyword_flags,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat,
\    nft_verdict_expr_keyword_drop,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow,
\    nft_verdict_expr_keyword_goto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_chain_stmt_verdict_expr_keyword_jump,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type,
\    nft_stmt_set_stmt_set_stmt_op_keyword_add,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_stmt_log_stmt_log_stmt_alloc_keyword_log,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_comment_inline,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator,
\    nft_rule_cluster_Error
" ************************* BEGIN counter_cmd' *************************
"**** BEGIN OF add_cmd_/'counter'/obj_spec *****
hi link   nft_add_cmd_keyword_counter_block_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_counter_block_stmt_separator '\v(\n|;)' skipwhite contained

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_bytes_num '\v[0-9]{1,10}\ze(([ \t;])|($))' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_config_bytes nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_config_bytes '\vbytes\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_packet_num '\v[0-9]{1,10}\ze(([ \t])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_config_keyword_packets nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_config_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_packet_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num '\v[0-9]{1,10}\ze[ \t;\}\n]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_block_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_bytes nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_bytes '\vbytes\ze[ \t]' skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num,
\   nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num '\v[0-9]{1,10}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_bytes,
\    nft_Error

hi link   nft_add_cmd_counter_block_Error_Always nftHL_Error
syn match nft_add_cmd_counter_block_Error_Always '\v\i{1,15}' skipwhite contained

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets '\vpackets\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num,
\    nft_Error


" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec QUOTED_STRING
hi link    nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double nftHL_Comment
syn region nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double start='"' end='"' skip='\\\"' keepend oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
hi link   nft_add_cmd_keyword_counter_counter_block_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_counter_counter_block_comment_spec '\vcomment\ze[ \t]' skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double

" add_cmd 'counter' obj_spec '{' counter_block '}'
hi link    nft_add_cmd_keyword_counter_counter_block nftHL_BlockDelimitersCounter
syn region nft_add_cmd_keyword_counter_counter_block start=/{/ end=/}/ skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_keyword_counter_counter_block_comment_spec,
\    nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_line_comment,
\    nft_add_cmd_keyword_counter_block_stmt_separator,
\    nft_Error

" add_cmd 'counter' table_identifier [ obj_id | 'last' ]
hi link   nft_add_cmd_counter_obj_spec_obj_id nftHL_Identifier
syn match nft_add_cmd_counter_obj_spec_obj_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze(([ \t])|($))' skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_counter_Semicolon nftHL_Normal
syn match nft_add_cmd_counter_Semicolon contained '\v\s{0,8};' skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_add_cmd_counter_last_Error_Always nftHL_Error
syn match nft_add_cmd_counter_last_Error_Always '\v\i{1,15}' skipwhite contained

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Keyword
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last '\vlast\ze(([ \t])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_add_cmd_counter_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->objref_stmt_counter->stmt->rule_alloc->rule->add_cmd->base_cmd->line
syn match nft_add_cmd_rule_rule_alloc_stmt_counter_objref_identifier '\v[a-zA-Z_][a-zA-Z0-9_]*' contained

" 'counter'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_counter nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_counter '\vcounter\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" ***************** END base_cmd 'counter' *****************

" ************************* BEGIN synproxy_cmd' *************************
" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_sack nftHL_Keyword
syn match nft_synproxy_block_synproxy_sack '\vsack\-perm\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_ts nftHL_Keyword
syn match nft_synproxy_block_synproxy_ts '\vtimestamp\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_block_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipempty skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale nftHL_Statement
syn match nft_synproxy_block_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_synproxy_block_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator /;/ skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num




" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator /;/ skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error

" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error

hi link    nft_add_cmd_keyword_synproxy_synproxy_block nftHL_Delimiters
syn region nft_add_cmd_keyword_synproxy_synproxy_block start=+{+ end=+}+ skip='\\\}' contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss,
\    nft_line_stmt_separator,
\    nft_InlineComment

" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_sack nftHL_Keyword
syn match nft_synproxy_config_synproxy_sack '\vsack\-perm\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_ts nftHL_Keyword
syn match nft_synproxy_config_synproxy_ts '\vtimestamp\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_config_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale nftHL_Statement
syn match nft_synproxy_config_keyword_wscale '\vwscale[ \t]' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator /;/ skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num '\v[0-9]{1,5}\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num '\v[0-9]{1,5}\ze(([ \t\;])|$)' skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale '\vwscale\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator /;/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num '\v[0-9]{1,5}\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss '\vmss\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss,
\    nft_add_cmd_keyword_synproxy_synproxy_block,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier '\v[a-zA-Z][a-zA-Z0-9\-_]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_identifier,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip /ip/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp /arp/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6 nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6 /ip6/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet /inet/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev /netdev/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier_keyword_last nftHL_Keyword
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier_keyword_last /last/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier
hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge nftHL_Family
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge /bridge/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier


" 'synproxy'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_synproxy nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_synproxy '\vsynproxy\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_bridge,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_netdev,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier_keyword_last,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_inet,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_arp,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip6,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_family_spec_explicit_ip,
\    nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" ************************* END synproxy_cmd' *************************

" ***************** BEGIN 'add' 'flowtable' ***************
hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int nftHL_Constant
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int '\v\-?[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var nftHL_Variable
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_c_flowtable_block_hook_keyword_priority_extended_sign nftHL_Expression
syn match nft_c_flowtable_block_hook_keyword_priority_extended_sign '\v[-+]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name nftHL_Keyword
syn match nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name '\v[a-zA-Z][a-zA-Z0-9]{1,16}' skipwhite contained
\ nextgroup=
\     nft_c_flowtable_block_hook_keyword_priority_extended_sign

hi link   nft_add_cmd_flowtable_block_hook_keyword_priority nftHL_Keyword
syn match nft_add_cmd_flowtable_block_hook_keyword_priority '\vpriority\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_int,
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_var,
\    nft_add_cmd_flowtable_block_hook_keyword_priority_extended_name,
\    nft_Error

hi link    nft_add_cmd_flowtable_block_hook_identifier_quoted_double nftHL_Identifier
syn region nft_add_cmd_flowtable_block_hook_identifier_quoted_double start='\"' end='\"' skip='\\\"' oneline skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link    nft_add_cmd_flowtable_block_hook_identifier_quoted_single nftHL_Identifier
syn region nft_add_cmd_flowtable_block_hook_identifier_quoted_single start='\'' end='\'' skip='\\\'' oneline skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_hook_keywords nftHL_Define
syn match nft_add_cmd_flowtable_block_hook_keywords '\v(ingress)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_add_cmd_flowtable_block_stmt_separator nftHL_Operator
syn match nft_add_cmd_flowtable_block_stmt_separator /;/ skipwhite contained

" base_cmd_add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_create_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_delete_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_destroy_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" table_block 'flowtable' flowtable_spec '{' flowtable_block 'hook'
hi link   nft_add_cmd_flowtable_block_keyword_hook nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_hook '\vhook' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_hook_keywords,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list flowtable_flag
hi link   nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag nftHL_Keyword
syn match nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag skipwhite contained
\ '\v(offload)'
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list
syn cluster nft_c_flowtable_block_flowtable_flag_list
\ contains=
\    nft_add_cmd_flowtable_block_flags_flowtable_flag_list_flowtable_flag

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags'
hi link   nft_add_cmd_flowtable_block_keyword_flags nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_flags 'flags' skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block_flowtable_flag_list,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flowtable_block_expr->'='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'counter'
hi link   nft_add_cmd_flowtable_block_keyword_counter nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_counter 'counter' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error


hi link   nft_flowtable_expr_comma nftHL_Expression
syn match nft_flowtable_expr_comma /,/ skipwhite contained

hi link   nft_flowtable_expr_unquoted_string nftHL_String
syn match nft_flowtable_expr_unquoted_string '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_flowtable_expr_unquoted_identifier nftHL_Identifier
syn match nft_flowtable_expr_unquoted_identifier '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link    nft_flowtable_expr_quoted_string_single nftHL_String
syn region nft_flowtable_expr_quoted_string_single start='\'' end='\'' skip='\\\'' oneline skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link    nft_flowtable_expr_quoted_string_double nftHL_String
syn region nft_flowtable_expr_quoted_string_double start='\"' end='\"' skip='\\\"' oneline skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link   nft_flowtable_expr_variable_expr nftHL_Variable
syn match nft_flowtable_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_comma

syn cluster nft_c_flowtable_expr_member
\ contains=
\    nft_flowtable_expr_variable_expr,
\    nft_flowtable_expr_quoted_string_single,
\    nft_flowtable_expr_quoted_string_double,
\    nft_flowtable_expr_unquoted_identifier

hi link    nft_flowtable_expr_block nftHL_BlockDelimitersFlowtable
syn region nft_flowtable_expr_block start=/{/ end=/}/ keepend skipwhite contained
\ contains =
\    @nft_c_flowtable_expr_member

hi link   nft_flowtable_expr_variable nftHL_Variable
syn match nft_flowtable_expr_variable '\v\$[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '='
" '='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_flowtable_block_devices_equal nftHL_Expression
syn match nft_add_cmd_flowtable_block_devices_equal /=/ skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_variable,
\    nft_flowtable_expr_block,

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices'
" 'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_flowtable_block_keyword_devices nftHL_Statement
syn match nft_add_cmd_flowtable_block_keyword_devices 'devices' skipwhite contained
\ nextgroup=
\    nft_add_cmd_flowtable_block_devices_equal

" ';'->flowtable_block->'{'->'flowtable'
hi link   nft_add_cmd_flowtable_block_separator nftHL_Separator
syn match nft_add_cmd_flowtable_block_separator ';' skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block

syn cluster nft_c_flowtable_block
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_flowtable_block_counter,
\    nft_add_cmd_flowtable_block_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_flowtable_block_keyword_flags,
\    nft_add_cmd_flowtable_block_keyword_hook,
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_comment_inline


" [ 'add' ] 'flowtable' table_id flow_id '{' flowtable_block
" flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link    nft_add_cmd_keyword_flowtable_flowtable_block nftHL_BlockDelimitersFlowTable
" Can use 'keepend' if and only if there are no further nesting of blocks (what about 'elements'?)
syn region nft_add_cmd_keyword_flowtable_flowtable_block start=/{/ end=/}/ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_add_cmd_flowtable_block_keyword_counter,
\    nft_add_cmd_flowtable_block_keyword_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_flowtable_block_keyword_flags,
\    nft_add_cmd_flowtable_block_keyword_hook,
\    nft_add_cmd_flowtable_block_stmt_separator,
\    nft_comment_inline,
\    nft_Error
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec identifier (chain)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable nftHL_Chain
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_block,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ '\v(bridge|netdev|inet|arp|ip6|ip)\ze\s'
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_UnexpectedEOL,
\    nft_Error

" base_cmd [ 'add' ] 'flowtable' flowtable_spec
syn cluster nft_c_add_cmd_keyword_flowtable_flowtable_spec
\ contains=@nft_c_add_cmd_keyword_flowtable_flowtable_spec_table_spec
" ***************** END 'add' 'flowtable' ***************

" ***************** BEGIN base_cmd 'flowtable' *****************
" 'flowtable'->add_cmd->'add'->base_cmd->line
" 'flowtable'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_flowtable nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_flowtable '\vflowtable\ze\s' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table,
\    nft_Error
" ***************** END base_cmd 'flowtable' *****************

"****************** third-level *******************************************
hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string nftHL_String
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string /\v\"[a-zA-Z][a-zA-Z0-9]{1,64}\"\ze($|\s|;|,|\})/ contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string_list_comma
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string /\v(\{|\s)\zs\'[a-zA-Z][a-zA-Z0-9]{1,64}\'\ze($|\s|;|,|\})/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string_list_comma

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_list_comma /,/ contained
\ nextgroup=
\     nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_number

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_high nftHL_Number
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_high '\v[0-9]{1,10}' skipwhite contained

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_dash nftHL_Expression
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_dash /-/ contained
\ nextgroup=
\     nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_high

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_number nftHL_Number
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_number '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_list_comma,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_dash

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_list_IP_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_list_IP_comma ',' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_block_element_set_list_IP

hi link   nft_common_block_define_redefine_keywords_initializer_expr_block_element_set_list_IP nftHL_Identifier
syn match nft_common_block_define_redefine_keywords_initializer_expr_block_element_set_list_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_list_IP_comma

hi link   nft_define_undefine_keywords_block_MapEntry_element_value nftHL_Device
syn match nft_define_undefine_keywords_block_MapEntry_element_value '\v[0-9]{1,10}\ze\s{0,10}:' skipwhite contained
\ nextgroup=
\    nft_define_undefine_keywords_block_MapEntry_element_list_comma
syn match nft_define_undefine_keywords_block_MapEntry_element_value '\v\"[-a-zA-Z0-9_@.\/]*\"' skipwhite contained
\ nextgroup=
\    nft_define_undefine_keywords_block_MapEntry_element_list_comma
syn match nft_define_undefine_keywords_block_MapEntry_element_value '\v\'[-a-zA-Z0-9_@.\/]*\'' skipwhite contained
\ nextgroup=
\    nft_define_undefine_keywords_block_MapEntry_element_list_comma

hi link   nft_define_undefine_keywords_block_MapEntry_element_list_comma nftHL_Element
syn match nft_define_undefine_keywords_block_MapEntry_element_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_unquoted_identifier /\v([^\'\"])?\zs[a-zA-Z][a-zA-Z0-9]{0,63}\ze(\}|([^:\.$]))/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_set_element_unquoted_identifier_list_comma

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_set_element_unquoted_identifier_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_set_element_unquoted_identifier_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_unquoted_identifier

" 'define' supports only simple variable or single-line maps, hence 'oneline'
"syntax match nft_empty_set /\v\{\zs\s*\ze\}/ oneline contained
hi link   nft_empty_set nftHL_SpecialComment
syn match nft_empty_set '\v\{\s{0,32}\}' oneline contained
\ nextgroup=
\    nft_common_block_stmt_separator

" In 'define'/'redefine', curly braces {} in the expression are required only for:
"
" - Map definitions
" - Set definitions
" - Lists of values

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr nftHL_Constant
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr_list_comma,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP nftHL_Constant
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP_list_comma,
\    nft_initializer_BadToken

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_IP nftHL_Constant
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\ze\s{0,10}:' skipwhite contained
\ nextgroup=
\    nft_initializer_BadToken

syn cluster nft_c_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier
\ contains=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_list_comma ',' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_IP nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_list_comma,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_unquoted_identifier '\v[a-zA-Z][a-zA-Z0-9]{0,63}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_list_comma,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_colon nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_colon ':' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_IP,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_quoted_string,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_value_unquoted_identifier,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier /\v[a-zA-Z][a-zA-Z0-9]{0,63}\ze\s*:/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_colon,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma ',' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_IP nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_IP '\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_unquoted_identifier '\v[a-zA-Z][a-zA-Z0-9]{0,63}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_colon nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_colon ':' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_IP,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_quoted_string,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_value_unquoted_identifier,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr '\v[0-9]{0,11}\ze\s{0,10}:' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_colon,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_unexpected_symbol nftHL_Error
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_unexpected_symbol /[,;\$`~!@\#%]/ skipwhite contained


 " no quoted_string for map key
hi link    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block nftHL_SpecialComment
syn region nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block start='\v\s*\{' end=+}+ keepend skipwhite contained
\ contains=
\    @nft_c_common_block,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_unexpected_symbol,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_unquoted_identifier,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_IP,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_IP,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr,
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr,
\    nft_Error
\ nextgroup=
\    nft_common_block_stmt_separator,
"\    nft_initializer_BadToken,
"\    nft_Error

" TODO, reverify this primary_expr_payload_expr in 'describe'
hi link   nft_describe_keyword_primary_expr_payload_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_payload_expr '(arp_op|arp hlen|arp htype|ar operation|arp plen|ether_addr|tcp|udp)\ze[ \t]' skipwhite contained

hi link   nft_describe_keyword_primary_expr_meta_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_meta_expr 'iifgroup' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifgroup' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iifkind' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iifname' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iiftype' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifkind' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oifname' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oiftype' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'iif' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr 'oif' skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr '(ether_type|hour|time|day)\ze[ \t]' skipwhite contained

hi link   nft_base_cmd_keyword_describe nftHL_Command
syn match nft_base_cmd_keyword_describe '\vdescribe\ze[ \t]' oneline skipwhite contained
\ nextgroup=
\    nft_describe_keyword_primary_expr_datatype,
\    nft_describe_keyword_primary_expr_payload_expr,
\    nft_describe_keyword_primary_expr_meta_expr
"***************** END OF SECOND-LEVEL SYNTAXES ********************************
"*************** END OF FIRST-LEVEL & SECOND-LEVEL SYNTAXES ********************

"***************** BEGIN OF TOP-LEVEL SYNTAXES *********************************
" **************** BEGIN destroy_cmd *********************************
hi link   nft_destroy_cmd_keyword_chain_chainid_spec_num nftHL_Handle
syn match nft_destroy_cmd_keyword_chain_chainid_spec_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle 'handle' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_num

hi link   nft_destroy_cmd_keyword_chain_chain_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_chain_spec_keyword_last 'last' skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_keyword_last nftHL_Keyword
syn match nft_destroy_cmd_keyword_chain_table_spec_keyword_last 'last' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_destroy_cmd_keyword_chain_table_spec_family_spec '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain nftHL_Statement
syn match nft_destroy_cmd_keyword_chain 'chain' skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_family_spec,
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" add_cmd 'destroy' table_identifier [ obj_id | 'last' ]
hi link   nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id nftHL_Identifier
syn match nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}\ze(([ \t;])|($))' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_base_cmd_keyword_counter_keyword_table_Semicolon nftHL_Normal
syn match nft_base_cmd_keyword_counter_keyword_table_Semicolon contained '\v\s{0,8};' skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_base_cmd_keyword_counter_keyword_table_last_Error_Always nftHL_Error
syn match nft_base_cmd_keyword_counter_keyword_table_last_Error_Always '\v\i{1,15}' skipwhite contained

syn cluster nft_c_add_cmd_keyword_counter_obj_spec_obj_last
\ contains=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Keyword
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last 'last' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec_obj_last

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id '\v[a-zA-Z][a-zA-Z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->add_cmd->base_cmd->line
hi link   nft_add_cmd_counter_keyword_table nftHL_Command
syn match nft_add_cmd_counter_keyword_table '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS



"******************** BEGIN chain_stmt ******************************
hi link    nft_chain_stmt_delimiters nftHL_Delimiters
syn region nft_chain_stmt_delimiters start=+{+ end=+}+ skipwhite contained
\ contains=
\    @nft_c_rule

"******************** END chain_stmt ******************************


" ***************** BEGIN 'add' 'rule' ***************
syn cluster nft_c_base_cmd_add_cmd_rule_alloc_stmt_cluster
\ contains=
\    nft_add_cmd_rule_rule_alloc_stmt_masq_keyword_masquerade,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_verdict_expr_keyword_continue,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_redir_stmt_redir_stmt_alloc_keyword_redirect,
\    nft_add_cmd_rule_rule_alloc_stmt_synproxy_stmt_keyword_synproxy,
\    nft_stmt_keyword_counter,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_notrack,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_verdict_expr_keyword_accept,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_chain_block_primary_expr_numgen_expr_keyword_numgen,
\    nft_verdict_expr_keyword_return,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
\    nft_stmt_keyword_quota,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skgid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_skuid,
\    nft_payload_expr_dccp_hdr_expr_keyword_dccp,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_dnat,
\    nft_verdict_expr_keyword_drop,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_flow,
\    nft_verdict_expr_keyword_goto,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_chain_stmt_verdict_expr_keyword_jump,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_stmt_nat_stmt_nat_stmt_alloc_keyword_snat,
\    nft_payload_expr_sctp_hdr_expr_keyword_sctp,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_payload_expr_esp_hdr_expr_keyword_esp,
\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_stmt_log_stmt_log_stmt_alloc_keyword_log,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_payload_expr_tcp_hdr_expr_keyword_tcp,
\    nft_payload_expr_udp_hdr_expr_keyword_udp,
\    nft_payload_expr_ah_hdr_expr_keyword_ah,
\    nft_objref_stmt_objref_stmt_ct_keyword_ct,
\    nft_payload_expr_th_hdr_expr_keyword_th,
\    nft_rule_cluster_Error
"\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_keyword_meta,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_hash_expr_keyword_symhash,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_udplite,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_exists_expr_keyword_exthdr,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_geneve,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_gretap,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_socket_expr_keyword_socket,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ether,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_hash_expr_keyword_jhash,
"\    nft_add_cmd_rule_rule_alloc_stmt_meter_stmt_meter_stmt_alloc_keyword_meter,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_vxlan,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_auth,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_comp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_dccp,
"\    nft_add_cmd_rule_rule_alloc_stmt_nat_stmt_keyword_dnat,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_frag_hdr_expr_keyword_frag,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_icmp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_igmp,
"\    nft_add_cmd_rule_rule_alloc_stmt_nat_stmt_keyword_snat,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_sctp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_vlan,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_arp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_dst_hdr_expr_keyword_dst,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_esp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_fib_expr_keyword_fib,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_gre,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_hbh_hdr_expr_keyword_hbh,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ip6,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_osf_expr_keyword_osf,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt0_hdr_expr_keyword_rt0,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt2_hdr_expr_keyword_rt2,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt4_hdr_expr_keyword_rt4,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_tcp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_udp,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_payload_raw_expr_keyword_at,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_payload_expr_keyword_ip,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_mh_hdr_expr_keyword_mh,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_exthdr_expr_rt_hdr_expr_keyword_rt,
"\    nft_payload_expr_th_hdr_expr_keyword_th,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_block,  \" '{'  basic_expr '}'
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_integer_expr,
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_symbol_expr_variable_expr,  \" $var_name
"\    nft_add_cmd_rule_rule_alloc_stmt_primary_expr_symbol_expr_string,         \" usually quoted, some pre-defined identifier/keywords

" ***************** BEGIN meta_expr ***************
" If it's followed by a set, it's likely meta_stmt. If it's
" followed by a field name and then a comparison (==, <, etc.),
" it's meta_expr.
hi link   nft_add_cmd_rule_rule_alloc_stmt_primary_expr_meta_expr_meta_key_unqualified_keyword_rtclassid nftHL_Keyword
syn match nft_add_cmd_rule_rule_alloc_stmt_primary_expr_meta_expr_meta_key_unqualified_keyword_rtclassid "\vrtclassid\ze[ \t\n]" skipwhite contained

" ***************** END meta_expr ***************




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

hi link   nft_add_cmd_rule_rule_alloc_stmt_keyword_not nftHL_Operator
syn match nft_add_cmd_rule_rule_alloc_stmt_keyword_not '\vnot\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_rtclassid,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obriport,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_ibrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_nftrace,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_obrname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oifname,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oiftype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_pkttype,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cgroup,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_expr_keyword_ipsec,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_hour,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_mark,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_time,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_cpu,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_day,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_iif,
\    nft_add_cmd_rule_rule_alloc_stmt_meta_stmt_meta_key_unqualified_keyword_oif,
\    nft_comment_inline,
\    nft_rule_cluster_Error

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
\    nft_base_cmd_add_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_base_cmd_keyword_create,
\    nft_common_block_keyword_define,
\    nft_base_cmd_keyword_delete,
\    nft_base_cmd_keyword_insert,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_keyword_rename,
\    nft_base_cmd_add_cmd_keyword_chain_declarative,
\    nft_common_block_keyword_error,
\    nft_base_cmd_keyword_flush,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_keyword_reset,
\    nft_base_cmd_keyword_table_declarative,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_base_cmd_keyword_list,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_base_cmd_keyword_get,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier_declarative,
\    nft_line_separator,
\    nft_comment_inline,
\    nft_line_nonidentifier_error
" practically no way to highlight an incorrect first alphanum token due
" to unquoted_table_identifier as the first token
" 'nft_Error_Always' is that catch-all for 1st token

" `nft_line_comment` main top-level syntax, do not add 'contained' here.
" works for #inline comment as well
" contains=NONE to ensure that no other group are folded into this match
hi link   nft_line_comment nftHL_Comment
syn match nft_line_comment '\v#.{0,127}$' skipwhite
\ contains=NONE

" Match the comment region (containing the entire line)
hi link   nft_comment_inline nftHL_Comment
syntax region nft_comment_inline start='\#' end='$' skip="#.*$" oneline skipwhite keepend contained

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