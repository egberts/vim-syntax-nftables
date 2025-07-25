" base_cmd Vim syntax file for nftables configuration file
" Language:     nftables configuration file
" Maintainer:   egberts <egberts@github.com>
" Revision:     2.0
" Initial Date: 2025-04-18
" Last Change:  2025-04-18
" Filenames:    nftables.conf, *.nft
" Location:     https://github.com/egberts/vim-nftables
" License:      MIT license
" Remarks:
" Bug Report:   https://github.com/egberts/vim-nftables/issues
"
"  WARNING:  Do not add online comments using a quote symbol, it ALTERS patterns
"
"

" First-level keywords/identifiers
" include, undefine, ';', add,

" replace, create, insert, delete, get,
" list, reset, flush, rename, import,
" export, monitor, describe, destroy,
" <IDENTIFIER>
source ../scripts/nftables/base_cmd_undefine_cmd.vim
source ../scripts/nftables/base_cmd_describe_cmd.vim
source ../scripts/nftables/base_cmd_replace_cmd.vim
source ../scripts/nftables/base_cmd_monitor_cmd.vim
source ../scripts/nftables/base_cmd_destroy_cmd.vim
source ../scripts/nftables/base_cmd_create_cmd.vim
source ../scripts/nftables/base_cmd_delete_cmd.vim
source ../scripts/nftables/base_cmd_insert_cmd.vim
source ../scripts/nftables/base_cmd_rename_cmd.vim
source ../scripts/nftables/base_cmd_import_cmd.vim
source ../scripts/nftables/base_cmd_export_cmd.vim
source ../scripts/nftables/base_cmd_flush_cmd.vim
source ../scripts/nftables/base_cmd_reset_cmd.vim
source ../scripts/nftables/base_cmd_list_cmd.vim
source ../scripts/nftables/base_cmd_get_cmd.vim
source ../scripts/nftables/base_cmd_add_cmd.vim
source ../scripts/nftables/base_cmd_ct_cmd.vim

hi link nft_base_cmd_table_spec_chain_spec_family_spec_family_spec_explicit_keyword_ip nftNL_Family
syn match nft_base_cmd_table_spec_chain_spec_family_spec_family_spec_explicit_keyword_ip "ip" skipwhite contained


" base_cmd->line
syn cluster nft_c_base_cmd
\ contains=
\    nft_base_cmd_keyword_flowtable,
\    nft_base_cmd_keyword_describe,
\    nft_base_cmd_keyword_synproxy,
\    nft_base_cmd_keyword_counter,
\    nft_base_cmd_keyword_destroy,
\    nft_get_et_al_cmd_keyword_element,
\    nft_base_cmd_keyword_monitor,
\    nft_base_cmd_keyword_replace,
\    nft_base_cmd_keyword_secmark,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_bridge,
\    nft_base_cmd_keyword_create,
\    nft_base_cmd_keyword_delete,
\    nft_base_cmd_keyword_export,
\    nft_base_cmd_keyword_import,
\    nft_base_cmd_keyword_insert,
\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_netdev,
\    nft_base_cmd_keyword_rename,
\    nft_base_cmd_keyword_chain,
\    nft_base_cmd_keyword_flush,
\    nft_base_cmd_keyword_limit,
\    nft_base_cmd_keyword_quota,
\    nft_base_cmd_keyword_reset,
\    nft_base_cmd_keyword_table,
\    nft_line_stmt_separator
"\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_inet,
"\    nft_base_cmd_keyword_list,
"\    nft_base_cmd_keyword_rule,
"\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_arp,
"\    nft_base_cmd_keyword_get,
"\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip6,
"\    nft_base_cmd_keyword_map,
"\    nft_base_cmd_keyword_set,
"\    nft_base_cmd_keyword_add,
"\    nft_base_cmd_add_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
"\    nft_base_cmd_keyword_ct,
"\    nft_base_cmd_rule_position_chain_spec_table_spec_family_spec_family_spec_explicit_keyword_ip,
"\    nft_base_cmd_rule_position_chain_spec_table_spec_identifier,
"
