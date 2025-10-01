" File: common_block_early.vim
" Directory: custom/nftables
" Title: common_block semantic action, early

let s:common_block_early_list_filepaths_semantic_early = []
let s:common_block_early_list_filepaths_semantic_later = []

if exists('b:did_nftables_common_block_early')
  call nftables#syntax#log('INFO', 'Skipped common_block_early.vim (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"


" non-terminal semantic action processing
for s:this_semantic_file in s:common_block_early_list_filepaths_semantic_early
  call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
  call nftables#syntax#load(s:this_semantic_file)
  call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
endfor
call nftables#syntax#debug('Loading common_block_early syntax ...' )


" INSERT 'syntax match' here
" INSERT 'syntax region' here
" INSERT 'syntax cluster' here
"

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

for s:this_semantic_file in s:common_block_early_list_filepaths_semantic_later
  call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
  call nftables#syntax#load(s:this_semantic_file)
  call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
endfor
call nftables#syntax#log('INFO', 'Loaded common_block_early for buffer: ' . bufname('%'))


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_terminal = v:true
