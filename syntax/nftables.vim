" Vim syntax file for nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     1.1
" Initial Date: 2020-04-24
" Last Change:  2025-01-19
" Filenames:    nftables.conf, *.nft
" Location:     https://github.com/egberts/vim-nftables
" License:      MIT license
" Remarks:
" Bug Report:   https://github.com/egberts/vim-nftables/issues
"
"  WARNING:  Do not add online comments using a double-quote, it ALTERS patterns
"
"
"  ~/.vimrc flags used:
"
"      g:nftables_syntax_disabled, if exist then entirety of this file gets skipped
"      g:nftables_debug, extra outputs
"      g:nftables_colorscheme, if exist, then 'nftables.vim' colorscheme is used
""
"  This syntax supports both ANSI 256color and ANSI TrueColor (16M colors)
"
"  For ANSI 16M TrueColor:
"  - ensure that `$COLORTERM=truecolor` (or `=24bit`) at command prompt
"  - ensure that `$TERM=xterm-256color` (or `xterm+256color` in macos) at command prompt
"  - ensure that `$TERM=screen-256color` (or `screen+256color` in macos) at command prompt
"  For ANSI 256-color, before starting terminal emulated app (vim/gvim):
"  - ensure that `$TERM=xterm-256color` (or `xterm+256color` in macos) at command prompt
"  - ensure that `$COLORTERM` is set to `color`, empty or undefined
"
" Vimscript Limitation:
" - background setting does not change here, but if left undefined ... it's unchanged.
" - colorscheme setting does not change here, but if left undefined ... it's unchanged.
" - Vim 7+ attempts to guess the `background` based on term-emulation of ASNI OSC52 behavior
" - If background remains indeterminate, we guess 'light' here, unless pre-declared in ~/.vimrc
" - nftables variable name can go to 256 characters,
"       but in vim-nftables here, the variable name however is 64 chars maximum."
" - nftables time_spec have no limit to its string length,
"       but in vim-nftables here, time_spec limit is 11 (should be at least 23)
"       because '365d52w24h60m60s1000ms'.  Might shoot for 32.

" TIPS:
" - always add '\v' to any OR-combo list like '\v(opt1|opt2|opt3)' in `syntax match`
" - always add '\v' to any OR-combo list like '\v[a-zA-Z0-9_]' in `syntax match`
" - place any 'contained' keyword at end of line (EOL)
" - never use '?' in `match` statements
" - 'contains=' ordering MATTERS in `cluster` statements
" - 'region' seems to enjoy the 'keepend' option
" - ordering between 'contains=' and 'nextgroup=' statements, first one wins (but not in region)
" - ordering between 'contains=' statements amongst themselves, first one wins
" - ordering within 'contains=' statements, last one wins
" - ordering within 'nextgroup=' statements, last one wins
" - last comma must not exist on statement betweeen 'contains='/'nextgroup' and vice versa
"
" Developer Notes:
"  - relocate inner_inet_expr to after th_hdr_expr?
"
" syntax/nftables.vim is called before colors/nftables.vim
" syntax/nftables.vim is called before ftdetect/nftables.vim
" syntax/nftables.vim is called before ftplugin/nftables.vim
" syntax/nftables.vim is called before indent/nftables.vim

if exists('nft_debug') && nft_debug == 1
  echomsg "syntax/nftables-new.vim: called."
  echomsg printf("&background: '%s'", &background)
  echomsg printf("colorscheme: '%s'", execute(':colorscheme')[1:])
endif

"if exists('g:loaded_syntax_nftables')
"    finish
"endif
"let g:loaded_syntax_nftables = 1

" quit if terminal is a black and white
if &t_Co <= 1
  finish
endif

" .vimrc variable to disable html highlighting
if exists('g:nftables_syntax_disabled')
  finish
endif

" This syntax does not change background setting
" BUT it may later ASSUME a specific background setting

if exists('g:nft_debug') && g:nft_debug == 1
  echo "Use `:messages` for log details"
endif

