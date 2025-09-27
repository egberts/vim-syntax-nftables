" Vim syntax file for common_block in nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     1.1
" Initial Date: 2020-04-24
" Last Change:  2025-01-19
" Filenames:    nftables.conf, *.nft
" Location:     https://github.com/egberts/vim-syntax-nftables/syntax/nftables
" License:      MIT license
" Bug Report:   https://github.com/egberts/vim-syntax-nftables/issues
" Syntime:      ~x.xxs (tested 2025-0x-xx)
"
" Description:
"
" Warnings:
"   - Do not use 'containedin=', computationally expensive.
"   - Do not add inline comments using a double-quote, it alters patterns.
"   - Do not use 'keepend' except in the most innermost region blocks.
"   - 'to', 'set', 'name' keywords ALL GOES thru `stmt_expr`
"   - map_stmt_expr is semantic, not the TOKEN/keyword 'map'
"
" Vim Developer Notes:
"   - always add '\v' to any OR-combo list in `syntax match`
"   - place 'contained' keywords at EOL
"   - strongly discourage use '?' in `match` statements, make multiple match statements
"   - 'contains=' ordering MATTERS in `cluster` statements
"   - inner-'region' benefits from 'keepend', not outer-regions.
"   - ordering: between 'contains=' and 'nextgroup=', first one wins
"   - ordering: within 'contains=' and 'nextgroup=', last one wins
"   - no trailing commas allowed in 'contains=' / 'nextgroup=' lists
"   - consider relocating inner_inet_expr to after th_hdr_expr
"   - pair the 'highlight link'/'syntax match' together, in that order for minimal CPU burn and maximum maintainability
"
if exists('g:nft_did_common_block')
  finish
endif

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif
let s:script_dir = expand('<sfile>:p:h')
if exists('nft_debug') && nft_debug == 1
  call nftables#syntax#log('INFO', 'common_block.vim: Loading common_block.vim ...' )
endif

try

" Region that spans from after 'last' to terminator ';' or newline
hi link    nft_common_block_undefine_extra_text nftHL_Error
syn region nft_common_block_undefine_extra_text start=/\%#\s*/ end=/\ze[;\n]/ contained transparent
\ contains=
\    nft_expected_semicolon_or_new_line,
\    nft_common_block_undefine_error

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
\    nft_common_block_stmt_separator

" *************** BEGIN common_block *******************
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
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier /\v[a-zA-Z][a-zA-Z0-9_\-]{1,64}/ skipwhite contained
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
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr /\v\d{1,10}\ze($|;|\}|\-|(\s+[^\-])|;|)/ skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr_list_comma,
\    nft_common_block_stmt_separator,
\    nft_EOS,
\    nft_MissingSemicolon,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range_second /\v\d{1,5}\ze( |$)/ skipwhite contained
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
syn match nft_PortRangeDashInvalid /\v\d{1,5}\s+-/ contained

hi link   nft_PortRangeBadDashSpaceBefore nftHL_Error
syn match nft_PortRangeBadDashSpaceBefore /\v\d{1,5}\s+-/ contained

hi link   nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range /\v(\=|\s)\zs\d{1,5}\ze\-/ contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_dash_symbol,
\    nft_PortRangeDashInvalid,
\    nft_Error

hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash_num nftHL_Constant
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash_num '\v[0-9]{1,10}' skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_EOS

" '-'->initializer_expr->common_block
hi link   nft_common_block_define_redefine_keywords_initializer_expr_dash nftHL_Operator
syn match nft_common_block_define_redefine_keywords_initializer_expr_dash /-/ contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_dash_num,
\    nft_Error_Always


" list_rhs_expr must be the last 'contains=' entry
"     as its basic_rhs_expr->exclusive_or_rhs_expr->and_rhs_expr->shift_rhs_expr->primary_rhs_expr->symbol_expr
"     uses <string> which is a (wildcard)

hi link   nft_common_block_filespec_sans_single_quote nftHL_String
syn match nft_common_block_filespec_sans_single_quote "\v[\"_\-\.\;\?a-zA-Z0-9\,\:\+\=\*\&\^\%\$\!`\~\#\@\|\/\\\(\)\{\}\[\]\<\>(\\\')]+" keepend contained

hi link    nft_common_block_filespec_quoted_single nftHL_String
syn region nft_common_block_filespec_quoted_single start='\'' skip='\\\'' end='\'' skipwhite keepend oneline contained
\ contains=
\    nft_common_block_filespec_sans_single_quote
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_common_block_filespec_sans_double_quote nftHL_String
syn match nft_common_block_filespec_sans_double_quote '\v[\'_\-\.\;\?a-zA-Z0-9\,\:\+\=\*\&\^\%\$\!`\~\#\@\|\/\(\)\{\}\[\]\<\>(\\\")]+' keepend contained

