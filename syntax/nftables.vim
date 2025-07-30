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
  HiLink nftHL_Separator    Delimiter
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


"hi link Variable              String
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

hi link   nft_Colon nftHL_Operator
syn match nft_Colon /:/ contained

hi link   nft_InlineComment nftHL_Comment
syn match nft_InlineComment "\v\# " skipwhite contained

hi link   nft_UnexpectedSemicolon nftHL_Error
syn match nft_UnexpectedSemicolon "\v;{1,7}" contained

" === For map entries like '1 : "value"' ===
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
syn region nft_SetBlock start=/{/ end=/}/ contained
\ contains=
\    @nft_c_SetElements

syn region nft_MapBlock start=/{/ end=/}/ contained
\ contains=
\    @nft_c_MapElements

syn region nft_ElementsBlock start=/{/ end=/}/ contained
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
syn match nft_stmt_separator "\v(\n|;)" skipwhite contained

" hi link   nft_hash_comment nftHL_Error
" syn match nft_hash_comment '\v#.{15,65}$' skipwhite contained

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
syn match nft_UnexpectedIdentifierChar "\v(^[a-zA-Z0-9_\n]{1,3})" contained

" We'll do error RED highlighting on all statement firstly, then later on
" all the options, then all the clauses.
" Uncomment following two lines for RED highlight of typos (still Beta here)
hi link   nft_UnexpectedEOS nftHL_Error
syn match nft_UnexpectedEOS contained "\v[\t ]{0,2}[\#;\n]{1,2}.{0,1}" contained

hi link   nft_Error_Always nftHL_Error
syn match nft_Error_Always /[^(\n|\r)\.]\{1,15}/ skipwhite contained

syn match nft_Any_Error /\v\S+/ contained
highlight link nft_Any_Error nft_Error

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
syn match nft_variable_identifier "\v\$[a-zA-Z][a-zA-Z0-9_]{0,63}" skipwhite contained


syn match nft_datatype_arp_op "\v((request|reply|rrequest|rreply|inrequest|inreplyh|nak)|((0x)?[0-9a-fA-F]{4})|([0-9]{1,2}))" skipwhite contained
syn match nft_datatype_ct_dir "\v((original|reply)|([0-1]{1,1}))" skipwhite contained
syn match nft_datatype_ct_event "\v((new|related|destroy|reply|assured|protoinfo|helper|mark|seqadj|secmark|label)|([0-9]{1,10}))" skipwhite contained
syn match nft_datatype_ct_label "\v[0-9]{1,40}" skipwhite contained
syn match nft_datatype_ct_state "\v((invalid|established|related|new|untracked)|([0-9]{1,10}))" skipwhite contained
syn match nft_datatype_ct_status "\v((expected|seen-reply|assured|confirmed|snat|dnat|dying)|([0-9]{1,10}))" skipwhite contained
syn match nft_datatype_ether_addr "\v((8021ad|8021q|arp|ip6|ip|vlan)|((0x)?[0-9a-fA-F]{4}))" skipwhite contained
syn match nft_datatype_ether_type "\v[0-9]{1,10}" skipwhite contained
syn match nft_datatype_gid "\v[0-9]{1,10}" skipwhite contained
syn match nft_datatype_mark "\v[0-9]{1,10}" skipwhite contained
syn match nft_datatype_ip_protocol "\v((tcp|udp|udplite|esp|ah|icmpv6|icmp|comp|dccp|sctp)|([0-9]{1,3}))" skipwhite contained
syn match nft_datatype_ip_service_port "\v[0-9]{1,5}" skipwhite contained
syn match nft_datatype_ipv4_addr "\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" skipwhite contained
syn match nft_datatype_ipv6_addr /\v((([0-9a-fA-F]{1,4}:){1,7}:)|(::([0-9a-fA-F]{1,4}:){0,6}[0-9a-fA-F]{1,4})|(([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}))/ skipwhite contained
syn match nft_datatype_packet_type "\v((host|unicast|broadcast|multicast|other)|([0-9]{1,5}))" skipwhite contained
syn match nft_datatype_realm "\v((default)|([0-9]{1,10}))" skipwhite contained
syn match nft_datatype_uid "\v(([a-z_][a-z0-9A-Z\._\-]{0,31})|([0-9]{1,10}))" skipwhite contained
syn match nft_meta_expr_datatype_devgroup "\v[0-9]{1,10}" skipwhite contained
syn match nft_meta_expr_datatype_iface_index "\v[0-9]{1,10}" skipwhite contained
syn match nft_meta_expr_datatype_ifkind "\v[a-zA-Z][a-zA-Z0-9]{1,16}" skipwhite contained
syn match nft_meta_expr_datatype_ifname "\v[a-zA-Z][a-zA-Z0-9]{1,16}" skipwhite contained
syn match nft_meta_expr_datatype_iface_type "\v((ether|ppp|ipip6|ipip|loopback|sit|ipgre)|([0-9]{1,5}))" skipwhite contained
syn match nft_meta_expr_datatype_day "\v([0-8]|Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday)" skipwhite contained
syn match nft_meta_expr_datatype_hour "\v[0-2][0-9]:[0-5][0-9](:[0-5][0-9])?" skipwhite contained
syn match nft_meta_expr_datatype_time "\v(([0-9]{1,20})|iso_format)" skipwhite contained
syn match nft_payload_expr_datatype_ifname "\v[a-zA-Z][a-zA-Z0-9]{1,16}" skipwhite contained
syn match nft_payload_expr_datatype_tcp_flag "\v((fin|syn|rst|psh|ack|urg|ecn|cwr)|([0-9]{1,3}))" skipwhite contained

hi link   nft_line_stmt_separator nftHL_Expression
syn match nft_line_stmt_separator  "\v[;\n]{1,16}" skipwhite contained


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
\    nft_base_cmd_add_cmd_rule_position_chain_spec_identifier,
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

hi link   nft_common_block_stmt_separator nftHL_Expression
syn match nft_common_block_stmt_separator ";" skipwhite contained

"****************** BEGIN OF NFTABLE SYNTAX *******************************

" ************************* Begin of 'counter_cmd' *************************
"**** BEGIN OF add_cmd_/'counter'/obj_spec *****
hi link   nft_add_cmd_keyword_counter_block_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_counter_block_stmt_separator "\v(\n|;)" skipwhite contained

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_bytes_num "\v[0-9]{1,10}\ze(([ \t;])|($))" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_config_bytes nftHL_Action
syn match nft_add_cmd_keyword_counter_counter_config_bytes "\vbytes\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_config_packet_num "\v[0-9]{1,10}\ze(([ \t])|($))" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_bytes,
\    nft_Error

hi link   nft_add_cmd_counter_Error_Always nftHL_Error
syn match nft_add_cmd_counter_Error_Always "\v\i{1,15}" skipwhite contained

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_config_keyword_packets nftHL_Action
syn match nft_add_cmd_keyword_counter_counter_config_keyword_packets "\vpackets\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_packet_num,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes' <integer>
hi link   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num nftHL_Number
syn match nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num "\v[0-9]{1,10}\ze[ \t;\}\n]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_block_stmt_separator,
\    nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num> 'bytes'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_bytes nftHL_Keyword
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_bytes "\vbytes\ze[ \t]" skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_block_counter_block_counter_config_bytes_num,
\   nft_Error

" add_cmd 'counter' obj_spec counter_config 'packet' <packet_num>
hi link   nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num nftHL_Number
syn match nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_bytes,
\    nft_Error

hi link   nft_add_cmd_counter_block_Error_Always nftHL_Error
syn match nft_add_cmd_counter_block_Error_Always "\v\i{1,15}" skipwhite contained

" add_cmd 'counter' obj_spec counter_config obj_id 'packet'
hi link   nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets nftHL_Action
syn match nft_add_cmd_keyword_counter_counter_block_counter_counter_config_keyword_packets "\vpackets\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block_counter_config_packet_num,
\    nft_Error


" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec QUOTED_STRING
hi link    nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double nftHL_Comment
syn region nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double start='"' end='"' skip="\\\"" oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
hi link   nft_add_cmd_keyword_counter_counter_block_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_counter_counter_block_comment_spec "\vcomment\ze[ \t]" skipwhite contained
\ nextgroup=
\   nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double

" add_cmd 'counter' obj_spec '{' counter_block '}'
hi link    nft_add_cmd_keyword_counter_counter_block nftHL_BlockDelimitersCounter
syn region nft_add_cmd_keyword_counter_counter_block start="{" end="}" skipwhite contained
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
syn match nft_add_cmd_counter_obj_spec_obj_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}\ze(([ \t])|($))" skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_add_cmd_counter_Semicolon nftHL_Normal
syn match nft_add_cmd_counter_Semicolon contained "\v\s{0,8};" skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_add_cmd_counter_last_Error_Always nftHL_Error
syn match nft_add_cmd_counter_last_Error_Always "\v\i{1,15}" skipwhite contained

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Action
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last "\vlast\ze(([ \t])|($))" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/\_\.\-]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_add_cmd_counter_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last nftHL_Action
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_add_cmd_counter_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_counter nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_counter "\vcounter\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" ***************** END base_cmd 'counter' *****************

" ************************* Begin of 'synproxy_cmd' *************************
" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_sack nftHL_Keyword
syn match nft_synproxy_block_synproxy_sack "\vsack\-perm\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_synproxy_ts nftHL_Keyword
syn match nft_synproxy_block_synproxy_ts "\vtimestamp\ze(([ \t\;])|$)" skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_block_keyword_wscale_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipnl skipempty skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_block_keyword_wscale nftHL_Statement
syn match nft_synproxy_block_keyword_wscale "\vwscale\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_synproxy_block_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator ";" skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale "\vwscale\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale_num




" 'mss' <NUM> 'wscale' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipnl skipwhite contained
\ nextgroup=
\    nft_synproxy_block_synproxy_ts,
\    nft_synproxy_block_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale "\vwscale\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator ";" skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipnl skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_block->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss "\vmss\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error



" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss "\vmss\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss_num,
\    nft_Error

hi link    nft_add_cmd_keyword_synproxy_synproxy_block nftHL_Delimiters
syn region nft_add_cmd_keyword_synproxy_synproxy_block start=+{+ end=+}+ skip="\\\}" contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_synproxy_synproxy_block_keyword_mss,
\    nft_line_stmt_separator,
\    nft_InlineComment

"XXXXXXXXXEND SNIPXXXXXXXXXXXXXX
" 'mss' <NUM> 'wscale' [ 'timestamp' ] [ 'sack-perm' ]
" synproxy_sack->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_sack nftHL_Keyword
syn match nft_synproxy_config_synproxy_sack "\vsack\-perm\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" 'mss' <NUM> 'wscale' [ 'timestamp' ]
" synproxy_ts->synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_synproxy_ts nftHL_Keyword
syn match nft_synproxy_config_synproxy_ts "\vtimestamp\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale_num nftHL_Integer
syn match nft_synproxy_config_keyword_wscale_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_synproxy_config_keyword_wscale nftHL_Statement
syn match nft_synproxy_config_keyword_wscale "\vwscale[ \t]" skipwhite contained
\ nextgroup=
\    nft_synproxy_config_keyword_wscale_num,
\    nft_Error


hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator ";" skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_EOS,
\    nft_Error

" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num "\v[0-9]{1,5}\ze[ \t;]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale "\vwscale\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale_num




" 'mss' <NUM> 'wscale' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num "\v[0-9]{1,5}\ze(([ \t\;])|$)" skipwhite contained
\ nextgroup=
\    nft_synproxy_config_synproxy_ts,
\    nft_synproxy_config_synproxy_sack,
\    nft_line_stmt_separator,
\    nft_Error

" 'mss' <NUM> 'wscale'
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale nftHL_Statement
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale "\vwscale\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator nftHL_Separator
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator ";" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_second_keyword_wscale,
\    nft_Error

" 'mss' <NUM>
" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num nftHL_Integer
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num "\v[0-9]{1,5}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_keyword_wscale,
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_stmt_separator,
\    nft_Error

" synproxy_config->(add_cmd|create_cmd|synproxy_block)
hi link   nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss nftHL_Command
syn match nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss "\vmss\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss_num,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\.\-_]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_synproxy_synproxy_config_keyword_mss,
\    nft_add_cmd_keyword_synproxy_synproxy_block,
\    nft_Error

hi link   nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_synproxy_obj_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\.\-_]{0,63}" skipwhite contained
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
syn match nft_base_cmd_add_cmd_keyword_synproxy "\vsynproxy\ze[ \t]" skipwhite contained
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

" ************************* End of 'synproxy_cmd' *************************

" ***************** BEGIN 'add' 'flowtable' ***************

hi link   nft_flowtable_block_hook_keyword_priority_extended_int nftHL_Constant
syn match nft_flowtable_block_hook_keyword_priority_extended_int "\v\-?[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_flowtable_block_stmt_separator,
\    nft_Error

hi link   nft_flowtable_block_hook_keyword_priority_extended_var nftHL_Variable
syn match nft_flowtable_block_hook_keyword_priority_extended_var "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_c_flowtable_block_hook_keyword_priority_extended_sign nftHL_Expression
syn match nft_c_flowtable_block_hook_keyword_priority_extended_sign "\v[-+]" skipwhite contained
\ nextgroup=
\    nft_flowtable_block_hook_keyword_priority_extended_int

hi link   nft_flowtable_block_hook_keyword_priority_extended_name nftHL_Action
syn match nft_flowtable_block_hook_keyword_priority_extended_name "\v[a-zA-Z][a-zA-Z]{1,16}" skipwhite contained
\ nextgroup=
\     nft_c_flowtable_block_hook_keyword_priority_extended_sign

hi link   nft_flowtable_block_hook_keyword_priority nftHL_Action
syn match nft_flowtable_block_hook_keyword_priority "\vpriority\ze\s" skipwhite contained
\ nextgroup=
\    nft_flowtable_block_hook_keyword_priority_extended_int,
\    nft_flowtable_block_hook_keyword_priority_extended_var,
\    nft_flowtable_block_hook_keyword_priority_extended_name,
\    nft_Error

hi link    nft_flowtable_block_hook_identifier_quoted_double nftHL_Identifier
syn region nft_flowtable_block_hook_identifier_quoted_double start='"' end='"' skip="\\\"" oneline skipwhite contained
\ nextgroup=
\    nft_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link    nft_flowtable_block_hook_identifier_quoted_single nftHL_Identifier
syn region nft_flowtable_block_hook_identifier_quoted_single start="'" end="'" skip="\\\'" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_flowtable_block_hook_unquoted_identifier nftHL_Identifier
syn match nft_flowtable_block_hook_unquoted_identifier "\v[a-zA-Z0-9]{1,64}\ze[ \t\n]+priority" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_flowtable_block_hook_keyword_priority,
\    nft_Error

hi link   nft_flowtable_block_stmt_separator nftHL_Operator
syn match nft_flowtable_block_stmt_separator ";" skipwhite contained

" base_cmd_add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_create_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_delete_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" base_cmd_destroy_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
" table_block 'flowtable' flowtable_spec '{' flowtable_block 'hook'
hi link   nft_flowtable_block_hook nftHL_Statement
syn match nft_flowtable_block_hook "\v[{ ;]\zshook\ze[ \t]" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_flowtable_block_hook_identifier_quoted_double,
\    nft_flowtable_block_hook_identifier_quoted_single,
\    nft_flowtable_block_hook_unquoted_identifier,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list flowtable_flag
hi link   nft_flowtable_block_flags_flowtable_flag_list_flowtable_flag nftHL_Action
syn match nft_flowtable_block_flags_flowtable_flag_list_flowtable_flag skipwhite contained
\ "\v(offload)"
\ nextgroup=
\    nft_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list
syn cluster nft_c_flowtable_block_flowtable_flag_list
\ contains=
\    nft_flowtable_block_flags_flowtable_flag_list_flowtable_flag

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags'
hi link   nft_flowtable_block_flags nftHL_Statement
syn match nft_flowtable_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block_flowtable_flag_list,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flowtable_block_expr->'='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'counter'
hi link   nft_flowtable_block_counter nftHL_Statement
syn match nft_flowtable_block_counter "counter" skipwhite contained
\ nextgroup=
\    nft_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error


hi link   nft_flowtable_expr_comma nftHL_Expression
syn match nft_flowtable_expr_comma "," skipwhite contained

hi link   nft_flowtable_expr_unquoted_string nftHL_String
syn match nft_flowtable_expr_unquoted_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_flowtable_expr_unquoted_identifier nftHL_Identifier
syn match nft_flowtable_expr_unquoted_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link    nft_flowtable_expr_quoted_string_single nftHL_String
syn region nft_flowtable_expr_quoted_string_single start="\'" end="\'" skip="\\\'" skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link    nft_flowtable_expr_quoted_string_double nftHL_String
syn region nft_flowtable_expr_quoted_string_double start="\"" end="\"" skip="\\\"" skipwhite contained
\ contains=
\    nft_flowtable_expr_unquoted_string
\ nextgroup=
\    nft_flowtable_expr_comma

hi link   nft_flowtable_expr_variable_expr nftHL_Variable
syn match nft_flowtable_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_comma

syn cluster nft_c_flowtable_expr_member
\ contains=
\    nft_flowtable_expr_variable_expr,
\    nft_flowtable_expr_quoted_string_single,
\    nft_flowtable_expr_quoted_string_double,
\    nft_flowtable_expr_unquoted_identifier

hi link    nft_flowtable_expr_block nftHL_BlockDelimitersFlowtable
syn region nft_flowtable_expr_block start="{" end="}" skipwhite contained
\ contains =
\    @nft_c_flowtable_expr_member

hi link   nft_flowtable_expr_variable nftHL_Variable
syn match nft_flowtable_expr_variable "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained




" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '='
" '='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_flowtable_block_devices_equal nftHL_Expression
syn match nft_flowtable_block_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_flowtable_expr_variable,
\    nft_flowtable_expr_block,

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices'
" 'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_flowtable_block_devices nftHL_Statement
syn match nft_flowtable_block_devices "devices" skipwhite contained
\ nextgroup=
\    nft_flowtable_block_devices_equal

" ';'->flowtable_block->'{'->'flowtable'
hi link   nft_flowtable_block_separator nftHL_Separator
syn match nft_flowtable_block_separator ";" skipwhite contained
\ nextgroup=
\    @nft_c_flowtable_block

syn cluster nft_c_flowtable_block
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_flowtable_block_counter,
\    nft_flowtable_block_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_flowtable_block_flags,
\    nft_flowtable_block_hook,
\    nft_flowtable_block_stmt_separator,




" [ 'add' ] 'flowtable' table_id flow_id '{' flowtable_block
" flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link    nft_flowtable_spec_flowtable_block nftHL_BlockDelimitersFlowTable
syn region nft_flowtable_spec_flowtable_block start="{" end="}" skipwhite contained
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_flowtable_spec_flowtable_block_counter,
\    nft_flowtable_spec_flowtable_block_devices,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_flowtable_spec_flowtable_block_flags,
\    nft_flowtable_spec_flowtable_block_hook,
\    @nft_c_flowtable_block,
\    nft_flowtable_block_stmt_separator,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec identifier (chain)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable nftHL_Chain
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}\ze\s" skipwhite contained
\ nextgroup=
\    nft_flowtable_spec_flowtable_block,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}\ze\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_identifier_flowtable,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ "\v(ip(6)?|inet|arp|bridge|netdev)\ze\s"
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
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_quoted_string /\v\"[a-zA-Z][a-zA-Z0-9]{1,64}\"\ze($|\s|;|,|\})/ skipwhite contained
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

" Bad tokens inside braces: anything not starting with alnum, ', or "
" hi link   nft_define_undefine_keywords_block_BadToken nftHL_Error
" syntax match nft_define_undefine_keywords_block_BadToken /\v\{\s*\zs[^a-zA-Z0-9\'\" ]+/ contained
" \ containedin=nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block