" experiment with loading companion colorscheme
if exists('nft_colorscheme') && g:nft_colorscheme == 1
  try
    if exists('g:nft_debug') && g:nft_debug == 1
      echomsg "Loaded 'nftables' colorscheme."
    endif
    colorscheme nftables
  catch /^Vim\%((\a\+)\)\=:E185/
    echomsg "WARNING: nftables colorscheme is missing"
    " deal with it
  endtry
else
  if exists('g:nft_debug') && nft_debug == 1
    echomsg "No nftables colorscheme loaded."
  endif
endif


if !exists('&background') || empty(&background)
  " if you want to get value of background, use `&background ==# dark` example
  let nft_obtained_background = 'no'
else
  let nft_obtained_background = 'yes'
endif

let nft_truecolor = "no"
if !empty($TERM)
  if $TERM == "xterm-256color" || $TERM == "xterm+256color"
    if !empty($COLORTERM)
      if $COLORTERM == "truecolor" || $COLORTERM == "24bit"
        let nft_truecolor = "yes"
        if exists('g:nft_debug') && g:nft_debug == v:true
          echomsg "\$COLORTERM is 'truecolor'"
        endif
      else
        if exists('g:nft_debug') && g:nft_debug == v:true
          echomsg "\$COLORTERM is not 'truecolor'"
        endif
      endif
    else
      if exists('g:nft_debug') && g:nft_debug == v:true
        echomsg "\$COLORTERM is empty"
      endif
    endif
  else
    if exists('g:nft_debug') && nft_debug == v:true
      echomsg "\$TERM does not have xterm-256color"
    endif
  endif
else
  echomsg \$TERM is empty
endif

if exists(&background)
  let nft_obtained_background=execute(':set &background')
endif

" For version 6.x: Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
   " Quit when a (custom) syntax file was already loaded
    finish
  endif
  let main_syntax = 'nftables'
endif

if exists('nft_debug') && nft_debug == 1
  echomsg printf('nft_obtained_background: %s', nft_obtained_background)
  echomsg printf('nft_truecolor: %s', nft_truecolor)
  if exists('g:saved_nft_t_Co')
    echomsg printf('saved t_Co %d', g:saved_nft_t_Co)
  else
    echomsg printf('t_Co %d', &t_Co)
  endif
"  if has('termguicolors')
"    if &termguicolors == v:true
"      echom('Using guifg= and guibg=')
"    else
"      echom('Using ctermfg= and ctermbg=')
"    endif
"  endif
endif

syn case match

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_nftables_syn_inits")
  if version < 508
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
endif


" iskeyword severly impacts '\<' and '\>' atoms
" setlocal iskeyword=.,48-58,A-Z,a-z,\_,\/,-
setlocal isident=.,48-58,A-Z,a-z,\_

let s:cpo_save = &cpo
set cpo&vim  " Line continuation '\' at EOL is used here
set cpoptions-=C

syn sync clear
syn sync maxlines=1000
syn sync match nftablesSync grouphere NONE \"^(rule|add {1,15}rule|table|chain|set)\"
" syn sync fromstart "^(monitor|table|set)"
" syn sync fromstart


hi link Variable              String
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
hi def link nftHL_BlockDelimiters  Normal

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
  if exists('g:nft_debug') && g:nft_debug == v:true
    echom "nft_colorscheme detected"
  endif
  hi def nftHL_BlockDelimitersTable  guifg=LightBlue ctermfg=LightRed ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersChain  guifg=LightGreen ctermfg=LightGreen ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSet  ctermfg=17 guifg=#0087af ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMap  ctermfg=17 guifg=#2097af ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersFlowTable  ctermfg=LightMagenta guifg=#950000 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCounter  ctermfg=LightYellow guifg=#109100 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersQuota  ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersCT  ctermfg=Red guifg=#c09000 ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersLimit  ctermfg=Red ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSecMark  ctermfg=Red ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersSynProxy  ctermfg=Red ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersMeter  ctermfg=Red ctermbg=Black cterm=NONE
  hi def nftHL_BlockDelimitersDevices  ctermfg=Blue ctermbg=Black cterm=NONE