hi link    nft_common_block_filespec_quoted_double nftHL_String
syn region nft_common_block_filespec_quoted_double start='\"' skip='\\\"' end='\"' skipwhite oneline keepend contained
\ contains=
\    nft_common_block_filespec_sans_double_quote
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_Error

syn cluster nft_c_common_block_keyword_include_quoted_string
\ contains=
\    nft_common_block_filespec_quoted_single,
\    nft_common_block_filespec_quoted_double,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

hi link   nft_common_block_keyword_include nftHL_Include
syn match nft_common_block_keyword_include '\vinclude\s' skipwhite oneline contained
\ nextgroup=
\    @nft_c_common_block_keyword_include_quoted_string,
\    nft_expected_quote

" common_block 'define'/'
" common_block 'define'/'redefine identifier '='
hi link   nft_common_block_define_redefine_equal nftHL_Operator
syn match nft_common_block_define_redefine_equal '\v\zs\s{0,15}\=' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_set_expr_block,
\    nft_common_block_define_redefine_keywords_initializer_expr_dash,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_quoted_string,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_IP,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_port_range,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_integer_expr,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_variable,
\    nft_common_block_define_redefine_keywords_initializer_expr_rhs_expr_primary_rhs_expr_unquoted_identifier,
\    nft_UnexpectedSemicolon,
\    nft_Error

" common_block 'define'/'redefine identifier <STRING>
hi link   nft_common_block_define_redefine_keywords_identifier nftHL_Identifier
syn match nft_common_block_define_redefine_keywords_identifier '\v\zs[a-zA-Z][a-zA-Z0-9_\-]{0,63}' contained
\ nextgroup=
\    nft_common_block_define_redefine_equal,
\    nft_expected_equal_sign

" 'define' (via "
" common_block 'redefine' (via common_block)
hi link   nft_common_block_keyword_redefine nftHL_Command
syn match nft_common_block_keyword_redefine contained '\vredefine\s' skipwhite contained
\ nextgroup=
\    nft_common_block_define_redefine_keywords_identifier,
\    nft_expected_identifier

" common_block 'define' (via common_block)
hi link   nft_common_block_keyword_define nftHL_Command
syn match nft_common_block_keyword_define contained '\vdefine\s' skipwhite contained
\ containedin=nft_c_common_block
\ nextgroup=
\    nft_common_block_define_redefine_keywords_identifier,
\    nft_expected_identifier

" common_block 'undefine' identifier (via common_block 'undefine')
hi link   nft_common_block_undefine_identifier_string nftHL_Identifier
syn match nft_common_block_undefine_identifier_string '\v[a-zA-Z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_stmt_separator,
\    nft_UnexpectedCurlyBrace,
\    nft_EOS,
\    nft_Error

" After 'last', expect either ';' or newline, or else show error
syn match nft_common_block_undefine_extra_error_or_semicolon '\v\S+' contained
\ contains=
\    nft_common_block_stmt_separator,
\    nft_common_block_undefine_error

hi link   nft_common_block_undefine_identifier_keyword_last nftHL_Keyword
syn match nft_common_block_undefine_identifier_keyword_last '\vlast' skipwhite contained
\ nextgroup=
\    nft_common_block_stmt_separator,
\    nft_common_block_undefine_error

" commmon_block 'undefine' (via common_block)
hi link   nft_common_block_keyword_undefine nftHL_Command
syn match nft_common_block_keyword_undefine '\vundefine\ze\s' skipnl skipwhite contained
\ containedin=nft_c_common_block
\ nextgroup=
\    nft_common_block_undefine_identifier_keyword_last,
\    nft_common_block_undefine_identifier_string,
\    nft_Error

" commmon_block 'error' (via common_block)
hi link   nft_common_block_keyword_error nftHL_Command
syn match nft_common_block_keyword_error '\<error\>' skipwhite contained

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


" common_block cluster is used only within any '{' block '}'
syn cluster nft_c_common_block
\ contains=
\    nft_common_block_keyword_redefine,
\    nft_common_block_keyword_undefine,
\    nft_common_block_keyword_include,
\    nft_common_block_keyword_define,
\    nft_common_block_keyword_error,
\    nft_common_block_stmt_separator


  call nftables#syntax#debug('common_block.vim: Loaded syntax/nftables/common_block.vim' )
  let g:nft_did_common_block = v:true
catch
  echomsg 'syntax/nftables/common_block.vim: ERROR: ' . v:exception . ' at ' . v:throwpoint
endtry
