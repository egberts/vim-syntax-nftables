

" ***************** BEGIN 'add' 'rule' ***************

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge "bridge" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev "netdev" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet "inet" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp "arp" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6 "ip6" skipwhite contained

hi link   nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip nftHL_Family
syn match nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip "ip" skipwhite contained

syn cluster nft_c_add_cmd_rule_rule_alloc_again
\ contains=@nft_c_add_cmd_rule_rule_alloc_alloc

" base_cmd [ 'add' ] 'rule' rule_alloc comment_spec
hi link   nft_add_cmd_rule_comment_spec_string nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_string "\v[A-Za-z0-9 ]{1,64}" skipwhite contained
" TODO A BUG? What is a 'space' doing in comment?"

hi link   nft_add_cmd_rule_comment_spec_comment nftHL_Comment
syn match nft_add_cmd_rule_comment_spec_comment "comment" skipwhite contained
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
\    nft_add_cmd_keyword_rule_rule_position_table_spec_end,


" 'rule'->add_cmd->base_cmd->line
hi link   nft_base_cmd_keyword_rule nftHL_Command
syn match nft_base_cmd_keyword_rule "\vrule\ze" skipwhite contained
\ nextgroup=
\    nft_add_cmd_rule_position_family_spec_explicit,
\    nft_add_cmd_keyword_rule_rule_position_table_spec_end



syn cluster nft_c_rule_alloc
\ contains=
\    @nft_c_stmt

syn cluster nft_c_rule
\ contains=
\    @nft_c_rule_alloc