endif

"*********
hi link   nft_ToDo nftHL_ToDo
syn keyword nft_ToDo xxx contained XXX FIXME TODO TODO: FIXME: TBS TBD TBA
\ containedby=nft_InlineComment

hi link   nft_InlineComment nftHL_Comment
syn match nft_InlineComment "\v\# " skipwhite contained

hi link   nft_EOS nftHL_Error
syn match nft_EOS /\v[^ \t]{1,6}[\n\r\#]{1,3}/ skipempty skipnl skipwhite contained

hi link   nft_UnexpectedSemicolon nftHL_Error
syn match nft_UnexpectedSemicolon "\v;{1,7}" contained

" stmt_separator (via nft_chain_block, nft_chain_stmt, @nft_c_common_block,
"                     counter_block, ct_expect_block, ct_expect_config,
"                     ct_helper_block, ct_helper_config, ct_timeout_block,
"                     ct_timeout_config, flowtable_block, limit_block,
"                     nft_line, nft_map_block, nft_quota_block,
"                     nft_secmark_block, nft_set_block, nft_synproxy_block,
"                     nft_synproxy_config, table_block )
hi link   nft_stmt_separator nftHL_Normal
syn match nft_stmt_separator "\v(\n|;)" skipwhite contained

" hi link   nft_hash_comment nftHL_Error
" syn match nft_hash_comment '\v#.{15,65}$' skipwhite contained

hi link   nft_line_inline_comment nftHL_Comment
syn match nft_line_inline_comment "\v#.{0,127}$" skipwhite contained

hi link   nft_line_comment_line nftHL_Comment
syn match nft_line_comment_line "\v#.{0,127}$" skipwhite contained

" syn match nft_Set contained /{.*}/ contains=nft_SetEntry contained
" syn match nft_SetEntry contained /[a-zA-Z0-9]\+/ contained
" hi def link nft_Set nftHL_Keyword
" hi def link nft_SetEntry nftHL_Operator

"syn match nft_Number "\<[0-9A-Fa-f./:]\+\>" contained contains=nft_Mask,nft_Delimiter
" syn match nft_Hex "\<0x[0-9A-Fa-f]\+\>" contained
" syn match nft_Delimiter "[./:]" contained
" syn match nft_Mask "/[0-9.]\+" contains=nft_Delimiter contained
" hi def link nft_Number nftHL_Number
" hi def link nft_Hex nftHL_Number
" hi def link nft_Delimiter nftHL_Operator
" hi def link nft_Mask nftHL_Operator

" Uncontained, unrestricted statement goes here
"
hi link   nft_MissingDeviceVariable nftHL_Error
syn match nft_MissingDeviceVariable "\v[^ \t\$\{]{1,5}" skipwhite contained " do not use 'keepend' here

hi link   nft_MissingCurlyBrace nftHL_Error
syn match nft_MissingCurlyBrace "\v[ \t]\ze[^\{]{1,1}" skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedCurlyBrace nftHL_Error
syn match nft_UnexpectedCurlyBrace "\v\s{0,7}\{" contained " do not use 'keepend' here

hi link   nft_UnexpectedEmptyCurlyBraces nftHL_Error
syn match nft_UnexpectedEmptyCurlyBraces "\v\{\s*\}" skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedEmptyBrackets nftHL_Error
syn match nft_UnexpectedEmptyBrackets "\v\[\s*\]" skipwhite contained " do not use 'keepend' here

hi link   nft_UnexpectedIdentifierChar nftHL_Error
"syn match nft_UnexpectedIdentifierChar contained "\v[^a-zA-Z0-9_\n]{1,3}" contained
syn match nft_UnexpectedIdentifierChar contained "\v(^[a-zA-Z0-9_\n]{1,3})" contained

" We'll do error RED highlighting on all statement firstly, then later on
" all the options, then all the clauses.
" Uncomment following two lines for RED highlight of typos (still Beta here)
hi link   nft_UnexpectedEOS nftHL_Error
syn match nft_UnexpectedEOS contained "\v[\t ]{0,2}[\#;\n]{1,2}.{0,1}" contained

hi link   nft_Error_Always nftHL_Error
syn match nft_Error_Always /[^(\n|\r)\.]\{1,15}/ skipwhite contained

hi link   nft_Error nftHL_Error
syn match nft_Error /\v[\s\wa-zA-Z0-9_]{1,64}/ skipwhite contained  " uncontained, on purpose

" expected end-of-line (iterator capped for speed)
syn match nft_EOL /[\n\r]\{1,16}/ skipwhite contained

" syntax keyword nft_CounterKeyword last contained


" nft_Semicolon commented out to make way for syntax-specific semicolons
" hi link   nft_Semicolon nftHL_Operator
" syn match nft_Semicolon contained /\v\s{0,8}[;]{1,15}/  skipwhite contained

hi link   nft_comment_inline nftHL_Error
syn match nft_comment_inline "\#.*$" contained

hi link   nft_identifier_exact nftHL_Identifier
syn match nft_identifier_exact "\v[a-zA-Z][a-zA-Z0-9_]{0,63}" contained

" We limit to 63-char maximum for identifier name (for Vim session speed)
hi link   nft_identifier nftHL_Identifier
syn match nft_identifier "\v\w{0,63}" skipwhite contained
\ contains=
\    nft_identifier_exact,
\    nft_Error

hi link   nft_variable_identifier nftHL_Variable
syn match nft_variable_identifier "\v[a-zA-Z][a-zA-Z0-9_]{0,63}" skipwhite contained

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
hi link   nft_base_cmd_add_cmd_rule_position_table_spec_wildcard nftHL_Identifier
syn match nft_base_cmd_add_cmd_rule_position_table_spec_wildcard "\v[A-Za-z][A-Za-z0-9_]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_chain_spec,
\    nft_UnexpectedEOS


hi link   nft_string_unquoted nftHL_String
"syn match nft_string_unquoted '\v[a-zA-Z0-9\/\\\[\]\$]{1,64}' skipwhite keepend contained

hi link   nft_string_sans_double_quote nftHL_String
syn match nft_string_sans_double_quote "\v[a-zA-Z0-9\/\\\[\]\"]{1,64}" keepend contained

hi link   nft_string_sans_single_quote nftHL_String
syn match nft_string_sans_single_quote "\v[a-zA-Z0-9\/\\\[\]\']{1,64}" keepend contained

hi link    nft_string_single nftHL_String
syn region nft_string_single start="'" skip="\\\'" end="'" keepend oneline contained
\ contains=
\    nft_string_sans_single_quote

hi link    nft_string_double nftHL_String
syn region nft_string_double start="\"" skip="\\\"" end="\"" keepend oneline contained
\ contains=
\    nft_string_sans_double_quote

syn cluster nft_c_quoted_string
\ contains=
\    nft_string_single,
\    nft_string_double

hi link    nft_asterisk_string nftHL_String
syn region nft_asterisk_string start="\*" skip="\\\*" end="\*" keepend oneline contained
\ contains=
\    nft_string_unquoted

syn cluster nft_c_string
\ contains=
\    nft_asterisk_string,
\    @nft_c_quoted_string,
\    nft_string_unquoted

" nft_identifier_last (via identifer)
hi link  nft_identifier_last nftHL_Keyword
syn match nft_identifier_last "last" skipwhite contained

" identifier
syn cluster nft_identifier
\ contains=
\    nft_identifier_last,
\    @nft_c_string
" nft_c_string must be the LAST contains= (via nft_unquoted_string)

" 'add' 'table' <table_identifier>
" identifier->table_spec->chain_spec->rule_position->add_cmd
hi link   nft_add_cmd_keyword_rule_rule_position_table_spec_end nftHL_Identifier
syn match nft_add_cmd_keyword_rule_rule_position_table_spec_end "\v\i{1,63}" skipwhite contained
\ nextgroup= nft_add_cmd_rule_position_chain_spec

" nft_add_cmd_keyword_rule_rule_position_table_spec_end must be the first keyword
" of any keyword from the starting column 1

hi link   nft_common_block_stmt_separator nftHL_Expression
syn match nft_common_block_stmt_separator ";" skipwhite contained


"****************** BEGIN OF NFTABLE SYNTAX *******************************

"****************** third-level *******************************************
hi link   nft_common_block_define_redefine_initializer_expr_dash_num nftHL_Number
syn match nft_common_block_define_redefine_initializer_expr_dash_num "\v[0-9]{1,7}" skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_Error

"*************** BEGIN OF SECOND-LEVEL SYNTAXES *****************************

syn cluster nft_c_common_block_initializer_expr
\ contains=
\    nft_rhs_expr,
\    nft_list_rhs_expr,
\    nft_common_block_keyword_define_redefine_initializer_expr_empty_set,
\    nft_common_block_keyword_define_redefine_initializer_expr_dash

"*************** END OF SECOND-LEVEL SYNTAXES *******************************


"*************** END OF FIRST-LEVEL & SECOND-LEVEL SYNTAXES ****************************

"*************** BEGIN OF TOP-LEVEL SYNTAXES ****************************

" common_block
" common_block (via chain_block, counter_block, ct_expect_block, ct_helper_block,
"                   ct_timeout_block, flowtable_block, limit_block, line, map_block,
"                   quota_block, secmark_block, set_block, synproxy_block, table_block

" common_block 'define'/'redefine identifier <STRING> '=' initializer_expr
" common_block 'define'/'redefine identifier <STRING> '=' rhs_expr
" common_block 'define'/'redefine identifier <STRING> '=' list_rhs_expr
" common_block 'define'/'redefine identifier <STRING> '=' '{' '}'
" common_block 'define'/'redefine identifier <STRING> '=' '-'number
" common_block 'define'/'redefine' value (via nft_common_block_define_redefine_equal)
hi link   nft_common_block_define_redefine_value nftHL_Number
syn match nft_common_block_define_redefine_value "\v[\'\"\$\{\}:a-zA-Z0-9\_\/\\\.\,\}\{]+\s{0,16}" skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator
"\    nft_comment_inline,

" common_block 'define'/'redefine identifier <STRING> '=' '{' '}'
hi link    nft_common_block_define_redefine_initializer_expr_empty_set nftHL_Expression
syn region nft_common_block_define_redefine_initializer_expr_empty_set start=+{+ end=+}+ keepend skipwhite contained
\ contains=
\    nft_Error
\ nextgroup=
\    nft_common_block_stmt_separator

" common_block 'define'/'redefine identifier <STRING> '=' -number
" noticed 'no whitespace' between '-' and integer digits?
hi link   nft_common_block_define_redefine_initializer_expr_dash nftHL_Number
syn match nft_common_block_define_redefine_initializer_expr_dash /\-/ contained
\ nextgroup=
\    nft_common_block_define_redefine_initializer_expr_dash_num,
\    nft_Error_Always

" common_block 'define'/'redefine identifier '=' rhs_expr concat_rhs_expr basic_rhs_expr
hi link   nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr nftHL_Operator
syn match nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr /|/ skipwhite contained
\ nextgroup=
\    @nft_c_common_block_define_redefine_initializer_expr_nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr_basic_rhs_expr_bar,
\    nft_common_block_stmt_separator
" TODO: typo ^^^^

" END OF common_block

" num->initializer_expr->common_block
hi link   nft_common_block_define_redefine_keywords_initializer_expr_num nftHL_Integer
syn match nft_common_block_define_redefine_keywords_initializer_expr_num "\v[0-9]{1,11}" skipwhite contained

" '-'->initializer_expr->common_block
hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash /-/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_num

" '{'->initializer_expr->common_block
hi link   nft_common_block_define_redefine_keywords_initializer_expr_block nftHL_Normal
syn region nft_common_block_define_redefine_keywords_initializer_expr_block start="{" end="}" skipwhite contained

" initializer_expr->common_block
syn cluster nft_common_block_define_redefine_keywords_initializer_expr
\ contains=
\    nft_common_block_define_redefine_keywords_initializer_expr_dash,
\    nft_common_block_define_redefine_keywords_initializer_expr_block,
\    @nft_c_rhs_expr,
\    @nft_c_list_rhs_expr
" list_rhs_expr must be the last 'contains=' entry
"     as its basic_rhs_expr->exclusive_or_rhs_expr->and_rhs_expr->shift_rhs_expr->primary_rhs_expr->symbol_expr
"     uses <string> which is a (wildcard)

hi link   nft_common_block_filespec_sans_single_quote nftHL_String
syn match nft_common_block_filespec_sans_single_quote "\v[\"_\-\.\;\?a-zA-Z0-9\,\:\+\=\*\&\^\%\$\!`\~\#\@\|\/\\\(\)\{\}\[\]\<\>(\\\')]+" keepend contained

hi link    nft_common_block_filespec_quoted_single nftHL_String
syn region nft_common_block_filespec_quoted_single start="\'" skip="\\\'" end="\'" skipwhite keepend oneline contained
\ contains=
\    nft_common_block_filespec_sans_single_quote
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" \    nft_comment_inline,

hi link   nft_common_block_filespec_sans_double_quote nftHL_String
syn match nft_common_block_filespec_sans_double_quote "\v[\'_\-\.\;\?a-zA-Z0-9\,\:\+\=\*\&\^\%\$\!`\~\#\@\|\/\(\)\{\}\[\]\<\>(\\\")]+" keepend contained

hi link    nft_common_block_filespec_quoted_double nftHL_String
syn region nft_common_block_filespec_quoted_double start="\"" skip="\\\"" end="\"" skipwhite oneline keepend contained
\ contains=
\    nft_common_block_filespec_sans_double_quote
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_Error
" \    nft_comment_inline,

syn cluster nft_c_common_block_keyword_include_quoted_string
\ contains=
\    nft_common_block_filespec_quoted_single,
\    nft_common_block_filespec_quoted_double,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_common_block_keyword_include nftHL_Include
syn match nft_common_block_keyword_include "include" skipwhite oneline contained
\ nextgroup=
\    @nft_c_common_block_keyword_include_quoted_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" TODO: common_block 'define'/'redefine identifier '=' rhs_expr concat_rhs_expr
syn cluster nft_c_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr
\ contains=
\    nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr_basic_rhs_expr,
\    nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr_multion_rhs_expr

" TODO: common_block 'define'/'redefine identifier '=' rhs_expr set_expr
" TODO: common_block 'define'/'redefine identifier '=' rhs_expr set_ref_symbol_expr

" common_block 'define'/'redefine identifier '=' rhs_expr
syn cluster nft_c_common_block_define_redefine_initializer_expr_rhs_expr
\ contains=
\    nft_common_block_define_redefine_initializer_expr_rhs_expr_concat_rhs_expr,
\    nft_common_block_define_redefine_initializer_expr_rhs_expr_set_expr,
\    nft_common_block_define_redefine_initializer_expr_rhs_expr_set_ref_symbol_expr

" common_block 'define'/'redefine identifier '=' initializer_expr
syn cluster nft_c_common_block_define_redefine_initializer_expr
\ contains=
\    nft_common_block_define_redefine_initializer_expr_empty_set,
\    nft_common_block_define_redefine_initializer_expr_dash,
\    @nft_c_common_block_define_redefine_initializer_expr_rhs_expr,
\    nft_common_block_define_redefine_initializer_expr_list_rhs_expr

" common_block 'define'/'redefine identifier '='
hi link   nft_common_block_define_redefine_equal nftHL_Operator
syn match nft_common_block_define_redefine_equal "=" skipwhite contained
\ nextgroup=
\    @nft_c_common_block_define_redefine_initializer_expr

" common_block 'define'/'redefine identifier <STRING>
hi link   nft_common_block_define_redefine_identifier_string nftHL_Identifier
syn match   nft_common_block_define_redefine_identifier_string '\v[A-Za-z0-9_]{1,64}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_equal

" 'define' (via "
" commmon_block 'redefine' (via common_block)
hi link   nft_common_block_keyword_redefine nftHL_Command
syn match nft_common_block_keyword_redefine contained "redefine" skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_identifier_string

" common_block 'define' (via common_block)
hi link   nft_common_block_keyword_define nftHL_Command
syn match nft_common_block_keyword_define contained "define" skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_identifier_string

" common_block 'undefine' identifier (via common_block 'undefine')

hi link   nft_common_block_undefine_identifier_string nftHL_Identifier
syn match nft_common_block_undefine_identifier_string '\v[a-zA-Z][A-Za-z0-9_]{0,63}' oneline skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_UnexpectedCurlyBrace,
\    nft_EOS

hi link   nft_common_block_undefine_identifier_last nftHL_Keyword
syn match nft_common_block_undefine_identifier_last /\<last\>/ contained
\ containedin=
\    nft_common_block_undefine_identifier_string,
\    nft_common_block_define_redefine_identifier_string

" commmon_block 'undefine' (via common_block)
hi link   nft_common_block_keyword_undefine nftHL_Command
syn match nft_common_block_keyword_undefine "undefine" skipwhite contained
\ nextgroup=
\    nft_common_block_undefine_identifier_string,
\    nft_Error

" commmon_block 'error' (via common_block)
hi link   nft_common_block_keyword_error nftHL_Command
syn match nft_common_block_keyword_error "\<error\>" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error

" commmon_block 'redefine' (via common_block)
" common_block->line
" common_block->table_block
" common_block->chain_block
" common_block->counter_block
" common_block->ct_expect_block
" common_block->ct_helper_block
" common_block->ct_timeout_block
" common_block->flowtable_block
" common_block->limit_block
" common_block->map_block
" common_block->quota_block
" common_block->secmark_block
" common_block->set_block
" common_block->synproxy_block

syn cluster nft_c_common_block
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_EOL


"********** base_cmd END *************************************************

" nft_cli_comment_whole_line is not part of the Bison parser
" nft_cli_comment_whole_line parsing is done within nft CLI read loop
hi link   nft_cli_comment_whole_line nftHL_Comment
syn match nft_cli_comment_whole_line "#.*$" keepend contained
" do not use ^ regex, reserved for and by 'nft_line'

hi link   nft_line_stmt_separator nftHL_Expression
syn match nft_line_stmt_separator  "\v[;\n]{1,16}" skipwhite contained

" `line` main top-level syntax, do not add 'contained' here.
" `line` is the only syntax match/region line without a 'contained' syntax attribute
" `line` is the only syntax with '^' caret (begin of line) regex pattern"
" limit to 63-char whitespaces from 1st column (for Vim syntax session speed)
hi link   nft_line Normal
syn match nft_line "^\v\s{0,63}"
\ nextgroup=
\    @nft_c_common_block,
\    @nft_c_base_cmd,
\    nft_common_block_keyword_error,
\    nft_line_inline_comment,
\    nft_line_stmt_separator,
"\    nft_Error

"*************** END OF TOP-LEVEL SYNTAXES *****************************

"********************* END OF SYNTAX ****************************

if version >= 508 || !exists("did_nftables_syn_inits")
  delcommand HiLink
endif

let b:current_syntax = 'nftables'

let &cpoptions = s:cpo_save
unlet s:cpo_save

if main_syntax ==# 'nftables'
  unlet main_syntax
endif

" syntax_on is passed only inside Vim's shell command for 2nd Vim to observe current syntax scenarios
let g:syntax_on = 1

" Google Vimscript style guide
" vim: ts=2 sts=2 ts=80

