
if exists('g:nft_did_add_table_cmd')
  finish
endif

if exists('b:current_syntax') && b:current_syntax ==# 'nftables'
  finish
endif
let s:script_dir = expand('<sfile>:p:h')
call nftables#syntax#debug('add_table_cmd.vim: Loading add_table_cmd.vim ...' )


" base_cmd add_cmd 'table' table_spec family_spec identifier
hi link   nft_table_spec_identifier nftHL_Identifier
syn match nft_table_spec_identifier '\v[a-zA-Z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_add_cmd_keyword_table_table_block_delimiters,
\    nft_comment_inline,
\    nft_EOS,
\    nft_line_nonidentifier_error,
\    nft_line_separator

" base_cmd add_cmd 'table' table_spec family_spec family_spec_explicit
hi link   nft_table_spec_family_spec_valid nftHL_Family
syn match nft_table_spec_family_spec_valid '\v(bridge|netdev|inet|ip6|arp|ip)' skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_table_spec_identifier,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedHash,
\    nft_UnexpectedEOS,
\    nft_Error

" DECLARATIVE: nft> table <table_id> ;
" 'table'->add_cmd->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_table_declarative nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_table_declarative '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_table_spec_family_spec_valid,
\    nft_table_spec_variable_expr,
\    nft_table_spec_identifier,
\    nft_line_nonvariable_error,
\    nft_UnexpectedNonIdentifier,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedVariableName,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" base_cmd add_cmd 'add' 'table' table_spec family_spec identifier
hi link   nft_add_table_spec_identifier nftHL_Identifier
syn match nft_add_table_spec_identifier '\v[a-zA-Z][A-Za-z0-9_\-]{0,63}' skipwhite contained
\ nextgroup=
\    nft_comment_inline,
\    nft_line_separator,
\    nft_EOS,
\    nft_line_nonidentifier_error,

" base_cmd add_cmd 'add' 'table' table_spec family_spec family_spec_explicit
hi link   nft_add_table_spec_family_spec_valid nftHL_Family
syn match nft_add_table_spec_family_spec_valid '\v(bridge|netdev|inet|arp|ip6|ip)' skipwhite skipnl skipempty contained
\ nextgroup=
\    nft_add_table_spec_identifier,
\    nft_UnexpectedSemicolon,
\    nft_UnexpectedEOS,
\    nft_Error

" IMPERATIVE: nft> add table <table_id>
" 'table'->add_cmd->'add'->base_cmd->line
hi link   nft_base_cmd_add_cmd_keyword_table_imperative nftHL_Command
syn match nft_base_cmd_add_cmd_keyword_table_imperative '\vtable\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_add_table_spec_family_spec_valid,
\    nft_add_table_spec_identifier,
\    nft_comment_inline,
\    nft_line_nonidentifier_error

let g:nft_did_add_table_cmd = v:true