"hi link   nft_initializer_BadToken nftHL_Error
"syntax match nft_initializer_BadToken /\v\{\s*\zs[^a-zA-Z0-9_'" ]\s{0,16}/ contained
"\ containedin=nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block

"*************** BEGIN OF SECOND-LEVEL SYNTAXES *****************************
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
\    nft_error

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
\    nft_error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_unquoted_identifier /\v[a-zA-Z][a-zA-Z0-9]{0,63}\ze\s*:/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_unquoted_identifier_colon,
\    nft_Error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma nftHL_Element
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_list_comma ',' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr,
\    nft_error

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
\    nft_error

hi link   nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr nftHL_Identifier
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_key_integer_expr '\v[0-9]{0,11}\ze\s{0,10}:' skipwhite contained
\ nextgroup=
\    nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_map_integer_expr_colon,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_unexpected_symbol nftHL_Error
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_unexpected_symbol /[,;\$`~!@\#%]/ skipwhite contained


 " no quoted_string for map key
hi link    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block nftHL_SpecialComment
syn region nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block start=+{+ end=+}+ oneline skipwhite contained
\ contains=
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
"\ nextgroup=
"\    nft_empty_set,
"\    nft_common_block_stmt_separator,
"\    nft_initializer_BadToken,
"\    nft_Error
hi link   nft_describe_keyword_primary_expr_payload_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_payload_expr "(arp_op|arp hlen|arp htype|ar operation|arp plen|ether_addr|tcp|udp)\ze[ \t]" skipwhite contained

hi link   nft_describe_keyword_primary_expr_meta_expr nftHL_Command
syn match nft_describe_keyword_primary_expr_meta_expr "iifgroup" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "iifkind" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "iifname" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "iiftype" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "iif" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "oifgroup" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "oifkind" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "oifname" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "oiftype" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "oif" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "iif" skipwhite contained
syn match nft_describe_keyword_primary_expr_meta_expr "(day|ether_type|houriif|time)\ze[ \t]" skipwhite contained

hi link   nft_base_cmd_keyword_describe nftHL_Command
syn match nft_base_cmd_keyword_describe "\vdescribe\ze[ \t]" oneline skipwhite contained
\ nextgroup=
\    nft_describe_keyword_primary_expr_datatype,
\    nft_describe_keyword_primary_expr_payload_expr,
\    nft_describe_keyword_primary_expr_meta_expr

"*************** END OF SECOND-LEVEL SYNTAXES *******************************



"*************** END OF FIRST-LEVEL & SECOND-LEVEL SYNTAXES ****************************

"*************** BEGIN OF TOP-LEVEL SYNTAXES ****************************



" **************** BEGIN destroy_cmd ***************
hi link   nft_destroy_cmd_keyword_chain_chainid_spec_num nftHL_Handle
syn match nft_destroy_cmd_keyword_chain_chainid_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.]{0,63}" skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle nftHL_Action
syn match nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle "handle" skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_num

hi link   nft_destroy_cmd_keyword_chain_chain_spec_keyword_last nftHL_Action
syn match nft_destroy_cmd_keyword_chain_chain_spec_keyword_last "last" skipwhite contained

hi link   nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.]{0,63}" skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_keyword_last nftHL_Action
syn match nft_destroy_cmd_keyword_chain_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_destroy_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_chain_spec_identifier_string_chain

hi link   nft_destroy_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_destroy_cmd_keyword_chain_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain nftHL_Statement
syn match nft_destroy_cmd_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    nft_destroy_cmd_keyword_chain_table_spec_family_spec,
\    nft_destroy_cmd_keyword_chain_table_spec_keyword_last,
\    nft_destroy_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" add_cmd 'destroy' table_identifier [ obj_id | 'last' ]
hi link   nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id nftHL_Identifier
syn match nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}\ze(([ \t;])|($))" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_line_stmt_separator,
\    nft_Error

hi link   nft_base_cmd_keyword_counter_keyword_table_Semicolon nftHL_Normal
syn match nft_base_cmd_keyword_counter_keyword_table_Semicolon contained "\v\s{0,8};" skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_comment_inline

hi link   nft_base_cmd_keyword_counter_keyword_table_last_Error_Always nftHL_Error
syn match nft_base_cmd_keyword_counter_keyword_table_last_Error_Always "\v\i{1,15}" skipwhite contained

syn cluster nft_c_add_cmd_keyword_counter_obj_spec_obj_last
\ contains=
\    nft_add_cmd_keyword_counter_counter_block,
\    nft_add_cmd_keyword_counter_counter_config_keyword_packets,
\    nft_line_stmt_separator

hi link   nft_add_cmd_keyword_counter_obj_spec_identifier_last nftHL_Action
syn match nft_add_cmd_keyword_counter_obj_spec_identifier_last "last" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec_obj_last

" add_cmd 'counter' obj_spec obj_id table_spec table_id
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id nftHL_Identifier
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last nftHL_Action
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_identifier_last,
\    nft_base_cmd_keyword_counter_keyword_table_obj_spec_obj_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" _add_ to make 'chain_spec' pathway unique
hi link   nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" base_cmd add_cmd 'counter' obj_spec
syn cluster nft_c_add_cmd_keyword_counter_obj_spec
\ contains=
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id_keyword_last,
\    nft_add_cmd_keyword_counter_obj_spec_table_spec_table_id,

" 'counter'->add_cmd->base_cmd->line
hi link   nft_add_cmd_keyword_table nftHL_Command
syn match nft_add_cmd_keyword_table "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_counter_obj_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS




" ****************** BEGIN destroy_cmd/delete_cmd ***********************
" 'delete' 'table' [ ip|ip6|inet|netdev|bridge|arp ] identifier
" 'last'->identifier->table_spec->table_or_id_spec->'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier nftHL_Identifier
syn match nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedIdentifierChar,
\    nft_UnexpectedEOS,
\    nft_Error

" 'delete' 'table' [ ip|ip6|inet|netdev|bridge|arp ] 'last'
" 'last'->identifier->table_spec->table_or_id_spec->'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'delete' 'table' 'handle' <NUM>
" <NUM>->'handle'->'table'->delete_cmd->'delete'->base_cmd->line
" <NUM>->tableid_spec->table_or_id_spec->'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle_num nftHL_Number
syn match nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle_num "\v[0-9]{1,10}" skipwhite contained

" 'delete' 'table' 'handle'
" 'handle'>tableid_spec->table_or_id_spec->'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle "\vhandle\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_table_table_or_id_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_table_table_or_id_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle,
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_keyword_last,
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry"
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'delete' 'table'
" 'table'->delete_cmd->'delete'->base_cmd->line
hi link   nft_base_cmd_destroy_delete_cmds_keyword_table nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_table "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_table_table_or_id_spec_family_spec,
\    nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle,
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_keyword_last,
\    nft_delete_cmd_keyword_table_table_or_id_spec_table_spec_identifier,  " last match entry"
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_chainid_spec_num nftHL_Handle
syn match nft_delete_cmd_keyword_chain_chainid_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain nftHL_Table
syn match nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_chainid_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_chain_chainid_spec_keyword_handle "handle" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_chainid_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_chain_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_chain_chain_spec_keyword_last "last" skipwhite contained

hi link   nft_delete_cmd_keyword_chain_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_chain_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_delete_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_chain_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_chainid_spec_keyword_handle,
\    nft_delete_cmd_keyword_chain_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_chain_chain_spec_identifier_string_chain,
\    nft_Error

hi link   nft_delete_cmd_keyword_chain_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_chain_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_table_spec_keyword_last,
\    nft_delete_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_destroy_cmd_keyword_chain nftHL_Statement
syn match nft_destroy_cmd_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_chain_table_spec_family_spec,
\    nft_delete_cmd_keyword_chain_table_spec_keyword_last,
\    nft_delete_cmd_keyword_chain_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num nftHL_Number
syn match nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle "handle" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain nftHL_Chain
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_keyword_handle,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_rule nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_rule "\vrule\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_keyword_last,
\    nft_delete_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_set_setid_spec_num nftHL_Handle
syn match nft_delete_cmd_keyword_set_setid_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_set_set_spec_identifier_string_set nftHL_Table
syn match nft_delete_cmd_keyword_set_set_spec_identifier_string_set "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_delete_cmd_keyword_set_setid_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_set_setid_spec_keyword_handle "\vhandle\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_setid_spec_num,
\    nft_Error

hi link   nft_delete_cmd_keyword_set_set_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_set_set_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained

hi link   nft_delete_cmd_keyword_set_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_set_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_setid_spec_keyword_handle,
\    nft_delete_cmd_keyword_set_set_spec_keyword_last,
\    nft_delete_cmd_keyword_set_set_spec_identifier_string_set

hi link   nft_delete_cmd_keyword_set_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_set_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_setid_spec_keyword_handle,
\    nft_delete_cmd_keyword_set_set_spec_keyword_last,
\    nft_delete_cmd_keyword_set_set_spec_identifier_string_set

hi link   nft_delete_cmd_keyword_set_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_set_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_table_spec_keyword_last,
\    nft_delete_cmd_keyword_set_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_set nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_set "\vset\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_set_table_spec_family_spec,
\    nft_delete_cmd_keyword_set_table_spec_keyword_last,
\    nft_delete_cmd_keyword_set_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_map_spec_identifier_string_map nftHL_Table
syn match nft_delete_cmd_keyword_map_map_spec_identifier_string_map "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_delete_cmd_keyword_map_map_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_map_map_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_delete_cmd_keyword_map_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_map_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_map_spec_keyword_last,
\    nft_delete_cmd_keyword_map_map_spec_identifier_string_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_map_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_map_spec_keyword_last,
\    nft_delete_cmd_keyword_map_map_spec_identifier_string_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_map_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_map_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_table_spec_keyword_last,
\    nft_delete_cmd_keyword_map_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_map nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_map "\vmap\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_map_table_spec_family_spec,
\    nft_delete_cmd_keyword_map_table_spec_keyword_last,
\    nft_delete_cmd_keyword_map_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_set_spec_identifier_string_element nftHL_Table
syn match nft_delete_cmd_keyword_element_set_spec_identifier_string_element "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_set_expr

hi link   nft_delete_cmd_keyword_element_set_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_element_set_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_set_expr

hi link   nft_delete_cmd_keyword_element_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_element_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_set_spec_keyword_last,
\    nft_delete_cmd_keyword_element_set_spec_identifier_string_element,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_element_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_set_spec_keyword_last,
\    nft_delete_cmd_keyword_element_set_spec_identifier_string_element,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_element_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_element_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_table_spec_keyword_last,
\    nft_delete_cmd_keyword_element_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_element nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_element "\velement\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_element_table_spec_family_spec,
\    nft_delete_cmd_keyword_element_table_spec_keyword_last,
\    nft_delete_cmd_keyword_element_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flowtableflowtableflowtable
hi link   nft_delete_cmd_keyword_flowtable_flowtableid_spec_num nftHL_Handle
syn match nft_delete_cmd_keyword_flowtable_flowtableid_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable nftHL_Table
syn match nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_flowtable_spec_flowtable_block

hi link   nft_delete_cmd_keyword_flowtable_flowtableid_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_flowtable_flowtableid_spec_keyword_handle "\vhandle\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_flowtableid_spec_num

hi link   nft_delete_cmd_keyword_flowtable_flowtable_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_flowtable_flowtable_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_flowtable_flowtable_spec_flowtable_block

hi link   nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_flowtableid_spec_keyword_handle,
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable,

hi link   nft_delete_cmd_keyword_flowtable_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_flowtable_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_flowtableid_spec_keyword_handle,
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_flowtable_spec_identifier_string_flowtable

hi link   nft_delete_cmd_keyword_flowtable_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_flowtable_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_table_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_flowtable nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_flowtable "\vflowtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_flowtable_table_spec_family_spec,
\    nft_delete_cmd_keyword_flowtable_table_spec_keyword_last,
\    nft_delete_cmd_keyword_flowtable_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" flowtableflowtableflowtable

hi link   nft_delete_cmd_keyword_counter_objid_spec_num nftHL_Handle
syn match nft_delete_cmd_keyword_counter_objid_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_delete_cmd_keyword_counter_obj_spec_identifier_string_counter nftHL_Table
syn match nft_delete_cmd_keyword_counter_obj_spec_identifier_string_counter "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_delete_cmd_keyword_counter_objid_spec_keyword_handle nftHL_Action
syn match nft_delete_cmd_keyword_counter_objid_spec_keyword_handle "\vhandle\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_objid_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_counter_obj_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_counter_obj_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained

hi link   nft_delete_cmd_keyword_counter_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_counter_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_objid_spec_keyword_handle,
\    nft_delete_cmd_keyword_counter_obj_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_obj_spec_identifier_string_counter,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_counter_table_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_counter_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_objid_spec_keyword_handle,
\    nft_delete_cmd_keyword_counter_obj_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_obj_spec_identifier_string_set

hi link   nft_delete_cmd_keyword_counter_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_counter_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_counter nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_counter "\vcounter\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_family_spec,
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_quota nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_quota "\vquota\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_family_spec,
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_ct_set_spec_identifier_string_ct nftHL_Table
syn match nft_delete_cmd_keyword_ct_set_spec_identifier_string_ct "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_delete_cmd_keyword_ct_set_spec_keyword_last nftHL_Action
syn match nft_delete_cmd_keyword_ct_set_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained

hi link   nft_delete_cmd_keyword_ct_table_spec_identifier_string_table nftHL_Table
syn match nft_delete_cmd_keyword_ct_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_ct_set_spec_keyword_last,
\    nft_delete_cmd_keyword_ct_set_spec_identifier_string_ct
hi link   nft_delete_cmd_keyword_ct_table_spec_keyword_last nftHL_Action

syn match nft_delete_cmd_keyword_ct_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_ct_set_spec_keyword_last,
\    nft_delete_cmd_keyword_ct_set_spec_identifier_string_ct

hi link   nft_delete_cmd_keyword_ct_table_spec_family_spec nftHL_Family
syn match nft_delete_cmd_keyword_ct_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_ct_table_spec_keyword_last,
\    nft_delete_cmd_keyword_ct_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_delete_cmd_keyword_ct_obj_type_keywords nftHL_Statement
syn match nft_delete_cmd_keyword_ct_obj_type_keywords "\v(expectation|helper|timeout)" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_ct_table_spec_family_spec,
\    nft_delete_cmd_keyword_ct_table_spec_keyword_last,
\    nft_delete_cmd_keyword_ct_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_ct nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_ct "\vct\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_ct_obj_type_keywords,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_limit nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_limit "\vlimit\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_family_spec,
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_secmark nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_secmark "\vsecmark\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_family_spec,
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_destroy_delete_cmds_keyword_synproxy nftHL_Statement
syn match nft_base_cmd_destroy_delete_cmds_keyword_synproxy "\vsynproxy\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_delete_cmd_keyword_counter_table_spec_family_spec,
\    nft_delete_cmd_keyword_counter_table_spec_keyword_last,
\    nft_delete_cmd_keyword_counter_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" 'delete'->base_cmd->line
hi link   nft_base_cmd_keyword_delete nftHL_Command
syn match nft_base_cmd_keyword_delete "\vdelete\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_base_cmd_destroy_delete_cmds_keyword_flowtable,
\    nft_base_cmd_destroy_delete_cmds_keyword_synproxy,
\    nft_base_cmd_destroy_delete_cmds_keyword_element,
\    nft_base_cmd_destroy_delete_cmds_keyword_secmark,
\    nft_base_cmd_destroy_delete_cmds_keyword_counter,
\    nft_base_cmd_delete_cmd_keyword_chain,
\    nft_base_cmd_destroy_delete_cmds_keyword_table,
\    nft_base_cmd_destroy_delete_cmds_keyword_limit,
\    nft_base_cmd_destroy_delete_cmds_keyword_quota,
\    nft_base_cmd_destroy_delete_cmds_keyword_rule,
\    nft_base_cmd_destroy_delete_cmds_keyword_set,
\    nft_base_cmd_destroy_delete_cmds_keyword_map,
\    nft_base_cmd_destroy_delete_cmds_keyword_ct,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" 'destroy'->base_cmd->line
hi link   nft_base_cmd_keyword_destroy nftHL_Command
syn match nft_base_cmd_keyword_destroy "\vdestroy\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_base_cmd_destroy_delete_cmds_keyword_flowtable,
\    nft_base_cmd_destroy_delete_cmds_keyword_synproxy,
\    nft_base_cmd_destroy_delete_cmds_keyword_element,
\    nft_base_cmd_destroy_delete_cmds_keyword_secmark,
\    nft_base_cmd_destroy_delete_cmds_keyword_counter,
\    nft_base_cmd_destroy_cmd_keyword_chain,
\    nft_base_cmd_destroy_delete_cmds_keyword_table,
\    nft_base_cmd_destroy_delete_cmds_keyword_limit,
\    nft_base_cmd_destroy_delete_cmds_keyword_quota,
\    nft_base_cmd_destroy_delete_cmds_keyword_rule,
\    nft_base_cmd_destroy_delete_cmds_keyword_set,
\    nft_base_cmd_destroy_delete_cmds_keyword_map,
\    nft_base_cmd_destroy_delete_cmds_keyword_ct,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" **************** END delete_cmd/destroy_cmd ***************

" **************** START element_cmd ***************

" base_cmd add_cmd 'element' set_block_expr '{' comment_spec 'comment' QUOTED_STRING
hi link    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_Comment
syn region nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec start='"' end='"' skip="\\\"" oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'element' set_block_expr '{' A : B comment_spec '}'
hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec "\vcomment\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier "\v[a-zA-Z][a-zA-Z0-9_]{0,63}\ze[ \t,\}\n]" skipwhite contained

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}\ze[ \t,\}\n]" skipwhite contained

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue "\vcontinue\ze[ \t,\}]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return "\vreturn\ze[ \t,\}]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept "\vaccept\ze[ \t,\}]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop "\vdrop\ze[ \t,\}]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump "\vjump\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto "\vgoto\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_variable_expr,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_verdict_expr_chain_expr_identifier


hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator nftHL_Element
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator /:/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_continue,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_return,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_accept,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_drop,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_goto,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_rhs_expr_verdict_expr_keyword_jump,


hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec nftHL_String
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec "\v[0-9]{1,5}(d|h|m|s|ms|us|ns){1,7}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option nftHL_Keyword
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option "\v(timeout|expires)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_time_spec,

hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP nftHL_String
syn match nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP "\v[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option,
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_colon_separator

hi link    nft_add_cmd_keyword_element_set_block_expr_set_spec_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_keyword_element_set_block_expr_set_spec_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_unquoted_identifier_IP,
\    nft_Error
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable nftHL_Variable
syn match nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable "\v\$[a-zA-Z][a-zA-Z0-9_\.\-]{0,63}\ze[ \t;]" skipwhite contained
\ contains=
\    nft_line_stmt_separator

hi link   nft_add_cmd_keyword_element_set_spec_set_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_element_set_spec_set_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable,
\    nft_add_cmd_keyword_element_set_block_expr_set_spec_block,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last nftHL_Action
syn match nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_block_expr_variable_expr_variable,
\    nft_add_cmd_keyword_element_set_block_expr_set_spec_block,
\    nft_add_cmd_keyword_element_set_spec_block,
\    nft_variable_identifier,
\    nft_Error

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table nftHL_Table
syn match nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_set_spec_identifier

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last nftHL_Action
syn match nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_set_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_set_spec_identifier

hi link   nft_add_cmd_keyword_element_set_spec_table_spec_family_spec nftHL_Family
syn match nft_add_cmd_keyword_element_set_spec_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last,
\    nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link nft_base_cmd_add_cmd_keyword_element nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_element "\velement\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_element_set_spec_table_spec_identifier_string_table,
\    nft_add_cmd_keyword_element_set_spec_table_spec_family_spec,
\    nft_add_cmd_keyword_element_set_spec_table_spec_keyword_last,
\    nft_Error
" **************** END element_cmd ***************

" **************** START monitor_cmd ***************
" monitor_event (via monitor_cmd)
hi link   nft_monitor_cmd_monitor_format_keyword_xml nftHL_Action
syn match nft_monitor_cmd_monitor_format_keyword_xml "\vxml\ze[ \t;\n]" skipwhite keepend contained

hi link   nft_monitor_cmd_monitor_format_keyword_json nftHL_Action
syn match nft_monitor_cmd_monitor_format_keyword_json "\vjson\ze[ \t;\n]" skipwhite keepend contained

hi link   nft_monitor_cmd_monitor_format_keyword_vm_keyword_json nftHL_Action
syn match nft_monitor_cmd_monitor_format_keyword_vm_keyword_json "\vvm\s+json\ze[ \t;\n]" skipwhite keepend contained

" monitor_cmd monitor_object (via monitor_cmd)
hi link   nft_monitor_cmd_monitor_object_keyword_elements nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_elements "\velements\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_ruleset nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_ruleset "\vruleset\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_chains nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_chains "\vchains\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_tables nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_tables "\vtables\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_rules nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_rules "\vrules\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_trace nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_trace "\vtrace\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

hi link   nft_monitor_cmd_monitor_object_keyword_sets nftHL_Statement
syn match nft_monitor_cmd_monitor_object_keyword_sets "\vsets\ze[ \t;\n]" skipwhite contained
\ nextgroup=
\    nft_monitor_cmd_monitor_format_keyword_json,
\    nft_monitor_cmd_monitor_format_keyword_xml,
\    nft_monitor_cmd_monitor_format_keyword_vm_keyword_json

" monitor_cmd monitor_event (via base_cmd)
hi link   nft_monitor_cmd_monitor_event_keyword_destroy nftHL_Action
syn match nft_monitor_cmd_monitor_event_keyword_destroy "\vdestroy\ze[ \t]" skipwhite contained
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

hi link   nft_monitor_cmd_monitor_event_keyword_new nftHL_Action
syn match nft_monitor_cmd_monitor_event_keyword_new "\vnew\ze[ \t]" skipwhite contained
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
syn match nft_base_cmd_keyword_monitor "\vmonitor\ze[ \t]" skipwhite contained
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

" **************** START replace_cmd ***************
" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier rule
syn cluster nft_c_base_cmd_replace_rule_alloc_stmt
\ contains=
\    @nft_c_payload_stmt,
\    @nft_c_stmt,
\    @nft_c_base_cmd_replace_rule_alloc_stmt

syn cluster nft_c_base_cmd_replace_rule_alloc
\ contains=
\    @nft_c_base_cmd_replace_rule_alloc_stmt,
\    @nft_comment_spec

syn cluster nft_c_base_cmd_replace_rule
\ contains=
\    @nft_c_base_cmd_replace_rule_alloc

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id nftHL_Handle
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id "\v[0-9]{1,9}" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_replace_rule,
\    nft_line_stmt_separator,
\    nft_Error

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier handle_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index nftHL_Action
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index "\v(position|index|handle)\s" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_handle_id

" base_cmd 'replace' [ family_spec ] table_identifier chain_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id nftHL_Chain
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id "\v[a-zA-Z0-9\\\/_\.\-]{1,64}\s+" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_keywords_handle_position_index,
\    @nft_c_payload_stmt
"\    nft_ip_hdr_expr via @nft_c_payload_stmt
"\    @nft_c_rule

" base_cmd 'replace' [ family_spec ] table_identifier
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id nftHL_Table
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id "\v[a-zA-Z0-9\\\/_\.\-]{1,64}\s+" contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_chain_id,

" base_cmd 'replace' family_spec
hi link   nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family nftHL_Family
syn match nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family "\v(ip6|ip|inet|bridge|netdev|arp)\s+" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id,
\    nft_UnexpectedIdentifierChar,

" base_cmd 'replace' [ family_spec ]
syn cluster nft_c_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec
\ contains=
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_family_spec_family,
\    nft_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec_table_id

" base_cmd 'replace' 'rule'
hi link   nft_replace_cmd_keyword_rule nftHL_Statement
syn match nft_replace_cmd_keyword_rule "rule" skipwhite contained
\ nextgroup=
\    @nft_c_replace_cmd_keyword_rule_ruleid_spec_chain_spec_table_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'replace'
hi link   nft_base_cmd_keyword_replace nftHL_Statement
syn match nft_base_cmd_keyword_replace "\vreplace" skipwhite contained
\ nextgroup=
\    nft_replace_cmd_keyword_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** replace_cmd END *****************

" ***************** BEGIN 'add' 'rule' ***************

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_identifier nftHL_Table
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\.-]{0,63}\ze[ \t]" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier nftHL_Table
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9_\.-]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip "ip" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp "arp" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 "ip6" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet "inet" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev "netdev" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge "bridge" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

syn cluster nft_c_add_cmd_rule_rule_alloc_again
\ contains=@nft_c_add_cmd_rule_rule_alloc_alloc

" base_cmd [ 'add' ] 'rule' rule_alloc comment_spec
hi link   nft_add_cmd_rule_comment_spec_string nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_string "\v[A-Za-z0-9 ]{1,64}" skipwhite contained
" TODO A BUG? What is a 'space' doing in comment?"

hi link   nft_add_cmd_rule_comment_spec_comment nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_comment "\vcomment\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_comment_spec_string

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule_alloc
\ contains=
\    nft_add_cmd_rule_comment_spec_comment,
\    @nft_c_stmt

" base_cmd [ 'add' ] 'rule' rule
syn cluster nft_c_add_cmd_rule_rule
\ contains=
\    @nft_c_add_cmd_rule_rule_alloc



" 'rule'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_rule nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_rule "\vrule\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_family_spec_explicit,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_identifier

syn cluster nft_c_rule_alloc
\ contains=
\    @nft_c_stmt

syn cluster nft_c_rule
\ contains=
\    @nft_c_rule_alloc
"***************** END rule/'add_cmd'/'base_cmd' *****************

"***************** BEGIN list_cmd *************************
" base_cmd list_cmd 'table' table_spec family_spec identifier
hi link   nft_list_table_spec_identifier_string nftHL_Identifier
syn match nft_list_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd list_cmd 'table' table_spec family_spec 'last'
hi link   nft_list_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_table_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained

" base_cmd list_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_list_table_spec_family_spec_valid nftHL_Family  " _add_ to make 'table_spec' pathway unique
syn match nft_list_table_spec_family_spec_valid "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_list_table_spec_identifier_keyword_last,
\    nft_list_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'table' ] table_spec
syn cluster nft_c_list_table_spec_end
\ contains=
\    nft_list_table_spec_family_spec_valid,
\    nft_list_table_spec_identifier_keyword_last,
\    nft_list_table_spec_identifier_string

" base_cmd list_cmd 'table'
hi link   nft_base_cmd_list_keyword_table_end nftHL_Command
syn match nft_base_cmd_list_keyword_table_end "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_list_table_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec nftHL_Family
syn match nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained

" base_cmd list_cmd 'table'
hi link   nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end nftHL_Command
syn match nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end "\v(tables|chains|ruleset|meters|flowtables|maps)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_tables_chains_ruleset_meters_flowtables_maps_ruleset_spec,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd list_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_list_chain_spec_identifier_string nftHL_Identifier
syn match nft_list_chain_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_chain_spec_identifier_keyword_last nftHL_Action
syn match nft_list_chain_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained

" base_cmd list_cmd 'chain' [ family_spec ] table_spec
hi link   nft_list_chain_table_spec_identifier_string nftHL_Identifier
syn match nft_list_chain_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_chain_spec_identifier_keyword_last,
\    nft_list_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_chain_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_chain_table_spec_identifier_keyword_last "\vlast\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_list_chain_spec_identifier_keyword_last,
\    nft_list_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" list_cmd 'chain' chain_spec family_spec family_spec_explicit
hi link   nft_list_chain_spec_family_spec_explicit nftHL_Family
syn match nft_list_chain_spec_family_spec_explicit "\v(ip(6)?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_list_chain_table_spec_identifier_keyword_last,
\    nft_list_chain_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd list_cmd 'chain' chain_spec
syn cluster nft_c_list_cmd_chain_spec_end
\ contains=
\    nft_list_chain_table_spec_identifier_keyword_last,
\    nft_list_chain_spec_family_spec_explicit,
\    nft_list_chain_table_spec_identifier_string

" base_cmd list_cmd 'chain'
" base_cmd [ 'list' ] [ 'chain' ] chain_spec
hi link   nft_base_cmd_list_keyword_chain_end nftHL_Command
syn match nft_base_cmd_list_keyword_chain_end "\vchain\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_chain_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_ruleset_spec nftHL_Family
syn match nft_list_cmd_keywords_sets_et_al_ruleset_spec  "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained

" 'list' ('sets'|'counters'|'quotas'|'limits'|'secmarks'|'synproxys')
hi link   nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table nftHL_Table
syn match nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last  "last" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit  "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last,
\    nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keywords_sets_et_al_keyword_table nftHL_Statement
syn match nft_list_cmd_keywords_sets_et_al_keyword_table "table" skipwhite contained
\ nextgroup=
\     nft_list_cmd_keywords_sets_et_al_table_spec_family_spec_explicit,
\     nft_list_cmd_keywords_sets_et_al_table_spec_identifier_keyword_last,
\     nft_list_cmd_keywords_sets_et_al_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'list' ('sets'|'counters'|'quotas'|'limits'|'secmarks'|'synproxys')
hi link   nft_base_cmd_list_keywords_sets_et_al_end nftHL_Statement
syn match nft_base_cmd_list_keywords_sets_et_al_end "\v(sets|counters|quotas|limits|secmarks|synproxys)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keywords_sets_et_al_ruleset_spec,
\    nft_list_cmd_keywords_sets_et_al_keyword_table,

" base_cmd list_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_list_set_chain_spec_identifier_string nftHL_Identifier
syn match nft_list_set_chain_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_list_set_chain_spec_identifier_keyword_last nftHL_Action
syn match nft_list_set_chain_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" list_cmd 'set' set_spec family_spec family_spec_explicit
hi link   nft_list_set_table_spec_identifier_string nftHL_Identifier
syn match nft_list_set_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_set_chain_spec_identifier_keyword_last,
\    nft_list_set_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_set_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_set_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_set_chain_spec_identifier_keyword_last,
\    nft_list_set_chain_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_set_spec_family_spec_explicit nftHL_Family
syn match nft_list_set_spec_family_spec_explicit "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_list_set_table_spec_identifier_keyword_last,
\    nft_list_set_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd list_cmd 'set' set_spec
syn cluster nft_c_list_cmd_set_spec_end
\ contains=
\    nft_list_set_table_spec_identifier_keyword_last,
\    nft_list_set_table_spec_identifier_string,
\    nft_list_set_spec_family_spec_explicit

" 'list' ('counter'|'quota'|'limit'|'secmark'|'synproxy') obj_spec
hi link   nft_list_cmd_keywords_counter_et_al_obj_spec nftHL_Statement
syn match nft_list_cmd_keywords_counter_et_al_obj_spec "\v(counter|quota|limit|secmark|synproxy)\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error


" base_cmd [ 'list' ] [ 'set' ] set_spec
" base_cmd [ 'list' ] [ 'map' ] set_spec
" base_cmd [ 'list' ] [ 'meter' ] set_spec
hi link   nft_base_cmd_list_set_map_meter_end nftHL_Command
syn match nft_base_cmd_list_set_map_meter_end "\v(set|map|meter)\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flowtable' ] set_spec

" base_cmd list_cmd 'flowtables' [ family_spec ] table_spec chain_spec
" base_cmd list_cmd 'flow' 'tables' [ family_spec ] table_spec chain_spec
hi link   nft_list_flowtables_ruleset_chain_spec_identifier nftHL_Identifier
syn match nft_list_flowtables_ruleset_chain_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" list_cmd 'flowtables' ruleset_spefc family_spec family_spec_explicit
hi link   nft_list_flowtable_ruleset_table_spec_identifier nftHL_Identifier
syn match nft_list_flowtable_ruleset_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_chain_spec_identifier,
\    nft_list_flowtable_spec_family_spec_explicit,
\    nft_list_flowtable_spec_family_spec_explicit_unsupported,
\    nft_list_flowtable_ruleset_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_ruleset_table_spec_identifier_keyword_last nftHL_Identifier
syn match nft_list_flowtable_ruleset_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_chain_spec_identifier_keyword_last,
\    nft_list_flowtable_ruleset_chain_spec_identifier_string,
\    nft_list_flowtable_spec_family_spec_explicit,
\    nft_list_flowtable_spec_family_spec_explicit_unsupported,
\    nft_list_flowtable_ruleset_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_spec_family_spec_explicit nftHL_Family
syn match nft_list_flowtable_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_flowtable_ruleset_table_spec_identifier_keyword_last,
\    nft_list_flowtable_ruleset_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_flowtable_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_flowtable_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_flowtables_ruleset_table_spec_identifier_keyword_last,
\    nft_list_flowtables_ruleset_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" ruleset_spec->'tables'->list_cmd->'list'->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_family_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_family_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" ruleset_spec->'table'->list_cmd->'list'->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_string

" *************** BEGIN 'list flow[s]/flowtable[s]' **************
" *************** BEGIN 'list flow table' **************
" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec identifier
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nfft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec identifier
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last nftHL_Action
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nfft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" string->identifier->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" 'last'->identifier->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_identifier_string

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ] set_spec
" family_spec_explicit->family_spec->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string,

" family_spec_explicit->family_spec->table_spec->set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'table' ]
" set_spec->'table'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_table nftHL_Statement
syn match nft_list_cmd_keyword_flow_keyword_table "\vtable\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_table_set_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" *************** END 'list flow table' **************

" *************** BEGIN 'list flow tables' **************
" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ] ruleset_spec
" family_spec_explicit->ruleset_spec->'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_identifier_string,

" family_spec_explicit->ruleset_spec->'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd [ 'list' ] [ 'flow' ] [ 'tables' ]
" 'tables'->'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flow_keyword_tables nftHL_Statement
syn match nft_list_cmd_keyword_flow_keyword_tables "tables" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit

" *************** END 'list flow tables' **************

" base_cmd [ 'list' ] [ 'flow' ]
" 'flow'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flow nftHL_Command
syn match nft_base_cmd_list_keyword_flow "\vflow\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables,
\    nft_list_cmd_keyword_flow_keyword_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END 'list flow' **************


" *************** BEGIN 'list flowtables' **************
" base_cmd [ 'list' ] [ 'flowtables' ] ruleset_spec
" ruleset_spec->'flowtables'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flowtables nftHL_Command
syn match nft_base_cmd_list_keyword_flowtables "flowtables" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flow_keyword_tables_ruleset_spec_family_spec_explicit_unsupported,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error
" *************** END 'list flowtables' **************

" *************** BEGIN 'list flowtable' **************
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string "\v[A-Za-z][A-Za-z0-9\\\/_\.]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string "\v[A-Za-z][A-Za-z0-9\\\/_\.]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd [ 'list' ] [ 'flowtable' ] flowtable_spec
" family_spec_explicit->family_spec->table_spec->flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string,

" family_spec_explicit->family_spec->table_spec->flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported nftHL_Error
syn match nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported "\v(netdev|bridge|arp)" skipwhite contained

" base_cmd list_cmd 'flowtable' flowtable_spec
syn cluster nft_c_list_cmd_keyword_flowtable_flowtable_spec_end
\ contains=
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_family_spec_explicit_unsupported,
\    nft_list_cmd_keyword_flowtable_flowtable_spec_table_spec_identifier_string,

" base_cmd [ 'list' ] [ 'flowtable' ] flowtable_spec
" flowtable_spec->'flowtable'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_flowtable nftHL_Command
syn match nft_base_cmd_list_keyword_flowtable "\vflowtable\ze " skipwhite contained
\ nextgroup=
\    @nft_c_list_cmd_keyword_flowtable_flowtable_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END 'list flowtable' **************

" *************** END 'list flow[s]/flowtable[s]' **************
" base_cmd 'list' 'ruleset' ruleset_spec
hi link   nft_list_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_ruleset_spec_family_spec_explicit "\v(ip(6)?|inet)" skipwhite contained
\ nextgroup=
\    nft_list_set_table_spec_identifier

" base_cmd 'list' 'ruleset' set_spec
hi link   nft_base_cmd_list_ruleset_end nftHL_Command
syn match nft_base_cmd_list_ruleset_end "ruleset" skipwhite contained
\ nextgroup=
\    nft_list_ruleset_spec_family_spec_explicit,
\    nft_Error
" TODO: Unused nft_base_cmd_list_ruleset_end

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp') identifier
" identifier->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string nftHL_Table
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_EOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp') 'last'
" identifier->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last nftHL_Action
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_EOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ('ip'|'ip6'|'inet'|'netdev'|'bridge'|'arp')
" family_spec_explicit->family_spec->table_spec->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last nftHL_Action
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last "last" skipwhite contained

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' ('helpers'|'timeout'|'expectation') ct_cmd_type
" ct_obj_type->list_cmd->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table nftHL_Action
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table "\vtable\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_keyword_last,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helper'
" 'helper'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' ('timeout'|'expectation')
" 'timeout'->'ct'->list_cmd->'list'->base_cmd->line
" 'expectation'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
" 'expectation'->ct_cmd_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keywords_timeout_expectation nftHL_Statement
syn match nft_list_cmd_keyword_ct_keywords_timeout_expectation "\v(timeout|expectation)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helper'
" 'helper'->ct_obj_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helper nftHL_Statement
syn match nft_list_cmd_keyword_ct_keyword_helper "helper" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_family_spec_explicit,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_keyword_last,
\    nft_list_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct' 'helpers' ct_obj_type
" 'helper'->ct_cmd_type->'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_ct_keyword_helpers nftHL_Statement
syn match nft_list_cmd_keyword_ct_keyword_helpers "helpers" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation_keyword_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'ct'
" list_cmd->base_cmd->line
" 'ct'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_ct nftHL_Statement
syn match nft_base_cmd_list_keyword_ct "\vct\ze " skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_ct_keyword_helper,
\    nft_list_cmd_keyword_ct_keyword_helpers,
\    nft_list_cmd_keyword_ct_keywords_timeout_expectation,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

" 'list' 'hooks'
" basehook_device_name->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string nftHL_Device
syn match nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string "\v[a-zA-Z0-9\-_\.]{1,32}" skipwhite contained

" 'list' 'hooks'
" basehook_device_name->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device nftHL_Action
syn match nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device "device" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_string

" 'list' 'hooks'
" family_spec_explicit->family_spec->ruleset_spec->basehook_spec->'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name_keyword_device

" 'list' 'hooks'
" 'hooks'->list_cmd->'list'->base_cmd->line
hi link   nft_base_cmd_list_keyword_hooks nftHL_Statement
syn match nft_base_cmd_list_keyword_hooks "hooks" skipwhite contained
\ nextgroup=
\    nft_list_cmd_keyword_hooks_basehook_spec_ruleset_spec_family_spec_explicit,
\    nft_list_cmd_keyword_hooks_basehook_spec_basehook_device_name


" 'list'->base_cmd->line
hi link   nft_base_cmd_keyword_list nftHL_Command
syn match nft_base_cmd_keyword_list "list" skipwhite contained
\ nextgroup=
\    nft_base_cmd_list_keyword_table_end,
\    nft_base_cmd_list_keywords_tables_chains_ruleset_meters_flowtables_maps_end,
\    nft_base_cmd_list_keyword_chain_end,
\    nft_base_cmd_list_keywords_sets_et_al_end,
\    nft_base_cmd_list_set_map_meter_end,
\    nft_list_cmd_keywords_counter_et_al_obj_spec,
\    nft_base_cmd_list_keyword_flowtables,
\    nft_base_cmd_list_keyword_flowtable,
\    nft_base_cmd_list_keyword_flow,
\    nft_base_cmd_list_keyword_ct,
\    nft_base_cmd_list_keyword_hooks,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** END list_cmd *************************

" **************** BEGIN ct_cmd *******************
hi link   nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
" TODO: undefined ct_expectation_block

hi link   nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_identifier

" base_cmd 'ct' 'expectation' obj_spec table_spec
hi link   nft_base_cmd_add_ct_expectation_obj_spec_table_spec nftHL_Command
syn match nft_base_cmd_add_ct_expectation_obj_spec_table_spec "\v(ip[6]|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table

" base_cmd 'ct' 'expectation' obj_spec
syn cluster nft_c_base_cmd_add_ct_expectation_obj_spec
\ contains=
\    nft_base_cmd_add_ct_expectation_obj_spec_table_spec,
\    nft_add_cmd_keyword_ct_keyword_expectation_obj_spec_table_spec_identifier_table

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
hi link   nft_base_cmd_add_ct_keyword_expectation nftHL_Command
syn match nft_base_cmd_add_ct_keyword_expectation "expectation" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_add_ct_expectation_obj_spec

hi link    nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block nftHL_BlockDelimitersCT
syn region nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block start="{" end="}" skip="\\[\{\}]"  skipwhite contained
\ contains=
\    @nft_c_ct_timeout_config

hi link   nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier nftHL_Chain
syn match nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_ct_timeout_block

hi link   nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_identifier

" base_cmd 'ct' 'timeout' obj_spec table_spec
hi link   nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table

" base_cmd 'ct' 'timeout' obj_spec
syn cluster nft_c_base_cmd_add_ct_timeout_obj_spec
\ contains=
\    nft_base_cmd_add_ct_timeout_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_ct_keyword_timeout_obj_spec_table_spec_identifier_table
" TODO: missing table_spec

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
" base_cmd 'ct' 'timeout' obj_spec table_spec
hi link   nft_base_cmd_add_ct_keyword_timeout nftHL_Command
syn match nft_base_cmd_add_ct_keyword_timeout "timeout" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_add_ct_timeout_obj_spec

hi link    nft_add_cmd_ct_helper_block nftHL_BlockDelimitersCT
syn region nft_add_cmd_ct_helper_block start="{" end="}" skip="\\}" skipwhite contained
\ contains=
\    @nft_c_ct_helper_config,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_stmt_separator,

hi link   nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier nftHL_Chain
syn match nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_ct_helper_block

hi link   nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_identifier

" base_cmd 'ct' 'helper' obj_spec table_spec
" family_spec->table_spec->obj_spec->'helper'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec nftHL_Family
syn match nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table

" base_cmd [ 'ct' ] ('helper'|'timeout'|'expectation')
hi link   nft_base_cmd_add_ct_keyword_helper nftHL_Command
syn match nft_base_cmd_add_ct_keyword_helper "helper" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_ct_helper_obj_spec_table_spec_family_spec,
\    nft_add_cmd_keyword_ct_keyword_helper_obj_spec_table_spec_identifier_table

syn cluster nft_c_cmd_add_ct_keywords
\ contains=
\    nft_base_cmd_add_ct_keyword_helper,
\    nft_base_cmd_add_ct_keyword_timeout,
\    nft_base_cmd_add_ct_keyword_expectation

" base_cmd [ 'ct' ]
hi link   nft_base_cmd_add_cmd_keyword_ct nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_ct "\vct\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_cmd_add_ct_keywords
" **************** BEGIN ct_cmd *******************

"***************** get_cmd BEGIN *****************
hi link   nft_get_cmd_set_block_separator nftHL_Normal
syn match nft_get_cmd_set_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_comment_inline

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'type'  <family>
hi link   nft_get_cmd_set_block_typeof_key_expr_type_data_type_expr nftHL_Action
syn match nft_get_cmd_set_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_get_cmd_set_block_typeof_key_expr_type_data_type_expr

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'type'
hi link   nft_get_cmd_set_block_typeof_key_expr_type nftHL_Command
syn match nft_get_cmd_set_block_typeof_key_expr_type "type\s" skipwhite contained
\ nextgroup=
\    nft_get_cmd_set_block_typeof_key_expr_type_data_type_expr

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9]{0,63}(\.[a-zA-Z][a-zA-Z0-9]{0,63}){0,5}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr_with_dot

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_get_cmd_set_spec_set_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_get_cmd_set_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr 'typeof'
hi link   nft_get_cmd_set_block_typeof_key_expr_typeof nftHL_Command
syn match nft_get_cmd_set_block_typeof_key_expr_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_get_cmd_set_spec_set_block_typeof_key_expr_typeof_expr

" base_cmd 'get' 'element' set_spec '{' set_block typeof_key_expr
syn cluster nft_c_get_cmd_set_spec_set_block_typeof_key_expr
\ contains=
\    nft_get_cmd_set_block_typeof_key_expr_typeof,
\    nft_get_cmd_set_block_typeof_key_expr_type

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag ','
hi link   nft_get_cmd_set_block_flags_set_flag_list_comma nftHL_Operator
syn match nft_get_cmd_set_block_flags_set_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_get_cmd_set_spec_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag
hi link   nft_get_cmd_set_block_flags_set_flag_list_set_flag nftHL_Action
syn match nft_get_cmd_set_block_flags_set_flag_list_set_flag skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_get_cmd_set_block_flags_set_flag_list_comma

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list
syn cluster nft_c_get_cmd_set_spec_set_block_set_flag_list
\ contains=
\    nft_get_cmd_set_block_flags_set_flag_list_set_flag

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags'
hi link   nft_get_cmd_set_block_flags nftHL_Command
syn match nft_get_cmd_set_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_get_cmd_set_spec_set_block_set_flag_list


" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'/'gc-interval' time_spec
hi link   nft_get_cmd_set_block_time_spec nftHL_Number
syn match nft_get_cmd_set_block_time_spec "\v[A-Za-z0-9\-\_\:]{1,32}" skipwhite contained
\ nextgroup=
\    nft_get_cmd_set_block_separator
" TODO clarify <time_spec>

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'
hi link   nft_get_cmd_set_block_timeout nftHL_Command
syn match nft_get_cmd_set_block_timeout "timeout" skipwhite contained
\ nextgroup=
\    nft_get_cmd_set_block_time_spec

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'tcp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'udp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'udplite' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'esp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'ah' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'icmp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'icmpv6' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'igmp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'gre' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'comp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'dccp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'sctp' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr 'redirect' '}'
hi link   nft_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_expr_keywords nftHL_Expression
syn match nft_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_expr_keywords skipwhite contained
\ "\v(tcp|udplite|udp|esp|ah|icmpv6|icmp|igmp|gre|comp|dccp|sctp|direct)"

hi link    nft_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_expr_block nftHL_Normal
syn region nft_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_expr_block start="(" end=")" skipwhite contained

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr primary_rhs_expr '}'
syn cluster nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_rhs_expr
\ contains=
\    nft_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_expr_keywords,
\    nft_primary_rhs_expr_block,
\    nft_integer_expr,
\    @nft_c_boolean_expr,
\    nft_keyword_expr
"\ nextgroup=
"\    nft_concat_rhs_expr_basic_rhs_expr_lshift,
"\    nft_concat_rhs_expr_basic_rhs_expr_rshift

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr shift_rhs_expr '}'
syn cluster nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr
\ contains=
\          @nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr_shift_rhs_expr_primary_rhs_expr
"\ nextgroup=
"\    nft_c_concat_rhs_expr_basic_rhs_expr_ampersand

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr and_rhs_expr '}'
syn cluster nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr
\ contains=
\    @nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_shift_rhs_expr
"\ nextgroup=
"\    nft_c_concat_rhs_expr_basic_rhs_expr_caret

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr exclusive_or_rhs_expr '}'
syn cluster nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr
\ contains=
\    @nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr_and_rhs_expr
"\ nextgroup=
"\    nft_c_concat_rhs_expr_basic_rhs_expr_bar

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr '}'
syn cluster nft_c_concat_rhs_expr_basic_rhs_expr
\ contains=
\    @nft_c_nft_c_concat_rhs_expr_basic_rhs_expr_exclusive_or_rhs_expr

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr basic_rhs_expr '.' '}'
" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' concat_rhs_expr multiton_rhs_expr '.' '}'
hi link   nft_get_et_al_cmd_set_block_expr_concat_rhs_expr_dot nftHL_Operator
syn match nft_get_et_al_cmd_set_block_expr_concat_rhs_expr_dot /./ skipwhite contained
\ nextgroup=
\    @nft_c_concat_rhs_expr_basic_rhs_expr,
\    @nft_c_concat_rhs_expr_multiton_rhs_expr



" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_elem_key_expr set_lhs_expr '}'
syn cluster nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_set_lhs_expr
\ contains=
\    @nft_c_concat_rhs_expr

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_elem_key_expr '*' '}'
hi link   nft_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_asterisk nftHL_Verdict
syn match nft_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_asterisk "\*" skipwhite contained
\ nextgroup=
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_set_elem_stmt_m,
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr_alloc_set_elem_expr_option,
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr_alloc_set_elem_expr_options

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_elem_expr_alloc set_elem_key_expr '}'
syn cluster nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr
\ contains=
\    nft_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_asterisk,
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_set_lhs_expr,
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr_set_lhs_expr

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_elem_expr set_elem_expr_alloc '}'
syn cluster nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr_alloc
\ contains=
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_key_expr

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_list_member_expr set_elem_expr '}'
syn cluster nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr
\ contains=
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr_alloc

hi link   nft_get_et_al_cmd_set_block_expr_set_expr_comma nftHL_Command
syn match nft_get_et_al_cmd_set_block_expr_set_expr_comma /,/ skipwhite contained
\ nextgroup=
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' set_list_member_expr '}'
syn cluster nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr
\ contains=
\    nft_get_et_al_cmd_set_block_expr_set_expr,
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr_set_elem_expr
"\ nextgroup=
"\     nft_c_get_et_al_cmd_set_block_expr_set_expr_comma

" base_cmd 'get' 'element' table_id spec_id set_block_expr set_expr '{' ... '}'
hi link    nft_get_et_al_cmd_set_block_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_get_et_al_cmd_set_block_expr_set_expr start="{" end="}" skipwhite contained
\ contains=
\    @nft_c_get_et_al_cmd_set_block_expr_set_expr_set_list_member_expr
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOL,
\    nft_Error

" base_cmd 'get' 'element' table_id spec_id '$'identifier
hi link   nft_Error_get_cmd_set_block_expr_variable_expr nftHL_Error
syn match nft_Error_get_cmd_set_block_expr_variable_expr /[^\;\s\wa-zA-Z0-9_./]{1,64}/  skipwhite contained " uncontained, on purpose
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error,


hi link   nft_get_et_al_cmd_set_block_expr_variable_expr nftHL_Variable
syn match nft_get_et_al_cmd_set_block_expr_variable_expr "\$\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_Error,
\    nft_Error_get_cmd_block_expr_variable_expr,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" All nft_c_get_et_al_cmd also applies toward:
"   add_cmd, create_cmd, delete_cmd, destroy_cmd, get_cmd, and reset_cmd
"   nft_c_get_et_al_cmd includes add_cmd, create_cmd, delete_cmd, destroy_cmd, get_cmd, and reset_cmd
" base_cmd 'get' 'element' [ family_spec_explicit ] table_id set_id set_block_expr
syn cluster nft_c_get_et_al_cmd_set_block_expr
\ contains=
\    nft_get_et_al_cmd_set_block_expr_variable_expr,
\    nft_get_et_al_cmd_set_block_expr_set_expr

" base_cmd 'get' 'element' [ family_spec_explicit ] table_id set_id
"   nft_c_get_et_al_cmd includes add_cmd, create_cmd, delete_cmd, destroy_cmd, get_cmd, and reset_cmd
hi link   nft_get_et_al_cmd_set_spec_identifier nftHL_Set
syn match nft_get_et_al_cmd_set_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_get_et_al_cmd_set_block_expr_variable_expr,
\    nft_get_et_al_cmd_set_block_expr_set_expr,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'get' 'element' [ family_spec_explicit ] table_id set_id
hi link   nft_get_et_al_cmd_set_spec_table_spec_identifier nftHL_Table
syn match nft_get_et_al_cmd_set_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_get_et_al_cmd_set_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'get' 'element' [ family_spec_explicit ] table_id set_id
hi link   nft_get_et_al_cmd_set_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_get_et_al_cmd_set_spec_table_spec_family_spec_explicit "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_get_et_al_cmd_set_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'get' 'element' set_spec
syn cluster nft_c_get_cmd_set_spec
\ contains=
\    nft_get_et_al_cmd_set_spec_table_spec_family_spec_explicit,
\    nft_get_et_al_cmd_set_spec_table_spec_identifier

" 'element'->get_cmd->'get'->base_cmd->line
"   nft_c_get_et_al_cmd includes add_cmd, create_cmd, delete_cmd, destroy_cmd, get_cmd, and reset_cmd
hi link   nft_get_et_al_cmd_keyword_element nftHL_Statement
syn match nft_get_et_al_cmd_keyword_element "element" skipwhite contained
\ nextgroup=
\    nft_get_et_al_cmd_set_spec_table_spec_family_spec_explicit,
\    nft_get_et_al_cmd_set_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'get'->base_cmd->line
"   nft_c_get_et_al_cmd includes add_cmd, create_cmd, delete_cmd, destroy_cmd, get_cmd, and reset_cmd
hi link   nft_base_cmd_keyword_get nftHL_Command
syn match nft_base_cmd_keyword_get "get" skipwhite contained
\ nextgroup=
\    nft_get_et_al_cmd_keyword_element,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** get_cmd END *****************

"***************** flush_cmd BEGIN *****************
" base_cmd 'flush' 'ruleset' ruleset_spec
hi link   nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit "\v(ip6?|inet)" skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOS,
\    nft_Error

" base_cmd 'flush' 'ruleset' set_spec
" family_spec_explicit->ruleset_spec->'ruleset'->flush_cmd-'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_ruleset_end nftHL_Command
syn match nft_flush_cmd_keyword_ruleset_end "ruleset" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_ruleset_ruleset_spec_family_spec_explicit,
\    nft_UnexpectedSemicolon,
\    nft_EOS,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec chain_spec
" identifier->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_chain_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_set_et_al_chain_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOS,
\    nft_Error

" flush_cmd 'set' set_spec family_spec family_spec_explicit
" identifier->table_spec->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_set_et_al_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_set_et_al_chain_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" family_spec_explicit->table_spec->chain_spec->'chain'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit "\v(ip(6)?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_set_et_al_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'set' set_spec
syn cluster nft_c_flush_cmd_keyword_set_et_al_set_spec_end
\ contains=
\    nft_flush_cmd_keyword_set_et_al_set_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_set_et_al_table_spec_identifier

" base_cmd [ 'flush' ] [ 'set' ] set_spec
" base_cmd [ 'flush' ] [ 'flow' ] [ 'table' ] set_spec
" base_cmd [ 'flush' ] [ 'meter' ] set_spec
hi link   nft_flush_cmd_keyword_set_map_flow_meter_end nftHL_Command
syn match nft_flush_cmd_keyword_set_map_flow_meter_end "\v(set|map|meter|flow table)" skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_set_et_al_set_spec_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec chain_spec
hi link   nft_flush_cmd_keyword_chain_chain_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_chain_chain_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_EOS,
\    nft_Error

" base_cmd flush_cmd 'chain' [ family_spec ] table_spec
hi link   nft_flush_cmd_keyword_chain_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_chain_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_chain_chain_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" flush_cmd 'chain' chain_spec family_spec family_spec_explicit
hi link   nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit "\v(ip(6)?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_chain_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'chain' chain_spec
syn cluster nft_c_flush_cmd_keyword_chain_end
\ contains=
\    nft_flush_cmd_keyword_chain_chain_spec_table_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_chain_table_spec_identifier

" base_cmd flush_cmd 'chain'
" base_cmd [ 'flush' ] [ 'chain' ] chain_spec
hi link   nft_flush_cmd_keyword_chain nftHL_Command
syn match nft_flush_cmd_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_chain_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd flush_cmd 'table' table_spec family_spec identifier
hi link   nft_flush_cmd_keyword_flush_table_spec_identifier nftHL_Identifier
syn match nft_flush_cmd_keyword_flush_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_stmt_separator,
\    nft_Error

" base_cmd flush_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit nftHL_Family  " _add_ to make 'table_spec' pathway unique
syn match nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit "\v(ip(6)?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_flush_table_spec_identifier

" base_cmd [ 'flush' ] [ 'table' ] table_spec
" table_spec->'table'->flush_cmd->'flush'->base_cmd->line
syn cluster nft_c_flush_cmd_keyword_flush_table_spec_end
\ contains=
\    nft_flush_cmd_keyword_flush_table_spec_family_spec_explicit,
\    nft_flush_cmd_keyword_flush_table_spec_identifier

" base_cmd flush_cmd 'table'
" 'table'->flush_cmd->'flush'->base_cmd->line
hi link   nft_flush_cmd_keyword_table nftHL_Command
syn match nft_flush_cmd_keyword_table "table" skipwhite contained
\ nextgroup=
\    @nft_c_flush_cmd_keyword_flush_table_spec_end

" 'flush'->base_cmd->line
hi link   nft_base_cmd_keyword_flush nftHL_Command
syn match nft_base_cmd_keyword_flush "\vflush\ze " skipwhite contained
\ nextgroup=
\    nft_flush_cmd_keyword_table,
\    nft_flush_cmd_keyword_chain,
\    nft_flush_cmd_keyword_set_map_flow_meter_end,
\    nft_flush_cmd_keyword_ruleset_end,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** flush_cmd END *****************

" *************** BEGIN import_cmd *******************
" base_cmd 'import' (via base_cmd)
hi link   nft_import_cmd_keyword_ruleset nftHL_Operator
syn match nft_import_cmd_keyword_ruleset "ruleset" skipwhite keepend contained
\ nextgroup=
\    nft_markup_format,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'import'->base_cmd->line
hi link   nft_base_cmd_keyword_import nftHL_Command
syn match nft_base_cmd_keyword_import "import" skipwhite contained
\ nextgroup=
\    nft_import_cmd_keyword_ruleset,
\    nft_markup_format,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END import_cmd *******************

" *************** BEGIN export_cmd *******************
" export_cmd markup_format (via export_cmd)
hi link   nft_export_cmd_keyword_ruleset nftHL_Operator
syn match nft_export_cmd_keyword_ruleset "ruleset" skipwhite contained
\ nextgroup=
\    nft_markup_format,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'export'->base_cmd->line
hi link   nft_base_cmd_keyword_export nftHL_Command
syn match nft_base_cmd_keyword_export "export" skipwhite contained
\ nextgroup=
\    nft_export_cmd_keyword_ruleset,
\    nft_markup_format,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END export_cmd *******************

" *************** BEGIN insert_cmd *******************
hi link   nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num nftHL_Number
syn match nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    @nft_c_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec nftHL_Action
syn match nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec "\v(position|handle|index)" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_spec_num,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain nftHL_Chain
syn match nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec,
\    @nft_c_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last nftHL_Action
syn match nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_keywords_position_et_al_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table nftHL_Identifier
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain,
\    nft_Error,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_table_spec_identifier_string_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'rule'->insert_cmd->'insert'->base_cmd->line
hi link   nft_base_cmd_keyword_insert_keyword_rule nftHL_Command
syn match nft_base_cmd_keyword_insert_keyword_rule "rule" skipwhite contained
\ nextgroup=
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_family_spec_explicit,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_keyword_last,
\    nft_insert_cmd_keyword_rule_rule_position_chain_spec_table_spec_identifier_string_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'insert'->base_cmd->line
hi link   nft_base_cmd_keyword_insert nftHL_Command
syn match nft_base_cmd_keyword_insert "insert" skipwhite contained
\ nextgroup=
\    nft_base_cmd_keyword_insert_keyword_rule,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END insert_cmd *******************

" **************** rename_cmd BEGIN  ****************
" base_cmd 'rename' 'chain' chain_spec identifier
" base_cmd 'rename' 'chain' [ family_spec ] table_id chain_id [ 'last' | <string> ]
hi link   nft_base_cmd_rename_chain_spec_table_spec_identifier nftHL_String
syn match nft_base_cmd_rename_chain_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipempty skipnl skipwhite contained
\ nextgroup=
\    nft_EOL,
\    nft_Semicolon,
\    nft_EOS

hi link   nft_base_cmd_rename_chain_spec_table_spec_chain_id nftHL_Identifier
syn match nft_base_cmd_rename_chain_spec_table_spec_chain_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\     nft_base_cmd_rename_chain_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_rename_chain_spec_table_spec_table_id nftHL_Identifier
syn match nft_base_cmd_rename_chain_spec_table_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_rename_chain_spec_table_spec_chain_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_base_cmd_rename_chain_spec_table_spec_family_spec nftHL_Family
syn match nft_base_cmd_rename_chain_spec_table_spec_family_spec "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_rename_chain_spec_table_spec_table_id,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

syn cluster nft_c_base_cmd_rename_chain_spec_table_spec
\ contains=
\    nft_base_cmd_rename_chain_spec_table_spec_family_spec,
\    nft_base_cmd_rename_chain_spec_table_spec_table_id

" base_cmd 'rename' 'chain' chain_spec
syn cluster nft_c_base_cmd_rename_chain_spec
\ contains=
\    @nft_c_base_cmd_rename_chain_spec_table_spec

" base_cmd 'rename' 'chain'
hi link   nft_base_cmd_rename_chain_keyword nftHL_Statement
syn match nft_base_cmd_rename_chain_keyword "chain" skipwhite contained
\ nextgroup=
\    @nft_c_base_cmd_rename_chain_spec,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'rename'->base_cmd->line
hi link   nft_base_cmd_keyword_rename nftHL_Command
syn match nft_base_cmd_keyword_rename "rename" skipwhite contained
\ nextgroup=
\    nft_base_cmd_rename_chain_keyword,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
"***************** rename_cmd END *****************

" *********************  BEGIN 'reset' ***********************
" 'reset' 'set'
" 'reset' 'map'
" set_or_id_spec->'set'->reset_cmd->base_cmd->line
" set_or_id_spec->'map'->reset_cmd->base_cmd->line
"    nft_reset_cmd_keyword_set_set_or_id_spec
"    nft_reset_cmd_keyword_map_set_or_id_spec
"

" base_cmd 'reset' 'counters'
hi link   nft_base_cmd_reset_cmd_keyword_counters nftHL_Action
syn match nft_base_cmd_reset_cmd_keyword_counters "counters" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counters_quotas_ruleset_spec_family_spec,
\    nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table,
\    nft_base_cmd_reset_counters_quotas_table_keyword,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error



""""" BEGIN OF add_cmd/'reset' """""
" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id '{' ... '}'
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_set nftHL_BlockDelimitersSet
syn region nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_set start="{" end="}" skipwhite skipnl contained
\ nextgroup=
\    nft_EOL

" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id '$'identifier
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_variable nftHL_Variable
syn match nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_variable "\$\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id 'handle' handle_identifier
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_id nftHL_Number
syn match nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_id "\v[0-9]{1,7}" skipwhite contained

" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id 'handle'
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_spec nftHL_Handle
syn match nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_spec "handle" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_id

" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id nftHL_Set
syn match nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_handle_spec,
\    nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_variable,
\    nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id_set

" base_cmd 'reset' [ 'set' | 'map' ] table_id
hi link   nft_base_cmd_reset_set_or_map_family_spec_table_id nftHL_Table
syn match nft_base_cmd_reset_set_or_map_family_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_set_or_map_family_spec_table_id_spec_id

" base_cmd 'reset' [ 'set' | 'map' ] family_spec table_id
hi link   nft_base_cmd_reset_set_or_map_family_spec nftHL_Family
syn match nft_base_cmd_reset_set_or_map_family_spec "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_set_or_map_family_spec_table_id

" base_cmd 'reset' [ 'set' | 'map' ]
hi link   nft_base_cmd_reset_set_or_map nftHL_Action
syn match nft_base_cmd_reset_set_or_map "\v(set|map)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_set_or_map_family_spec,
\    nft_base_cmd_reset_set_or_map_family_spec_table_id


" base_cmd 'reset' 'element' table_id spec_id '{' ... '}'
hi link   nft_base_cmd_reset_element_family_spec_table_id_spec_id_set nftHL_BlockDelimitersSet
syn region nft_base_cmd_reset_element_family_spec_table_id_spec_id_set start="{" end="}" skipwhite skipnl contained
\ nextgroup=
\    nft_Semicolon,
\    nft_EOL

" base_cmd 'reset' 'element' table_id spec_id $variable
hi link   nft_base_cmd_reset_element_family_spec_table_id_spec_id_variable nftHL_Variable
syn match nft_base_cmd_reset_element_family_spec_table_id_spec_id_variable "\v\$[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_element_family_spec_table_id_spec_id

" base_cmd 'reset' 'element' table_id spec_id
hi link   nft_base_cmd_reset_element_family_spec_table_id_spec_id nftHL_Set
syn match nft_base_cmd_reset_element_family_spec_table_id_spec_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_element_family_spec_table_id_spec_id_variable,
\    nft_base_cmd_reset_element_family_spec_table_id_spec_id_set

" base_cmd 'reset' 'element' table_id
hi link   nft_base_cmd_reset_element_family_spec_table_id nftHL_Table
syn match nft_base_cmd_reset_element_family_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_element_family_spec_table_id_spec_id

" base_cmd 'reset' 'element'
hi link   nft_base_cmd_reset_element_family_spec nftHL_Family
syn match nft_base_cmd_reset_element_family_spec "\v(ip6|ip|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_element_family_spec_table_id

" base_cmd 'reset' 'rules' 'chain' <table_identifier> <chain_identifier>
hi link   nft_reset_cmd_keyword_rules_chain_spec_identifier_string nftHL_Chain
syn match nft_reset_cmd_keyword_rules_chain_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Semicolon,
\    nft_Error

" base_cmd 'reset' 'rules' 'chain' <table_identifier> 'last'
hi link   nft_reset_cmd_keyword_rules_chain_spec_identifier_keyword_last nftHL_Chain
syn match nft_reset_cmd_keyword_rules_chain_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_EOS,
\    nft_Semicolon,
\    nft_Error

" base_cmd 'reset' 'rules' 'chain' <table_identifier>
hi link   nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string nftHL_Table
syn match nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_identifier_keyword_last,
\    nft_reset_cmd_keyword_rules_chain_spec_identifier_string,
\    nft_Semicolon,
\    nft_EOS

" base_cmd 'reset' 'rules' 'chain' 'last'
hi link   nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_identifier_keyword_last,
\    nft_reset_cmd_keyword_rules_chain_spec_identifier_string,
\    nft_Semicolon,
\    nft_EOS

" base_cmd 'reset' 'rules' 'chain' family_spec_explicit
hi link   nft_reset_cmd_keyword_rules_chain_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_reset_cmd_keyword_rules_chain_spec_table_spec_family_spec_explicit "\v(ip6|ip|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_keyword_last,
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string,
\    nft_Error

" base_cmd 'reset' 'rules' 'chain'
hi link   nft_reset_cmd_keyword_rules_keyword_chain nftHL_Action
syn match nft_reset_cmd_keyword_rules_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_family_spec_explicit,
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_keyword_last,
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string,
\    nft_Error

hi link   nft_reset_cmd_keyword_rules_table_spec_table_id nftHL_Table
syn match nft_reset_cmd_keyword_rules_table_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string,
\    nft_Semicolon,
\    nft_EOS

hi link   nft_reset_cmd_keyword_rules_table_spec_keyword_last nftHL_Action
syn match nft_reset_cmd_keyword_rules_table_spec_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_chain_spec_table_spec_identifier_string,
\    nft_Semicolon,
\    nft_EOS


hi link   nft_reset_cmd_keyword_rules_table_spec_family_spec nftHL_Family
syn match nft_reset_cmd_keyword_rules_table_spec_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_table_spec_table_id,
\    nft_reset_cmd_keyword_rules_table_spec_keyword_last,
\    nft_UnexpectedEOS,
\    nft_UnexpectedSemicolon,
\    nft_Error

" base_cmd 'reset' 'rules' 'table'
hi link   nft_reset_cmd_keyword_rules_keyword_table nftHL_Action
syn match nft_reset_cmd_keyword_rules_keyword_table "table" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_table_spec_family_spec,
\    nft_reset_cmd_keyword_rules_table_spec_keyword_last,
\    nft_reset_cmd_keyword_rules_table_spec_table_id,
\    nft_UnexpectedEOS,
\    nft_UnexpectedSemicolon,
\    nft_Error

" base_cmd 'reset' 'rules' family_spec_explicit <EOS>
hi link   nft_reset_cmd_keyword_rules_ruleset_spec_family_spec_explicit nftHL_Family
syn match nft_reset_cmd_keyword_rules_ruleset_spec_family_spec_explicit "\v(ip6|ip|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_table_spec_table_id,
\    nft_line_stmt_separator,
\    nft_EOS,

" base_cmd 'reset' 'rules'
hi link   nft_base_cmd_reset_rules nftHL_Statement
syn match nft_base_cmd_reset_rules "rules" skipwhite contained
\ nextgroup=
\    nft_reset_cmd_keyword_rules_ruleset_spec_family_spec_explicit,
\    nft_reset_cmd_keyword_rules_keyword_table,
\    nft_reset_cmd_keyword_rules_keyword_chain,
\    nft_reset_cmd_keyword_rules_table_spec_table_id,
\    nft_Error

" base_cmd 'reset' 'counter' obj_spec
" base_cmd 'reset' 'counter'/'quota' table_id chain_id
hi link   nft_base_cmd_reset_counter_quota_obj_spec_id_chain nftHL_Chain
syn match nft_base_cmd_reset_counter_quota_obj_spec_id_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,

" base_cmd 'reset' 'counter'/'quota' 'table' identifier
hi link   nft_base_cmd_reset_counter_quota_obj_spec_id_table nftHL_Table
syn match nft_base_cmd_reset_counter_quota_obj_spec_id_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counter_quota_obj_spec_id_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'counter'/'quota' family_spec
hi link   nft_base_cmd_reset_counter_quota_family_spec nftHL_Family
syn match nft_base_cmd_reset_counter_quota_family_spec "\v(ip6|ip|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counter_quota_obj_spec_id_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'quota'
hi link   nft_base_cmd_reset_quota nftHL_Action
syn match nft_base_cmd_reset_quota "quota" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counter_quota_family_spec,
\    nft_base_cmd_reset_counter_quota_obj_spec_id_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'counter'
hi link   nft_base_cmd_reset_keyword_counter nftHL_Statement
syn match nft_base_cmd_reset_keyword_counter "counter " skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counter_quota_family_spec,
\    nft_base_cmd_reset_counter_quota_obj_spec_id_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'counters'/'quotas' 'table' identifier identifier
hi link   nft_base_cmd_reset_counters_quotas_table_table_spec_id_chain nftHL_Identifier
syn match nft_base_cmd_reset_counters_quotas_table_table_spec_id_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" base_cmd 'reset' 'counters'/'quotas' 'table' identifier
hi link   nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table nftHL_Identifier
syn match nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counters_quotas_table_table_spec_id_chain,

" base_cmd 'reset' 'counters'/'quotas' ruleset_spec
hi link   nft_base_cmd_reset_counters_quotas_ruleset_spec_family_spec nftHL_Family
syn match nft_base_cmd_reset_counters_quotas_ruleset_spec_family_spec "\v(ip6|ip|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'counters'/'quotas' 'table' table_spec
hi link   nft_base_cmd_reset_counters_quotas_table_keyword nftHL_Element
syn match nft_base_cmd_reset_counters_quotas_table_keyword "table" skipwhite contained
\ nextgroup=
\     nft_base_cmd_reset_counters_quotas_ruleset_spec_family_spec,
\     nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd 'reset' 'quotas'
hi link   nft_base_cmd_reset_quotas nftHL_Action
syn match nft_base_cmd_reset_quotas "quotas" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_counters_quotas_ruleset_spec_family_spec,
\    nft_base_cmd_reset_counters_quotas_table_table_spec_identifier_table,
\    nft_base_cmd_reset_counters_quotas_table_keyword,
"**** END OF add_cmd/'reset' *****

" 'reset'->base_cmd->line
hi link   nft_base_cmd_keyword_reset nftHL_Command
syn match nft_base_cmd_keyword_reset "reset" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_cmd_keyword_counters,
\    nft_base_cmd_reset_keyword_counter,
\    nft_get_et_al_cmd_keyword_element,
\    nft_base_cmd_reset_quotas,
\    nft_base_cmd_reset_quota,
\    nft_base_cmd_reset_rules,
\    nft_base_cmd_delete_destroy_reset_cmd_keyword_rule,
\    nft_base_cmd_reset_set_or_map,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error



" base_cmd 'reset' 'rule' table_id chain_id
hi link   nft_base_cmd_reset_rule_ruleset_spec_id_chain nftHL_Chain
syn match nft_base_cmd_reset_rule_ruleset_spec_id_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" base_cmd 'reset' 'rule' table_id
hi link   nft_base_cmd_reset_cmd_keyword_rule_ruleset_spec_id_table nftHL_Family
syn match nft_base_cmd_reset_cmd_keyword_rule_ruleset_spec_id_table "\v[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_base_cmd_reset_rule_ruleset_spec_id_chain
" *********************  END 'reset' ***********************

" *********************  BEGIN 'limit' ***********************
" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts nftHL_Action
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts "\v\c(packet)[s]?" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num nftHL_Number
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num "\v[0-9]{1,20}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_keyword_pkts,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_pkts->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst nftHL_Command
syn match nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_limit_pkts_num,
\    nft_Error


hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit nftHL_Action
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit "\v\c(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_burst_pkts_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Errror

" limit_rate_bytes
" 'rate' [ 'over'|'until' ] <NUM> 'bytes' '/'
" '/'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash nftHL_Expression
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_time_unit,
\    nft_Error

" limit_burst_bytes
" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM> ('bytes'|'string')
" 'bytes'->limit_burst_bytes->limit_config
hi link   nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes nftHL_Action
syn match nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes "\v\c(pbyte|gbyte|mbyte|kbyte|byte)[s]?" skipwhite contained
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst' <NUM>
" num->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_limit_config_limit_burst_bytes_limit_bytes_num nftHL_Number
syn match nft_limit_config_limit_burst_bytes_limit_bytes_num "\v[0-9]{1,10}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_limit_bytes_keyword_bytes,
\    nft_Error

" 'limit' [ 'over'|'until' ] <NUM> '/' ('second'|'minute'|'hour'|'day'|'week') 'burst'
" 'burst'->limit_burst_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_limit_config_limit_burst_bytes_keyword_burst nftHL_Command
syn match nft_limit_config_limit_burst_bytes_keyword_burst "\vburst\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_limit_bytes_num,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit nftHL_Action
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit "\v\c(second|minute|hour|day|week)[s]?" skipwhite contained
\ nextgroup=
\    nft_limit_config_limit_burst_bytes_keyword_burst,
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash nftHL_Expression
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash "/" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_time_unit

" 'limit' 'rate' [ 'over'|'until' ] <NUM> 'string'
" 'string'->limit_rate_bytes->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string nftHL_Action
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string "\v\c(kbyte|mbyte|gbyte|pbyte|byte)[s]?" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_expression_slash,
\    nft_EOS

" 'limit' 'rate' [ 'over'|'until' ] <NUM>
" <num>->*->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num nftHL_Number
syn match nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num "\v[0-9]{1,10}\ze[ \t\/]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_bytes_keyword_string,
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pkts_expression_slash,,
\    nft_Error

" 'rate' [ 'over'|'until' ]
" limit_mode->limit_config->(add_cmd|create_cmd|limit_block)
hi link   nft_add_cmd_keyword_limit_limit_config_limit_mode nftHL_Action
syn match nft_add_cmd_keyword_limit_limit_config_limit_mode "\v(over|until)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

hi link   nft_add_cmd_keyword_limit_limit_config_keyword_rate nftHL_Statement
syn match nft_add_cmd_keyword_limit_limit_config_keyword_rate "\vrate\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_limit_mode,
\    nft_add_cmd_keyword_limit_limit_config_limit_rate_pktsbytes_num,
\    nft_Error

" base_cmd add_cmd 'limit' <table_id> <limit_id>
hi link   nft_add_cmd_keyword_limit_obj_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_identifier "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_limit_config_keyword_rate,
\    nft_add_cmd_limit_limit_block,
\    nft_Error
" TODO: limit_block
" TODO: undefined nft_add_cmd_limit_limit_block

" base_cmd add_cmd 'limit' table_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier nftHL_Identifier
syn match nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier "\v[A-Za-z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_identifier

" base_cmd add_cmd 'limit' ('ip'|'ip6'|'inet'|'arp'|'bridge'|'netdev')
" base_cmd add_cmd 'limit' family_spec
hi link   nft_add_cmd_keyword_limit_obj_spec_family_spec nftHL_Family
syn match nft_add_cmd_keyword_limit_obj_spec_family_spec "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier

" base_cmd 'add' add_cmd 'limit'
hi link   nft_base_cmd_add_cmd_keyword_limit nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_limit "\vlimit\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_limit_obj_spec_family_spec,
\    nft_add_cmd_keyword_limit_obj_spec_table_spec_identifier
" ***********  END 'limit' ***********************

" *********************  BEGIN 'quota' ***********************
hi link    nft_add_cmd_quota_block nft_BlockDelimitersQuota
syn region nft_add_cmd_quota_block start="{" end="}" skip="\\}" skipwhite contained
\ contains=
\    @nft_c_quota_config,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_stmt_separator,
\    nft_comment_spec

hi link   nft_add_cmd_quota_cmd_obj_spec_identifier_string nft_Identifier
syn match nft_add_cmd_quota_cmd_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    @nft_c_quota_config,
\    nft_add_cmd_quota_block

hi link   nft_add_cmd_quota_cmd_obj_spec_identifier_keyword_last nftHL_Action
syn match nft_add_cmd_quota_cmd_obj_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    @nft_c_quota_config,
\    nft_add_cmd_quota_block

hi link   nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_add_cmd_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_add_cmd_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'quota'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_quota nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_quota "quota" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string_unknown,
\    nft_add_cmd_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_identifier_string nft_Identifier
syn match nft_quota_cmd_obj_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_block,
\    nft_quota_config_quota_mode,
\    nft_quota_config_num

hi link   nft_quota_cmd_obj_spec_identifier_keyword_last nftHL_Action
syn match nft_quota_cmd_obj_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_quota_block,
\    nft_quota_config_quota_mode,
\    nft_quota_config_num

hi link   nft_quota_cmd_obj_spec_table_spec_identifier_string nftHL_Identifier
syn match nft_quota_cmd_obj_spec_table_spec_identifier_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last nftHL_Action
syn match nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_quota_cmd_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_quota_cmd_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'quota'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_quota nftHL_Command
syn match nft_base_cmd_keyword_quota "\vquota\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_quota_cmd_obj_spec_table_spec_identifier_keyword_last,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_quota_cmd_obj_spec_table_spec_family_spec_explicit,
\    nft_quota_cmd_obj_spec_table_spec_identifier_string,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
" *********************  END 'quota' ***********************

" *********************  BEGIN 'map' ***********************
" set_spec 'map' ('add'|'clean')
" set_spec 'element' ('add'|'clean')
" set_spec 'map' ('delete'|'destroy')
" set_spec 'element' ('delete'|'destroy')
" set_spec ('set'|'map'|'flow table'|'meter') 'flush'
" set_spec 'element' 'get'
" set_spec ('set'|'meter'|'map') 'list'
" set_spec 'element' 'reset'
" set_spec set_or_id_spec 'set' ('delete'|'destroy')
" set_spec set_or_id_spec ('set'|'map') 'reset'

" (string|'last') chain_identifier table_block

" chain_or_id_spec 'chain' 'delete'
" chain_or_id_spec 'chain' 'destroy'

" table_or_id_spec 'table' ('delete'|'destroy')

" insert_cmd 'insert' base_cmd line

" create_cmd 'create' base_cmd line

" replace_cmd 'replace' base_cmd line

hi link   nft_add_cmd_map_map_spec_map_block_separator nftHL_Normal
syn match nft_add_cmd_map_map_spec_map_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_comment_inline

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr nftHL_Action
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]\{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type "type\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}){0,5}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr_with_dot

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr
syn cluster nft_c_add_cmd_map_mamappec_map_block_typeof_key_expr
\ contains=
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_typeof,
\    nft_add_cmd_map_map_spec_map_block_typeof_key_expr_type


" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag ','
hi link   nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma nftHL_Operator
syn match nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_map_flag_list

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag
hi link   nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag nftHL_Action
syn match nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_comma

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list
syn cluster nft_c_add_cmd_map_map_spec_map_block_map_flag_list
\ contains=
\    nft_add_cmd_map_map_spec_map_block_flags_map_flag_list_map_flag

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags'
hi link   nft_add_cmd_map_map_spec_map_block_flags nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_map_flag_list


" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_map_map_spec_map_block_time_spec nftHL_Number
syn match nft_add_cmd_map_map_spec_map_block_time_spec "\v[A-Za-z0-9\-\_\:]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator
" TODO clarify <time_spec>

" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'
hi link   nft_add_cmd_map_map_spec_map_block_timeout nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_timeout "timeout" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements'
hi link   nft_add_cmd_map_map_spec_map_block_elements nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'gc-interval'
hi link   nft_add_cmd_map_map_spec_map_block_gc_interval nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '=' '{' map_block_item
hi link    nft_add_cmd_map_map_spec_map_block_elements_block_items nftHL_BlockDelimitersMap
syn match nft_add_cmd_map_map_spec_map_block_elements_block_items "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]" skipwhite contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '=' '{' map_block_expr
hi link    nft_add_cmd_map_map_spec_map_block_elements_map_block_expr nftHL_BlockDelimitersMap
syn region nft_add_cmd_map_map_spec_map_block_elements_map_block_expr start="{" end="}" skipwhite contained
\ contains=
\    nft_add_cmd_map_map_spec_map_block_elements_block_items
\ nextgroup=
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '='
hi link   nft_add_cmd_map_map_spec_map_block_elements_equal nftHL_Operator
syn match nft_add_cmd_map_map_spec_map_block_elements_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_elements_map_block_expr

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements'
hi link   nft_add_cmd_map_map_spec_map_block_elements nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_elements_equal

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'size' <interval>
hi link   nft_add_cmd_map_map_spec_map_block_map_mechanism_size_value nftHL_Number
syn match nft_add_cmd_map_map_spec_map_block_map_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'size'
hi link   nft_add_cmd_map_map_spec_map_block_map_mechanism_size nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_map_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_map_mechanism_size_value


" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy' 'memory'
hi link   nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_memory nftHL_Action
syn match nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy' 'performance'
hi link   nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_performance nftHL_Action
syn match nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_separator

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy'
hi link   nft_add_cmd_map_map_spec_map_block_map_mechanism_policy nftHL_Command
syn match nft_add_cmd_map_map_spec_map_block_map_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_memory,
\    nft_add_cmd_map_map_spec_map_block_map_mechanism_policy_performance

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism
syn cluster nft_c_add_cmd_map_map_spec_map_block_map_mechanism
\ contains=
\    nft_add_cmd_map_map_spec_map_block_map_mechanism_size,
\    nft_add_cmd_map_map_spec_map_block_map_mechanism_policy

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_string nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_string "\v[\"\'\_\-A-Za-z0-9]{1,64}" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single "\v\'[\"\_\- A-Za-z0-9]{1,64}\'" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double "\v\"[\'\_\- A-Za-z0-9]{1,64}\"" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec ASTERISK_STRING
hi link   nft_add_cmd_map_map_spec_map_block_comment_string_asterisk nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_string_asterisk "\v\*[\"\'\_\-A-Za-z0-9 ]{1,64}\*" contained

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment' comment_spec
syn cluster nft_c_add_cmd_map_map_spec_map_block_comment_string
\ contains=
\   nft_add_cmd_map_map_spec_map_block_comment_string_asterisk,
\   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_single,
\   nft_add_cmd_map_map_spec_map_block_comment_string_quoted_double,
\   nft_add_cmd_map_map_spec_map_block_comment_string_string

" base_cmd add_cmd 'map' map_spec '{' map_block 'comment'
hi link   nft_add_cmd_map_map_spec_map_block_comment_spec nftHL_Comment
syn match nft_add_cmd_map_map_spec_map_block_comment_spec "comment" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec_map_block_comment_string

" base_cmd add_cmd 'map' map_spec '{' map_block '}'
hi link    nft_add_cmd_map_map_spec_map_block nftHL_BlockDelimitersMap
syn region nft_add_cmd_map_map_spec_map_block start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_map_map_spec_map_block_timeout,
\    nft_add_cmd_map_map_spec_map_block_gc_interval,
\    nft_add_cmd_map_map_spec_map_block_flags,
\    @nft_c_stateful_stmt,
\    nft_add_cmd_map_map_spec_map_block_comment_spec,
\    @nft_c_add_cmd_map_map_spec_map_block_map_mechanism,
\    @nft_c_add_cmd_map_map_spec_map_block_typeof_key_expr,
\    undefined_map_map_spec_map_block_type_datatype,
\    nft_add_cmd_map_map_spec_map_block_elements,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_add_cmd_map_map_spec_map_block_separator
\ nextgroup=
\    nft_comment_inline,
\    nft_Semicolon

" base_cmd add_cmd 'map' map_spec set_identifier (chain)
hi link   nft_add_cmd_map_map_spec_identifier_set nftHL_Chain
syn match nft_add_cmd_map_map_spec_identifier_set "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_map_block

" base_cmd add_cmd 'map' map_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table nftHL_Table
syn match nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_map_map_spec_identifier_set

" base_cmd add_cmd 'map' map_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ "\v(ip(6)?|inet|arp|bridge|netdev)"
\ nextgroup=
\    nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table

" base_cmd [ 'add' ] 'map' map_spec table_spec
syn cluster nft_c_add_cmd_map_map_spec_table_spec
\ contains=
\    nft_add_cmd_map_map_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_map_map_spec_table_spec_family_spec_identifier_table

" base_cmd [ 'add' ] 'map' map_spec
syn cluster nft_c_add_cmd_map_map_spec
\ contains=@nft_c_add_cmd_map_map_spec_table_spec

" 'map'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_map nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_map "\vmap\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec

hi link   nft_base_cmd_keyword_map nftHL_Command
syn match nft_base_cmd_keyword_map "\vmap\ze " skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_map_map_spec
" do not add ^ regex to nft_base_cmd_map, already done by nft_line
" *********************  END 'map' ***********************

" ******************** BEGIN set_cmd ************************
hi link   nft_add_cmd_keyword_set_set_spec_set_block_separator nftHL_Normal
syn match nft_add_cmd_keyword_set_set_spec_set_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_Semicolon,
\    nft_comment_inline

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr skipwhite contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type_data_type_expr nftHL_Action
syn match nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type "type\s" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9]{0,63}){0,23}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr_with_dot
" TODO undefined nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_with_dot

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr
syn cluster nft_c_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_typeof,
\    nft_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr_type

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag ','
hi link   nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_comma nftHL_Operator
syn match nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag
hi link   nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_set_flag nftHL_Action
syn match nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_set_flag skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_comma

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list
syn cluster nft_c_add_cmd_keyword_set_set_spec_set_block_set_flag_list
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_flags_set_flag_list_set_flag

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_flags nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_keyword_set_set_spec_set_block_time_spec nftHL_Number
syn match nft_add_cmd_keyword_set_set_spec_set_block_time_spec "\v[a-zA-Z0-9\\\/_\.\:]{1,31}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_timeout nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_timeout "timeout" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_elements nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'gc-interval'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_gc_interval nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '=' set_block_expr
" set_expr->set_block_expr
" TODO unused nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block_expr_set_expr
hi link   nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block_expr_set_expr start="{" end="}" skipwhite contained
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_elements_block_items
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator

" unused nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_semicolon
hi link  nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_semicolon nftHL_Operator
syn match nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_semicolon /;/ skipwhite contained

hi link    nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_elements_block_items
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator
" TODO: undefined nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_elements_block_items "
" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id '$'identifier

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '='
hi link   nft_add_cmd_keyword_set_set_spec_set_block_elements_equal nftHL_Normal
syn match nft_add_cmd_keyword_set_set_spec_set_block_elements_equal /=/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_elements_set_block

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_elements nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_elements_equal

" base_cmd add_cmd 'set' set_spec '{' set_block 'automerge'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_automerge nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_automerge "auto\-merge" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size' <interval>
hi link   nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size_value nftHL_Number
syn match nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size_value

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'memory'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_memory nftHL_Action
syn match nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'performance'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_performance nftHL_Action
syn match nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy nftHL_Command
syn match nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_memory,
\    nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy_performance

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism
syn cluster nft_c_add_cmd_keyword_set_set_spec_set_block_set_mechanism
\ contains=
\    nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_size,
\    nft_add_cmd_keyword_set_set_spec_set_block_set_mechanism_policy

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec STRING
hi link   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_string nftHL_Comment
syn match nft_add_cmd_keyword_set_set_spec_set_block_comment_string_string "\v[\"\'\_\-A-Za-z0-9]{1,64}" contained

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_single nftHL_Comment
syn match nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_single "\v\'[\"\_\- A-Za-z0-9]{1,64}\'" contained

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec QUOTED_STRING
hi link   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_double nftHL_Comment
syn match nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_double "\v\"[\'\_\- A-Za-z0-9]{1,64}\"" contained

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec ASTERISK_STRING
hi link   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_asterisk nftHL_Comment
syn match nft_add_cmd_keyword_set_set_spec_set_block_comment_string_asterisk "\v\*[\"\'\_\-A-Za-z0-9 ]{1,64}\*" contained

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment' comment_spec
syn cluster nft_c_add_cmd_keyword_set_set_spec_set_block_comment_string
\ contains=
\   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_asterisk,
\   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_single,
\   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_quoted_double,
\   nft_add_cmd_keyword_set_set_spec_set_block_comment_string_string

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
hi link   nft_add_cmd_keyword_set_set_spec_set_block_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_set_set_spec_set_block_comment_spec "comment" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_comment_string

" base_cmd add_cmd 'set' set_spec '{' set_block '}'
hi link    nft_add_cmd_keyword_set_set_spec_set_block nftHL_BlockDelimitersSet
syn region nft_add_cmd_keyword_set_set_spec_set_block start="{" end="}" skipwhite contained
\ contains=
\    @nft_c_stateful_stmt,
\    nft_add_cmd_keyword_set_set_spec_set_block_automerge,
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_typeof_key_expr,
\    nft_add_cmd_keyword_set_set_spec_set_block_flags,
\    nft_add_cmd_keyword_set_set_spec_set_block_timeout,
\    nft_add_cmd_keyword_set_set_spec_set_block_gc_interval,
\    undefined_set_mechanism,
\    nft_add_cmd_keyword_set_set_spec_set_block_comment_spec,
\    nft_add_cmd_keyword_set_set_spec_set_block_elements,
\    @nft_c_add_cmd_keyword_set_set_spec_set_block_set_mechanism,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_spec,
\    nft_add_cmd_keyword_set_set_spec_set_block_separator
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" ************* BEGIN set_spec 'set' ('add'|'clean') ***************
" base_cmd 'reset' [ 'set' | 'map' ] table_id spec_id '$'identifier
hi link   nft_add_cmd_keyword_set_set_spec_set_block_expr_variable_expr nftHL_Position
syn match nft_add_cmd_keyword_set_set_spec_set_block_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,31}" contained
\ nextgroup=
\    nft_Semicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'set' set_spec set_identifier
" set_identifier->'set'->add_cmd->base_cmd->line
hi link   nft_add_cmd_keyword_set_set_spec_set_id nftHL_Set
syn match nft_add_cmd_keyword_set_set_spec_set_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_block,
\    nft_add_cmd_keyword_set_set_spec_set_block_expr_variable_expr,
\    nft_MissingCurlyBrace,


" base_cmd add_cmd 'set' set_spec table_spec family_spec identifier (table)
hi link   nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id nftHL_Table
syn match nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_set_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedEOS,

" base_cmd add_cmd 'set' set_spec table_spec family_spec family_spec_explicit (table)
hi link   nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit skipwhite contained
\ "\v(ip(6)?|inet|arp|bridge|netdev)"
\ nextgroup=
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedEOS,

" base_cmd [ 'add' ] 'set' set_spec table_spec
syn cluster nft_c_add_cmd_keyword_set_set_spec_table_spec
\ contains=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id

" base_cmd [ 'add' ] 'set' set_spec
syn cluster nft_c_add_cmd_keyword_set_set_spec
\ contains=@nft_c_add_cmd_keyword_set_set_spec_table_spec
" ************* END set_spec 'set' ('add'|'clean') ***************

" 'set'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_set nftHL_Command
syn match nft_base_cmd_keyword_set "set\>" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon

" do not add ^ regex to nft_base_cmd_add_cmd_keyword_set, already done by nft_line
" 'set'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_set nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_set "set" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_set_set_spec_table_spec_family_spec_family_spec_explicit,
\    nft_add_cmd_keyword_set_cmd_set_spec_table_spec_family_spec_table_id,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon
" do not add ^ regex to nft_base_cmd_add_cmd_keyword_set, already done by nft_line
" ******************** END set_cmd ************************


" ******************* BEGIN base_cmd 'secmark' *************
hi link  nft_add_cmd_keyword_secmark_secmark_block_separator nftHL_Separator
syn match nft_add_cmd_keyword_secmark_secmark_block_separator /;/ skipwhite contained

hi link  nft_add_cmd_keyword_secmark_secmark_block nftHL_BlockDelimitersFlowtable
syn region nft_add_cmd_keyword_secmark_secmark_block start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_add_cmd_keyword_secmark_secmark_block_separator,
\    nft_Error
\ nextgroup=
\    nft_line_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_secmark_config_string nftHL_String
syn match nft_add_cmd_keyword_secmark_secmark_config_string "\v[a-zA-Z][a-zA-Z0-9\\\/\.\-_]{0,63}\ze[ \t]" skipwhite contained

hi link   nft_add_cmd_keyword_secmark_obj_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_secmark_obj_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/\.\-_]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_secmark_block,
\    nft_add_cmd_keyword_secmark_secmark_config,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier nftHL_Table
syn match nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/\.\-_]{0,63}\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOL,
\    nft_Error

hi link   nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit "\v(ip6|ip|inet|netdev|arp|bridge)\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOL,
\    nft_Error

" 'add' 'secmark'
" 'secmark'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_secmark nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_secmark "\vsecmark\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_add_cmd_keyword_secmark_obj_spec_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" ******************* END base_cmd 'secmark' *************

" ******************* BEGIN 'table' *************
""""" BEGIN OF 'add table' <identifier> { chain
""""" BEGIN of table <identifier> { chain <identifier> {"
" add 'table' table_block chain_block hook_spec
" add_cmd 'table' table_block 'chain' chain_block ';'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_separator nftHL_Normal
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_separator ';' skipwhite contained
\ nextgroup=
\    nft_comment_inline

" cmd_add 'table' table_block chain_block hook_spec 'type' prio_spec number
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid nftHL_Number
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid "\v[0-9\-]{1,5}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_separator

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number nftHL_Table
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

" cmd_add 'table' table_block chain_block hook_spec 'type' prio_spec 'priority'
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec nftHL_Command
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec 'priority' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number_valid,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec_number,

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device' string
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string nftHL_Device
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device' variable_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr "\v\$[a-zA-Z0-9\_\-]{1,64}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device'
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec_device_variable_expr_or_string
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_device_string

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'device'
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device "device" skipwhite contained
\ nextgroup=
\    @nft_c_add_table_block_chain_block_hook_spec_dev_spec_device_variable_expr_or_string

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices' flowtable_expr variable_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr "\v\$[a-zA-Z0-9\_\-]{1,64}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec


" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr <string> ','
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma nftHL_Element
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma "," skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string


" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr <string>
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string "\v[a-zA-Z0-9 \t]{1,64}" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr "'" <string> "'"
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles nftHL_String
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles start="\'" end="\'" skip="\\\'" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr '"' <string> '"'
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles nftHL_String
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles start="\"" end="\"" skip="\\\"" skipwhite oneline contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add_cmd 'table' table_block 'chain' chain_block hook_spec 'type' dev_spec 'devices. flowtable_expr flowtable_block flowtable_member_expr
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_comma

" add 'table' table_block chain_block hook_spec dev_spec devices flowtable_expr flowtable_block
hi link    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block skipwhite contained
\ start="{" end="}"
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_variable,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_doubles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string_quote_singles,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_flowtable_expr_flowtable_expr_member_string
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

" add 'table' table_block chain_block hook_spec dev_spec devices flowtable_expr
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec_flowtable_expr
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_flowtable_expr_block,
\    nft_MissingDeviceVariable,
\    nft_UnexpectedEOS

" add 'table' table_block chain_block hook_spec dev_spec devices '='
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal "=" skipwhite contained
\ nextgroup=
\    @nft_c_add_table_block_chain_block_hook_spec_dev_spec_flowtable_expr,
\    nft_UnexpectedEOS

" dev_spec 'devices ='
hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_dev_spec_devices_equal,
\    nft_UnexpectedEOS

" dev_spec (via hook_spec)
hi link     nft_c_add_table_block_chain_block_hook_spec_dev_spec nftHL_Identifier
syn cluster nft_c_add_table_block_chain_block_hook_spec_dev_spec
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_devices,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_device,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks nftHL_Hook
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks "\v(ingress|prerouting|input|forward|output|postrouting)" skipwhite contained
\ nextgroup=
\    @nft_c_add_table_block_chain_block_hook_spec_dev_spec,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_prio_spec,
\    nft_UnexpectedEOS

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook "hook" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_hooks

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types nftHL_Type
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types "\v(filter|route|nat)" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_hook,
\    nft_Semicolon,
\    nft_EOL

hi link   nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type nftHL_Command
syn match nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type "type" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_types

" chain_policy->policy_expr->'policy'->policy_spec->chain_block->'{'->
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy nftHL_Action
syn match nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy "\v(accept|drop)" skipwhite contained

" policy_expr->'policy'->policy_spec->chain_block->'{'->
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr_chain_policy

hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy nftHL_Command
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy "policy" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_policy_spec_policy_expr,
\    nft_Semicolon,
\    nft_EOL,
\    nft_Error

" add_cmd 'table' table_block 'chain' chain_block flags_spec 'offload' ';'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator nftHL_BlockDelimitersChain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator ";" skipwhite contained
\ nextgroup=
\    nft_Semicolon,
" \    nft_hash_comment

" add_cmd 'table' table_block 'chain' chain_block flags_spec 'offload'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_offload nftHL_Action
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_offload "offload" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_flags_spec_separator,
\    nft_Error

" add_cmd 'table' table_block 'chain' chain_block flags_spec 'flags'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_flags nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_flags "\v[ \t]\zsflags" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_offload,
\    nft_Error
" TODO: Add negatation of 'tcp' in 'tcp flags' or add to nextgroup=BUT in chain_block

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

hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_asterisk_string nftHL_Comment
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_asterisk_string start="\*" skip="\\\*" end="\*" keepend oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_unquoted

hi link     nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string nftHL_Comment
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string_unquoted,
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_asterisk_string

" add_cmd 'table' table_block 'chain' chain_block comment_spec 'comment'
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec nftHL_Comment
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec "comment" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec_string

" add_cmd 'table' table_block 'chain' chain_block rule 'rule' comment_spec
"    re-using nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec

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


" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '$'identifier
" '$'identifier->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_member ','
" ','->flowtable_expr_member->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma "," skipwhite contained
\ containedin=nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' <STRING>
" <STRING>->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' '$'identifier
" '$'identifier->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr nftHL_Variable
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_EOS,
\    nftHL_Error

syn match nft_CurlyBraceAheadSilent "\v\ze\}" skipwhite contained

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' <QUOTED_STRING>
" <QUOTED_STRING>->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string nftHL_String
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string "\v\"[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,63}\"" keepend skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_comma,
\    nft_CurlyBraceAheadSilent,
\    nftHL_EOS,
\    nftHL_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_member
" flowtable_expr_member->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string

hi link   nft_MissingDeviceVariable2 nftHL_Error
syn match nft_MissingDeviceVariable2 "\v[^\$\{\}]{1,5}" skipwhite contained " do not use 'keepend' here

syn cluster nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block
\ contains=@nft_c_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member

" 'table' identifier '{' 'chain' identifier '{' 'devices' '=' '{' flowtable_expr_block
" flowtable_expr_block->'{'->'='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block start=/{/ end=/}/ skipwhite contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_quoted_string,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block_flowtable_expr_member_string
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator,

" 'table' identifier '{' 'chain' identifier '{' 'devices' '='
" '='->'devices'->chain_block->'chain'->table_block->'table'->add_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal nftHL_Operator
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_variable_expr,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_flowtable_expr_block,
\    nft_UnexpectedSemicolon,
\    nft_Error

" 'table' identifier '{' 'chain' identifier '{' 'devices'
" 'devices'->chain_block->'chain'->table_block->'table'->add_cmd->base_cmd->line
" 'devices'->chain_block->'chain'->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_devices nftHL_Statement
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices_equal

hi link   nft_chainError nftHL_Error
syn match nft_chainError /"v[a-zA-Z0-9\\\/_\.;:]{1,64}/ skipwhite contained

" common_block is contains=lastly due to 'comment' in chain_block & chain_block/rule
" 'table' identifier '{' 'chain' identifier '{' chain_block
" chain_block->'chain'->table_block->'table'->add_cmd->base_cmd->line
" chain_block->'chain'->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_block nftHL_BlockDelimitersChain
syn region nft_add_cmd_keyword_table_table_block_chain_chain_block start="{" end="}" skipwhite contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_comment_inline
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_comment_spec,
\    nft_add_cmd_keyword_table_table_block_chain_block_hook_spec_keyword_type,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_policy_spec_keyword_policy,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_flags_spec_flags,
\    nft_add_cmd_keyword_table_table_block_chain_chain_block_devices,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_comment_spec,
\    @nft_c_add_cmd_keyword_table_table_block_chain_chain_block_rule_rule_alloc
"\    nextgroup=nft_hash_comment

"\ contains=
"\ nextgroup=
"\    nft_add_cmd_keyword_table_table_block_chain_flags_spec,
"\    nft_add_cmd_keyword_table_table_block_chain_rule_spec,
"\    nft_add_cmd_keyword_table_table_block_chain_device_keyword
" \ contains=ALLBUT,
" \    nft_add_table_options_flag_keyword,
" \    nft_add_table_options_comment_spec,
" \    nft_add_cmd_table_block_keyword_chain

" 'table' 'T' '{' 'chain' 'C' '{' ';'
" ';'->stmt_separator->chain_block->'chain'->table_block->'table'->add_cmd->base_cmd
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator nftHL_Expression
syn match nft_add_cmd_keyword_table_table_block_chain_chain_block_stmt_separator contained /\v\s{0,8}[\n;]{1,15}/  skipwhite contained
\ nextgroup=
\    nft_comment_inline

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" keepend skipwhite contained

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link   nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote nftHL_Chain
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote "\v[a-zA_Z][a-zA-Z0-9\\\/_\.\-]{0,63}" keepend skipwhite contained

" add_cmd 'table' table_block 'chain' chain_spec table_id chain_id
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single nftHL_Chain
syn region nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single start="'" skip="\\\'" end="'" keepend skipwhite oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_single_quote
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block

" add_cmd 'table' table_block 'chain' <DOUBLE_STRING>
hi link    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double nftHL_Chain
syn region nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double start="\"" skip="\\\"" end="\"" keepend skipwhite oneline contained
\ contains=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_sans_double_quote
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block

" add_cmd 'table' table_block 'chain' 'last'
hi link  nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last nftHL_Action
syn match nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_block

" add_cmd 'table' table_block 'chain'
hi link   nft_add_cmd_table_block_keyword_chain nftHL_Command
syn match nft_add_cmd_table_block_keyword_chain "chain" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_single,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_double,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_last,
\    nft_add_cmd_keyword_table_table_block_chain_chain_identifier_string_unquoted
""""" END OF table <identifier> { chain



" ************* BEGIN table_block 'set' set_block ***************
"  this is NOT the 'set' found inside the chain_block
"  this IS the 'set' found inside the table_block

hi link   nft_add_cmd_table_block_set_block_separator nftHL_Normal
syn match nft_add_cmd_table_block_set_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_comment_inline

" base_cmd add_cmd 'table' 'set' set_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr skipwhite contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_table_block_set_block_typeof_key_expr_type_data_type_expr nftHL_Action
syn match nft_add_cmd_table_block_set_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'type'
hi link   nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_type nftHL_Command
syn match nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_type "type" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9]{0,63}){0,23}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr_with_dot

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_typeof nftHL_Command
syn match nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_set_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'set' set_spec '{' set_block typeof_key_expr
syn cluster nft_c_add_cmd_table_block_set_block_typeof_key_expr
\ contains=
\    nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_typeof,
\    nft_add_cmd_table_block_set_block_typeof_key_expr_keyword_type

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag ','
hi link   nft_add_cmd_table_block_set_block_set_flag_list_comma nftHL_Operator
syn match nft_add_cmd_table_block_set_block_set_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_set_block_set_flag_list

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list set_flag
hi link   nft_add_cmd_table_block_set_block_set_flag_list_item nftHL_Action
syn match nft_add_cmd_table_block_set_block_set_flag_list_item skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_table_block_set_block_set_flag_list_comma

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags' set_flag_list
syn cluster nft_c_add_cmd_table_block_set_block_set_flag_list
\ contains=
\    nft_add_cmd_table_block_set_block_set_flag_list_item

" base_cmd add_cmd 'set' set_spec '{' set_block 'flags'
hi link   nft_add_cmd_table_block_set_block_keyword_flags nftHL_Command
syn match nft_add_cmd_table_block_set_block_keyword_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_set_block_set_flag_list


" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_table_block_set_block_time_spec nftHL_Number
syn match nft_add_cmd_table_block_set_block_time_spec "\v[a-zA-Z0-9\\\/_\.\:]{1,31}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block 'timeout'
hi link   nft_add_cmd_table_block_set_block_keyword_timeout nftHL_Command
syn match nft_add_cmd_table_block_set_block_keyword_timeout "timeout" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_time_spec

" base_cmd add_cmd 'set' set_spec '{' set_block 'gc-interval'
hi link   nft_add_cmd_table_block_set_block_keyword_gc_interval nftHL_Command
syn match nft_add_cmd_table_block_set_block_keyword_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_time_spec

" unused nft_add_cmd_keyword_set_set_spec_set_block_element_set_block_semicolon
hi link   nft_add_cmd_table_block_set_block_set_block_expr_set_expr_comma nftHL_Operator
syn match nft_add_cmd_table_block_set_block_set_block_expr_set_expr_comma /,/ skipwhite contained

hi link    nft_add_cmd_table_block_set_block_set_block_expr_set_expr nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_set_block_set_block_expr_set_expr start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_table_block_set_block_set_block_expr_set_expr_comma,
\    nft_set_expr

hi link   nft_add_cmd_table_block_set_block_set_block_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_table_block_set_block_set_block_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_EOS

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements' '='
hi link   nft_add_cmd_table_block_set_block_elements_equal nftHL_Operator
syn match nft_add_cmd_table_block_set_block_elements_equal /=/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_set_block_expr_variable_expr,
\    nft_set_expr

" base_cmd add_cmd 'set' set_spec '{' set_block 'elements'
hi link   nft_add_cmd_table_block_set_block_keyword_elements nftHL_Command
syn match nft_add_cmd_table_block_set_block_keyword_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_elements_equal

" base_cmd add_cmd 'set' set_spec '{' set_block 'automerge'
hi link   nft_add_cmd_table_block_set_block_automerge nftHL_Command
syn match nft_add_cmd_table_block_set_block_automerge "auto\-merge" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_separator,

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size' <interval>
hi link   nft_add_cmd_table_block_set_block_set_mechanism_size_value nftHL_Number
syn match nft_add_cmd_table_block_set_block_set_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'size'
hi link   nft_add_cmd_table_block_set_block_set_mechanism_size nftHL_Command
syn match nft_add_cmd_table_block_set_block_set_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_set_mechanism_size_value


" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'memory'
hi link   nft_add_cmd_table_block_set_block_set_mechanism_policy_memory nftHL_Action
syn match nft_add_cmd_table_block_set_block_set_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy' 'performance'
hi link   nft_add_cmd_table_block_set_block_set_mechanism_policy_performance nftHL_Action
syn match nft_add_cmd_table_block_set_block_set_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_separator

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism 'policy'
hi link   nft_add_cmd_table_block_set_block_set_mechanism_policy nftHL_Command
syn match nft_add_cmd_table_block_set_block_set_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_set_mechanism_policy_memory,
\    nft_add_cmd_table_block_set_block_set_mechanism_policy_performance

" base_cmd add_cmd 'set' set_spec '{' set_block set_mechanism
syn cluster nft_c_add_cmd_table_block_set_block_set_mechanism
\ contains=
\    nft_add_cmd_table_block_set_block_set_mechanism_size,
\    nft_add_cmd_table_block_set_block_set_mechanism_policy

" base_cmd add_cmd 'table' table_block 'set' identifier '{' set_block '}'
hi link    nft_add_cmd_table_block_set_block_delimiters nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_set_block_delimiters start="{" end="}" skip="\\{" skipwhite contained
\ contains=
\    @nft_c_add_cmd_table_block_set_block_typeof_key_expr,
\    nft_add_cmd_table_block_set_block_keyword_flags,
\    nft_add_cmd_table_block_set_block_keyword_timeout,
\    nft_add_cmd_table_block_set_block_keyword_gc_interval,
\    @nft_c_stateful_stmt,
\    @nft_c_add_cmd_table_block_set_block_set_mechanism,
\    nft_add_cmd_table_block_set_block_keyword_elements,
\    nft_add_cmd_table_block_set_block_automerge
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" base_cmd add_cmd 'table' table_block 'set' identifier
hi link   nft_add_cmd_table_block_keyword_set_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_set_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_delimiters

" base_cmd add_cmd 'table' table_block 'set' 'last'
hi link   nft_add_cmd_table_block_keyword_set_identifier_keyword_last nftHL_Action
syn match nft_add_cmd_table_block_keyword_set_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_set_block_delimiters

" base_cmd add_cmd 'table' table_block 'set'
hi link   nft_add_cmd_table_block_keyword_set nftHL_Command
syn match nft_add_cmd_table_block_keyword_set "set" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_set_identifier_keyword_last,
\    nft_add_cmd_table_block_keyword_set_identifier,

" ************* END table_block 'set' set_block ***************
" SLE7 end
" ************* BEGIN table_block 'map' map ***************
"  this is NOT the 'map' found inside the chain_block
"  this IS the 'map' found inside the table_block

hi link   nft_add_cmd_table_block_map_block_separator nftHL_Normal
syn match nft_add_cmd_table_block_map_block_separator /;/ skipwhite contained
\ nextgroup=
\    nft_comment_inline

" base_cmd add_cmd 'table' 'map' map_block typeof_key_expr 'type' typeof_expr primary_expr
hi link   nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr skipwhite contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}"
" do not use 'skipwhite' here

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'  <family>
hi link   nft_add_cmd_table_block_map_block_typeof_key_expr_type_data_type_expr nftHL_Action
syn match nft_add_cmd_table_block_map_block_typeof_key_expr_type_data_type_expr "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'type'
hi link   nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_type nftHL_Command
syn match nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_type "type" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_typeof_key_expr_type_data_type_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr primary_expr
hi link   nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr nftHL_Identifier
syn match nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr contained
\  "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}(\.[a-zA-Z][a-zA-Z0-9]{0,63}){0,23}" contained  " do not use 'skipwhite' here
\ nextgroup=
\    nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr_with_dot

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof' typeof_expr
syn cluster nft_c_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr
\ contains=
\    nft_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr_primary_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr 'typeof'
hi link   nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_typeof nftHL_Command
syn match nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_typeof "typeof" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_map_block_typeof_key_expr_typeof_expr

" base_cmd_add_cmd 'map' map_spec '{' map_block typeof_key_expr
syn cluster nft_c_add_cmd_table_block_map_block_typeof_key_expr
\ contains=
\    nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_typeof,
\    nft_add_cmd_table_block_map_block_typeof_key_expr_keyword_type

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag ','
hi link   nft_add_cmd_table_block_map_block_map_flag_list_comma nftHL_Operator
map match nft_add_cmd_table_block_map_block_map_flag_list_comma "," skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_map_block_map_flag_list

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list map_flag
hi link   nft_add_cmd_table_block_map_block_map_flag_list_item nftHL_Action
syn match nft_add_cmd_table_block_map_block_map_flag_list_item skipwhite contained
\ "\v(constant|interval|timeout|dynamic)"
\ nextgroup=
\    nft_add_cmd_table_block_map_block_map_flag_list_comma

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags' map_flag_list
syn cluster nft_c_add_cmd_table_block_map_block_map_flag_list
\ contains=
\    nft_add_cmd_table_block_map_block_map_flag_list_item

" base_cmd add_cmd 'map' map_spec '{' map_block 'flags'
hi link   nft_add_cmd_table_block_map_block_keyword_flags nftHL_Command
syn match nft_add_cmd_table_block_map_block_keyword_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_table_block_map_block_map_flag_list


" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'/'gc-interval' time_spec
hi link   nft_add_cmd_table_block_map_block_time_spec nftHL_Number
syn match nft_add_cmd_table_block_map_block_time_spec "\v[a-zA-Z0-9\\\/_\.\:]{1,31}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_separator

" base_cmd add_cmd 'map' map_spec '{' map_block 'timeout'
hi link   nft_add_cmd_table_block_map_block_keyword_timeout nftHL_Command
syn match nft_add_cmd_table_block_map_block_keyword_timeout "timeout" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_time_spec

" base_cmd add_cmd 'map' map_spec '{' map_block 'gc-interval'
hi link   nft_add_cmd_table_block_map_block_keyword_gc_interval nftHL_Command
syn match nft_add_cmd_table_block_map_block_keyword_gc_interval "\vgc\-interval" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_time_spec

" unused nft_add_cmd_keyword_map_map_spec_map_block_element_map_block_semicolon
hi link   nft_add_cmd_table_block_map_block_map_block_expr_map_expr_comma nftHL_Operator
syn match nft_add_cmd_table_block_map_block_map_block_expr_map_expr_comma /,/ skipwhite contained

hi link    nft_add_cmd_table_block_map_block_map_block_expr_map_expr nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_map_block_map_block_expr_map_expr start="{" end="}" skipnl skipempty skipwhite contained
\ contains=
\    nft_add_cmd_table_block_map_block_map_block_expr_map_expr_comma,
\    nft_map_expr

hi link   nft_add_cmd_table_block_map_block_map_block_expr_variable_expr nftHL_Variable
syn match nft_add_cmd_table_block_map_block_map_block_expr_variable_expr "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_EOS

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements' '='
hi link   nft_add_cmd_table_block_map_block_elements_equal nftHL_Operator
syn match nft_add_cmd_table_block_map_block_elements_equal /=/ skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_map_block_expr_variable_expr,
\    nft_map_expr

" base_cmd add_cmd 'map' map_spec '{' map_block 'elements'
hi link   nft_add_cmd_table_block_map_block_keyword_elements nftHL_Command
syn match nft_add_cmd_table_block_map_block_keyword_elements "elements" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_elements_equal

" base_cmd add_cmd 'map' map_spec '{' map_block 'automerge'
hi link   nft_add_cmd_table_block_map_block_automerge nftHL_Command
syn match nft_add_cmd_table_block_map_block_automerge "auto\-merge" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_separator,

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'size' <interval>
hi link   nft_add_cmd_table_block_map_block_map_mechanism_size_value nftHL_Number
syn match nft_add_cmd_table_block_map_block_map_mechanism_size_value "\v[0-9]{1,32}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'size'
hi link   nft_add_cmd_table_block_map_block_map_mechanism_size nftHL_Command
syn match nft_add_cmd_table_block_map_block_map_mechanism_size "size" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_map_mechanism_size_value


" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy' 'memory'
hi link   nft_add_cmd_table_block_map_block_map_mechanism_policy_memory nftHL_Action
syn match nft_add_cmd_table_block_map_block_map_mechanism_policy_memory "memory" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_separator,
\    nft_comment_inline

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy' 'performance'
hi link   nft_add_cmd_table_block_map_block_map_mechanism_policy_performance nftHL_Action
syn match nft_add_cmd_table_block_map_block_map_mechanism_policy_performance "performance" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_separator

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism 'policy'
hi link   nft_add_cmd_table_block_map_block_map_mechanism_policy nftHL_Command
syn match nft_add_cmd_table_block_map_block_map_mechanism_policy "policy" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_map_mechanism_policy_memory,
\    nft_add_cmd_table_block_map_block_map_mechanism_policy_performance

" base_cmd add_cmd 'map' map_spec '{' map_block map_mechanism
syn cluster nft_c_add_cmd_table_block_map_block_map_mechanism
\ contains=
\    nft_add_cmd_table_block_map_block_map_mechanism_size,
\    nft_add_cmd_table_block_map_block_map_mechanism_policy

" base_cmd add_cmd 'table' table_block 'map' identifier '{' map_block '}'
hi link    nft_add_cmd_table_block_map_block_delimiters nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_map_block_delimiters start="{" end="}" skip="\\{" skipwhite contained
\ contains=
\    @nft_c_add_cmd_table_block_map_block_typeof_key_expr,
\    nft_add_cmd_table_block_map_block_keyword_flags,
\    nft_add_cmd_table_block_map_block_keyword_timeout,
\    nft_add_cmd_table_block_map_block_keyword_gc_interval,
\    @nft_c_stateful_stmt,
\    @nft_c_add_cmd_table_block_map_block_map_mechanism,
\    nft_add_cmd_table_block_map_block_keyword_elements,
\    nft_add_cmd_table_block_map_block_automerge
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" base_cmd add_cmd 'table' table_block 'map' identifier
hi link   nft_add_cmd_table_block_keyword_map_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_map_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_delimiters

" base_cmd add_cmd 'table' table_block 'map' 'last'
hi link   nft_add_cmd_table_block_keyword_map_identifier_keyword_last nftHL_Action
syn match nft_add_cmd_table_block_keyword_map_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_map_block_delimiters

" base_cmd add_cmd 'table' table_block 'map'
hi link   nft_add_cmd_table_block_keyword_map nftHL_Command
syn match nft_add_cmd_table_block_keyword_map "map" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_map_identifier_keyword_last,
\    nft_add_cmd_table_block_keyword_map_identifier,

" ************* END table_block 'map' map_block ***************
" ************* BEGIN table_block 'flowtable' flowtable_block ***************
hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int nftHL_Integer
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int "\v\-?[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_EOS

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var nftHL_Variable
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained

hi link   nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign nftHL_Expression
syn match nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign "\v[-+]" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name nftHL_Action
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name "\v[a-zA-Z][a-zA-Z]{1,16}" skipwhite contained
\ nextgroup=
\     nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_sign

syn cluster nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended
\ contains=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_int,
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_var,
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended_name

hi link   nft_add_cmd_block_table_flowtable_block_hook_keyword_priority nftHL_Action
syn match nft_add_cmd_block_table_flowtable_block_hook_keyword_priority "priority" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_block_hook_keyword_priority_extended

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double nftHL_String
syn region nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double start='"' end='"' skip="\\\"" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single nftHL_String
syn region nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single start="'" end="'" skip="\\\'" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

hi link    nft_add_cmd_block_table_flowtable_block_hook_string_unquoted nftHL_String
syn match nft_add_cmd_block_table_flowtable_block_hook_string_unquoted "\v[a-zA-Z0-9]{1,64}" skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_hook_keyword_priority

syn cluster nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_hook_string
\ contains=
\    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_double,
\    nft_add_cmd_block_table_flowtable_block_hook_string_quoted_single,
\    nft_add_cmd_block_table_flowtable_block_hook_string_unquoted

hi link   nft_add_cmd_block_table_flowtable_block_stmt_separator nftHL_Operator
syn match nft_add_cmd_block_table_flowtable_block_stmt_separator ";" skipwhite contained

" base_cmd_add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'hook'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook "\v[{ ;]\zshook\ze[;} ]" skipwhite skipnl skipempty contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_hook_string

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list flowtable_flag
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag nftHL_Action
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag skipwhite contained
\ "\v(offload)"
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags' flowtable_flag_list
syn cluster nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_flowtable_flag_list
\ contains=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags_flowtable_flag_list_flowtable_flag

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'flags'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_block_table_flowtable_spec_flowtable_block_flowtable_flag_list,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" TODO: [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '=' flowtable_expr
" flowtable_block_expr->'='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line

" base_cmd add_cmd 'flowtable' flowtable_spec '{' flowtable_block 'counter'
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter "counter" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_CurlyBraceAheadSilent,
\    nft_Error

hi link    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr nftHL_BlockDelimitersFlowtable
syn region nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr start="{" end="}" skipwhite contained

hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable nftHL_Variable
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable "\v\$[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices' '='
" '='->'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal nftHL_Expression
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal "=" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_flowtable_block_expr,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_expr_variable

" [ 'add' ] 'flowtable' table_id flow_id '{' 'devices'
" 'devices'->flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link   nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices nftHL_Statement
syn match nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices "devices" skipwhite contained
\ nextgroup=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices_equal

" [ 'add' ] 'flowtable' table_id flow_id '{' flowtable_block
" flowtable_block->'{'->'flowtable'->add_cmd->base_cmd->line
hi link    nft_add_cmd_block_table_flowtable_spec_flowtable_block nftHL_BlockDelimitersFlowTable
syn region nft_add_cmd_block_table_flowtable_spec_flowtable_block start="{" end="}" skipwhite contained
\ nextgroup=
\    nft_comment_inline,
\    nft_Semicolon,
\    nft_EOS,
\    nft_Error
\ contains=
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_counter,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_devices,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_flags,
\    nft_add_cmd_block_table_flowtable_spec_flowtable_block_hook,
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_comment_spec,
\    nft_add_cmd_block_table_flowtable_block_stmt_separator,
\    nft_Error

" base_cmd add_cmd 'table' table_block 'flowtable' identifier '{' flowtable_block '}'
hi link    nft_add_cmd_table_block_flowtable_block_delimiters nftHL_BlockDelimitersSet
syn region nft_add_cmd_table_block_flowtable_block_delimiters start="{" end="}" skip="\\{" skipwhite contained
\ contains=
\    @nft_c_flowtable_block
\ nextgroup=
\    nft_comment_inline,
\    nft_line_stmt_separator

" base_cmd add_cmd 'table' table_block 'flowtable' identifier
hi link   nft_add_cmd_table_block_keyword_flowtable_identifier nftHL_Identifier
syn match nft_add_cmd_table_block_keyword_flowtable_identifier "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_flowtable_block_delimiters

" base_cmd add_cmd 'table' table_block 'flowtable' 'last'
hi link   nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last nftHL_Action
syn match nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_flowtable_block_delimiters

" base_cmd add_cmd 'table' table_block 'flowtable'
hi link   nft_add_cmd_table_block_keyword_flowtable nftHL_Command
syn match nft_add_cmd_table_block_keyword_flowtable "flowtable" skipwhite contained
\ nextgroup=
\    nft_add_cmd_table_block_keyword_flowtable_identifier_keyword_last,
\    nft_add_cmd_table_block_keyword_flowtable_identifier,

" ************* END table_block 'flowtable' flowtable_block ***************
""""""""" END OF INSIDE THE TABLE BLOCK """""""""""""""""""""""""""""""""""""""""""""""

" base_cmd add_cmd 'table' table_block table_options ';'
hi link   nft_add_cmd_keyword_table_table_block_table_options_semicolon nftHL_Normal
syn match nft_add_cmd_keyword_table_table_block_table_options_semicolon ";" skipwhite contained

" base_cmd_add_cmd 'table'  table_blocktable_options
syn cluster nft_c_add_cmd_keyword_table_table_block_table_options
\ contains=
\    nft_add_cmd_keyword_table_table_options_table_keyword_flags,
\    nft_add_cmd_keyword_table_table_options_comment_spec,
\    nft_add_cmd_keyword_table_table_block_table_options_semicolon  " this makes it unique apart from nft_add_chain
\    nft_UnexpectedEOS

" table_block 'chain' (via table_block)
" hi link   nft_chain_identifier_keyword nftHL_Command
" syn match nft_chain_identifier_keyword ^\vchain skipnl skipwhite contained


" [ [ 'add' ] 'table' ] table_id '{' ';'
" ';'->stmt_separator->table_block->'table'->add_cmd->'add'->base_cmd->line
hi link   nft_table_block_stmt_separator nftHL_BlockDelimitersTable
syn match nft_table_block_stmt_separator "\v(\n|;)" skipwhite contained

" [ [ 'add' ] 'table' ] table_id '{'
" table_block->add_cmd->base_cmd->line
" table_block->'table'->add_cmd->'add'->base_cmd->line
hi link    nft_add_cmd_keyword_table_table_block nftHL_BlockDelimitersTable
syn region nft_add_cmd_keyword_table_table_block start="{" end="}" skipnl skipempty skipwhite contained
\ nextgroup=
\    nft_table_block_stmt_separator,
\    nft_EOS
\ containedin=
\    nft_add_cmd_keyword_table_table_options_comment_spec,
\    nft_add_cmd_keyword_table_table_options_table_flag_keyword,
\    nft_add_cmd_keyword_table_table_block_table_options_semicolon
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_comment_inline,
\    nft_comment_spec,
\    @nft_c_add_cmd_keyword_table_table_block_table_options,
\    nft_add_cmd_table_block_keyword_chain,
\    nft_add_cmd_table_block_keyword_set,
\    nft_add_cmd_table_block_keyword_map,
\    nft_add_cmd_table_block_keyword_flowtable
"\    nextgroup=nft_hash_comment,


" base_cmd add_cmd 'table' table_spec family_spec identifier
hi link   nft_add_table_spec_identifier nftHL_Identifier
syn match nft_add_table_spec_identifier "\v[a-zA-Z][A-Za-z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block,
\    nft_comment_inline,
\    nft_Semicolon,
\    nft_EOS

hi link   nft_add_table_spec_identifier_keyword_last nftHL_Action
syn match nft_add_table_spec_identifier_keyword_last "last" skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block,
\    nft_comment_inline,
\    nft_Semicolon,
\    nft_EOS

" base_cmd add_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_add_table_spec_family_spec_valid nftHL_Family
syn match nft_add_table_spec_family_spec_valid "\v(ip6?|inet|arp|bridge|netdev)" skipwhite contained
\ nextgroup=
\    nft_add_table_spec_identifier_keyword_last,
\    nft_add_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'table' table_spec
syn cluster nft_c_add_table_spec
\ contains=
\    nft_add_table_spec_identifier_keyword_last,
\    nft_add_table_spec_family_spec_valid,
\    nft_add_table_spec_identifier

""""""""" BEGIN OF INSIDE THE TABLE BLOCK """""""""""""""""""""""""""""""""""""""""""""""
" table_flag (via table_options 'flags')
hi link   nft_add_table_options_flag_list_item_comma nftHL_Expression
syn match nft_add_table_options_flag_list_item_comma ',' skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_table_options_table_flag_recursive

hi link   nft_add_table_options_flag_list_item nftHL_String
syn match nft_add_table_options_flag_list_item "\v[a-zA-Z][a-zA-Z0-9\/\\_\.\-]{0,64}" skipwhite contained
\ nextgroup=
\    nft_add_table_options_flag_list_item_comma,
\    nft_Semicolon

" add_cmd 'table' table_block table_options 'flags' table_flag
syn cluster nft_c_add_cmd_keyword_table_table_block_table_options_table_flag_recursive
\ contains=
\    nft_add_table_options_flag_list_item

" add_cmd 'table' table_block table_options 'flags'
hi link   nft_add_cmd_keyword_table_table_options_table_keyword_flags nftHL_Statement
syn match nft_add_cmd_keyword_table_table_options_table_keyword_flags "flags" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_keyword_table_table_block_table_options_table_flag_recursive,
\    nft_Semicolon

" 'chain'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_chain nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_chain "\vchain\ze[ \t]" skipwhite contained
\ nextgroup=
\    @nft_c_add_cmd_chain_spec
" ******************* END 'table' *************

" *************** BEGIN create_cmd *******************
hi link   nft_create_cmd_keyword_table_identifier_chain nftHL_Table
syn match nft_create_cmd_keyword_table_identifier_chain "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_c_add_table_spec,
\    nft_EOS

hi link   nft_create_cmd_keyword_table_identifier_table nftHL_Table
syn match nft_create_cmd_keyword_table_identifier_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_identifier_chain,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_table_absolute_family_spec nftHL_Family
syn match nft_create_cmd_keyword_table_absolute_family_spec "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_table nftHL_Statement
syn match nft_create_cmd_keyword_table "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_table_absolute_family_spec,
\    nft_create_cmd_keyword_table_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS
" **************** END 'create' 'table' *********************

" **************** BEGIN 'create' 'secmark' *********************

hi link   nft_create_cmd_keyword_secmark_secmark_config_string_unquoted nftHL_String
syn match nft_create_cmd_keyword_secmark_secmark_config_string_unquoted "\v[a-zA-Z0-9\\\/_\-\.\[\]\(\) ]{2,45}" skipwhite contained

hi link    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single nftHL_String
syn region nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single start="\'" end="\'" skip="\\\'" skipwhite contained

hi link    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double nftHL_String
syn region nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double start="\"" end="\"" skip="\\\"" oneline skipwhite contained


hi link   nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark nftHL_Identifier
syn match nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_single,
\    nft_create_cmd_keyword_secmark_secmark_config_string_quoted_double,
\    nft_create_cmd_keyword_secmark_secmark_config_string_unquoted,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table nftHL_Table
syn match nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table "\v[a-zA-Z][a-zA-Z0-9\\\/_\.\-]{0,63}" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_identifier_secmark,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit nftHL_Family
syn match nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit "\v(ip6?|inet|netdev|bridge|arp)" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS

hi link   nft_create_cmd_keyword_secmark nftHL_Command
syn match nft_create_cmd_keyword_secmark "secmark" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" **************** END 'create' 'secmark' *********************
" **************** BEGIN 'create' 'synproxy' *********************
hi link   nft_create_cmd_keyword_synproxy nftHL_Command
syn match nft_create_cmd_keyword_synproxy "synproxy" skipwhite contained
\ nextgroup=
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_family_spec_explicit,
\    nft_create_cmd_keyword_secmark_obj_spec_table_spec_identifier_table,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" 'table'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_table nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_table "\vtable\ze[ \t]" skipwhite contained
\ nextgroup=
\    nft_add_table_spec_identifier_keyword_last,
\    nft_add_table_spec_family_spec_valid,
\    nft_add_table_spec_identifier

" 'create'->base_cmd->line
hi link   nft_base_cmd_keyword_create nftHL_Command
syn match nft_base_cmd_keyword_create "create" skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_create_cmd_keyword_synproxy,
\    nft_base_cmd_add_cmd_keyword_counter,
\    nft_get_et_al_cmd_keyword_element,
\    nft_create_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_keyword_table,
\    nft_base_cmd_add_cmd_keyword_chain,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_ct,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error
" *************** END create_cmd *******************





" common_block
" common_block (via chain_block, counter_block, ct_expect_block, ct_helper_block,
"                   ct_timeout_block, flowtable_block, limit_block, line, map_block,
"                   quota_block, secmark_block, set_block, synproxy_block, table_block

" common_block 'define'/'redefine identifier <STRING> '=' initializer_expr
" common_block 'define'/'redefine identifier <STRING> '=' rhs_expr
" common_block 'define'/'redefine identifier <STRING> '=' list_rhs_expr
" common_block 'define'/'redefine identifier <STRING> '=' '{' '}'
" common_block 'define'/'redefine identifier <STRING> '=' '-'number
" common_block 'define'/'redefine identifier '=' rhs_expr concat_rhs_expr basic_rhs_expr


" END OF common_block

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string nftHL_Variable
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string /\v(\=|\s)\zs\'[a-zA-Z][a-zA-Z0-9]{1,64}\'\ze($|\s|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string_list_comma,
\    nft_common_block_stmt_separator
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string /\v(\=|\s)\zs\"[a-zA-Z][a-zA-Z0-9]{1,64}\"\ze($|\s|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable nftHL_Variable
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable /\v(\=|\s)\zs\$[a-zA-Z][a-zA-Z0-9]{1,64}\ze($|\s|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier nftHL_Identifier
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier /\v(\=|\s)\zs[a-zA-Z][a-zA-Z0-9]{1,64}\ze($|\s|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP nftHL_Number
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP /\v(\=|\s)\zs[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\ze($|\s|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr_list_comma nftHL_Element
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr_list_comma /,/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr /\v(\=|\s)\zs\d{1,10}\ze($|\-|(\s+[^\-])|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second /\v\d{1,10}\ze( |$)/ skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_EOS,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_dash_symbol nftHL_Expression
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_dash_symbol '-' contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second,
\    nft_Error_Always

hi link   nft_PortRangeDashInvalid nftHL_Error
syn match nft_PortRangeDashInvalid /\v\d{1,10}\s+-/ contained

hi link   nft_PortRangeBadDashSpaceBefore nftHL_Error
syn match nft_PortRangeBadDashSpaceBefore /\v\d{1,10}\s+-/ contained

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range /\v(\=|\s)\zs\d{1,10}\ze\-/ contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_dash_symbol,
\    nft_PortRangeDashInvalid,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash_num nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash_num "\v[0-9]{1,10}" skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_EOS

" '-'->initializer_expr->common_block
hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash nftHL_Operator
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash "-" contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_dash_num,
\    nft_Error_Always


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

" common_block 'define'/'
" common_block 'define'/'redefine identifier '='
hi link   nft_common_block_define_redefine_equal nftHL_Operator
syn match nft_common_block_define_redefine_equal '=' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block,
\    nft_common_block_define_redefine_keywords_initializer_expr_dash,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier,
\    nft_Error_Any

" common_block 'define'/'redefine identifier <STRING>
hi link   nft_common_block_define_redefine_keywords_identifier nftHL_Identifier
syn match nft_common_block_define_redefine_keywords_identifier '\v\zs[a-zA-Z_][a-zA-Z0-9_-]{0,63}\s{0,32}' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_equal,
\    nft_Error_Always

" 'define' (via "
" commmon_block 'redefine' (via common_block)
hi link   nft_common_block_keyword_redefine nftHL_Command
syn match nft_common_block_keyword_redefine contained "redefine\ze\s" skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_identifier

" common_block 'define' (via common_block)
hi link   nft_common_block_keyword_define nftHL_Command
syn match nft_common_block_keyword_define contained "\vdefine\ze\s" skipwhite contained
\ containedin=nft_c_common_block
\ nextgroup=
\    nft_common_block_define_redefine_keywords_identifier

" common_block 'undefine' identifier (via common_block 'undefine')

hi link   nft_common_block_undefine_identifier_string nftHL_Identifier
syn match nft_common_block_undefine_identifier_string '\v[a-zA-Z][A-Za-z0-9_]{0,63}' skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_UnexpectedCurlyBrace,
\    nft_EOS,
\    nft_Error

hi link   nft_common_block_undefine_identifier_last nftHL_Keyword
syn match nft_common_block_undefine_identifier_last '\<last\>' contained
\ containedin=
\    nft_common_block_undefine_identifier_string,
\    nft_common_block_define_redefine_keywords_identifier

" commmon_block 'undefine' (via common_block)
hi link   nft_common_block_keyword_undefine nftHL_Command
syn match nft_common_block_keyword_undefine "\vundefine\ze\s" skipwhite contained
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

hi link   nft_base_cmd_keyword_add nftHL_Command
syn match nft_base_cmd_keyword_add /add/ skipwhite contained
\ nextgroup=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_base_cmd_add_cmd_keyword_synproxy,
\    nft_base_cmd_add_cmd_keyword_counter,
\    nft_base_cmd_add_cmd_keyword_element,
\    nft_base_cmd_add_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_keyword_chain,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_table,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_ct,
\    nft_base_cmd_add_cmd_rule_position_table_spec_wildcard,
" insert nft_base_cmd_add_cmd_rule_position_table_spec_wildcard in nft_base_cmd_keyword_add is CPU-intensive"

syn cluster nft_c_base_cmd_add_cmd_unused_placeholder
\ contains=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_base_cmd_add_cmd_synproxy_keyword,
\    nft_base_cmd_add_cmd_counter_keyword,
\    nft_base_cmd_add_cmd_keyword_element,
\    nft_base_cmd_add_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_keyword_chain,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_table,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_ct

" common_block cluster is used only within any '{' block '}'
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

" `line` main top-level syntax, do not add 'contained' here.
" `line` is the only syntax with '^' caret (begin of line) regex pattern"
" limit to 63-char whitespaces from 1st column (for Vim syntax session speed)
hi link   nft_line Normal
syn match nft_line "^\v\s{0,63}"
\ nextgroup=
\    nft_base_cmd_add_cmd_keyword_flowtable,
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
\    nft_base_cmd_keyword_export,
\    nft_base_cmd_keyword_import,
\    nft_base_cmd_keyword_insert,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_keyword_rename,
\    nft_base_cmd_add_cmd_chain_keyword,
\    nft_common_block_keyword_error,
\    nft_base_cmd_keyword_flush,
\    nft_base_cmd_add_cmd_keyword_limit,
\    nft_base_cmd_add_cmd_keyword_quota,
\    nft_base_cmd_keyword_reset,
\    nft_base_cmd_add_cmd_keyword_table,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_base_cmd_keyword_list,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_base_cmd_keyword_get,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_base_cmd_add_cmd_keyword_map,
\    nft_base_cmd_add_cmd_keyword_set,
\    nft_base_cmd_add_cmd_keyword_ct,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
\    nft_line_inline_comment,
\    nft_line_stmt_separator,
\    nft_base_cmd_add_cmd_rule_position_table_spec_wildcard,
\    nft_Error_Always
" practically no way to highlight an incorrect first alphanum token due
" to unquoted_table_identifier as the first token
" 'nft_Error_Always' is that catch-all for 1st token

" `nft_line_comment` main top-level syntax, do not add 'contained' here.
" works for #inline comment as well
" contains=NONE to ensure that no other group are folded into this match"
hi link   nft_line_comment nftHL_Comment
syn match nft_line_comment "\v#.{0,127}$" skipwhite
\ contains=NONE

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

