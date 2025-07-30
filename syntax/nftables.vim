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
syn match nft_MapEntry '\v[0-9]{1,11}\s{1,32}:\s{1,32}\".{1,64}\"' contained

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
syn match nft_add_cmd_keyword_counter_counter_config_bytes_num "\v[0-9]{1,11}\ze(([ \t;])|($))" skipwhite contained
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
syn match nft_add_cmd_keyword_counter_counter_config_packet_num "\v[0-9]{1,11}\ze(([ \t])|($))" skipwhite contained
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
hi link    nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double nftHL_String
syn region nft_add_cmd_keyword_counter_counter_block_comment_string_quoted_double start='"' end='"' skip="\\\"" oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'set' set_spec '{' set_block 'comment'
hi link   nft_add_cmd_keyword_counter_counter_block_comment_spec nftHL_Command
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
syn match nft_flowtable_block_hook_keyword_priority_extended_int "\v\-?[0-9]{1,11}" skipwhite contained
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
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_high '\v[0-9]{1,11}' skipwhite contained

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_dash nftHL_Expression
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_dash /-/ contained
\ nextgroup=
\     nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_number_range_high

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_number nftHL_Number
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_number '\v[0-9]{1,11}' skipwhite contained
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
syn match nft_define_undefine_keywords_block_MapEntry_element_value '\v[0-9]{1,11}\ze\s{0,10}:' skipwhite contained
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
syn match nft_common_block_define_undefine_keywords_initializer_expr_rhs_expr_set_expr_block_element_set_key_integer_expr '\v[0-9]{1,11}' skipwhite contained
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
syn match nft_destroy_cmd_keyword_chain_chainid_spec_num "\v[0-9]{1,11}" skipwhite contained
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
syn match nft_delete_cmd_keyword_table_table_or_id_spec_tableid_spec_keyword_handle_num "\v[0-9]{1,11}" skipwhite contained

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
syn match nft_delete_cmd_keyword_chain_chainid_spec_num "\v[0-9]{1,11}" skipwhite contained
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
syn match nft_delete_cmd_keyword_rule_ruleid_spec_handle_spec_num "\v[0-9]{1,11}" skipwhite contained
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
syn match nft_delete_cmd_keyword_set_setid_spec_num "\v[0-9]{1,11}" skipwhite contained
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
syn match nft_delete_cmd_keyword_flowtable_flowtableid_spec_num "\v[0-9]{1,11}" skipwhite contained
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
syn match nft_delete_cmd_keyword_counter_objid_spec_num "\v[0-9]{1,11}" skipwhite contained
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
hi link    nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_String
syn region nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec start='"' end='"' skip="\\\"" oneline skipwhite contained
\ nextgroup=
\    nft_String,
\    nft_Error

" base_cmd add_cmd 'element' set_block_expr '{' A : B comment_spec '}'
hi link   nft_add_cmd_keyword_element_set_block_expr_set_expr_set_elem_expr_set_elem_expr_option_comment_spec nftHL_Command
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
syn match nft_base_cmd_add_cmd_keyword_rule "rule" skipwhite contained
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
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr /\v(\=|\s)\zs\d{1,11}\ze($|\-|(\s+[^\-])|;|,)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr_list_comma,
\    nft_common_block_stmt_separator

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second /\v\d{1,11}\ze( |$)/ skipwhite contained
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
syn match nft_PortRangeDashInvalid /\v\d{1,11}\s+-/ contained

hi link   nft_PortRangeBadDashSpaceBefore nftHL_Error
syn match nft_PortRangeBadDashSpaceBefore /\v\d{1,11}\s+-/ contained

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range /\v(\=|\s)\zs\d{1,11}\ze\-/ contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_dash_symbol,
\    nft_PortRangeDashInvalid,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash_num nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash_num "\v[0-9]{1,11}" skipwhite contained
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
\    nft_base_cmd_add_cmd_secmark_keyword,
\    nft_base_cmd_add_cmd_chain_keyword,
\    nft_base_cmd_add_cmd_quota_keyword,
\    nft_base_cmd_add_cmd_limit_keyword,
\    nft_base_cmd_add_cmd_table_keyword,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_add_cmd_map_keyword,
\    nft_base_cmd_add_cmd_set_keyword,
\    nft_base_cmd_add_cmd_ct_keyword,
\    nft_base_cmd_add_cmd_rule_position_table_spec_wildcard,
" insert nft_base_cmd_add_cmd_rule_position_table_spec_wildcard in nft_base_cmd_keyword_add is CPU-intensive"

syn cluster nft_c_base_cmd_add_cmd_unused_placeholder
\ contains=
\    nft_base_cmd_add_cmd_keyword_flowtable,
\    nft_base_cmd_add_cmd_synproxy_keyword,
\    nft_base_cmd_add_cmd_counter_keyword,
\    nft_base_cmd_add_cmd_keyword_element,
\    nft_base_cmd_add_cmd_secmark_keyword,
\    nft_base_cmd_add_cmd_chain_keyword,
\    nft_base_cmd_add_cmd_quota_keyword,
\    nft_base_cmd_add_cmd_limit_keyword,
\    nft_base_cmd_add_cmd_table_keyword,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_map_keyword,
\    nft_base_cmd_add_cmd_set_keyword,
\    nft_base_cmd_add_cmd_ct_keyword

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
\    nft_base_cmd_add_cmd_secmark_keyword,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_base_cmd_create_keyword,
\    nft_common_block_keyword_define,
\    nft_base_cmd_keyword_delete,
\    nft_base_cmd_export_keyword,
\    nft_base_cmd_import_keyword,
\    nft_base_cmd_insert_keyword,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_rename_keyword,
\    nft_base_cmd_add_cmd_chain_keyword,
\    nft_common_block_error_keyword,
\    nft_base_cmd_flush_keyword,
\    nft_base_cmd_add_cmd_limit_keyword,
\    nft_base_cmd_add_cmd_quota_keyword,
\    nft_base_cmd_reset_keyword,
\    nft_base_cmd_add_cmd_table_keyword,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
\    nft_base_cmd_list_keyword,
\    nft_base_cmd_add_cmd_keyword_rule,
\    nft_base_cmd_keyword_add,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
\    nft_base_cmd_get_keyword,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
\    nft_base_cmd_add_cmd_map_keyword,
\    nft_base_cmd_add_cmd_set_keyword,
\    nft_base_cmd_add_cmd_ct_keyword,
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

