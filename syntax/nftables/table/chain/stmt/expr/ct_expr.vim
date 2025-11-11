


" '(saddr|daddr)->ct_key_proto_field->ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_ct_expr_ct_key_proto_field_keyword_addrs nftHL_Action
syn match nft_ct_expr_ct_key_proto_field_keyword_addrs '\v(saddr|daddr)' skipwhite contained

" ct_key_proto_field->ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_ct_expr_ct_key_proto_field_keyword_ip_ip6 nftHL_Command
syn match nft_ct_expr_ct_key_proto_field_keyword_ip_ip6 '\v(ip6|ip)' skipwhite contained
\ nextgroup=
\    nft_ct_expr_ct_key_proto_field_keyword_addrs

" ct_key_dir->ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_ct_expr_ct_key_dir nftHL_Action
syn match nft_ct_expr_ct_key_dir '\v(saddr|daddr|l3proto|proto\-(src|dst))' skipwhite contained

" ct_key_dir_optional->(ct_stmt|ct_key_dir|ct_key)
hi link   nft_ct_expr_ct_key_dir_optional nftHL_Action
syn match nft_ct_expr_ct_key_dir_optional '\v(bytes|packets|avgpkt|zone)' skipwhite contained
\ nextgroup=
\    nft_ct_key_dir_ct_expr_keyword_set

" ct_key_proto_field->ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_ct_expr_ct_dir nftHL_Action
syn match nft_ct_expr_ct_dir '\v(original|reply)' skipwhite contained
\ nextgroup=
\    nft_ct_expr_ct_key_dir_optional,
\    nft_ct_expr_ct_key_dir

" ct_key->ct_expr->(payload_expr|payload_stmt_expr)
hi link   nft_ct_expr_ct_key nftHL_Action
syn match nft_ct_expr_ct_key '\v(expiration|direction|proto\-src|proto\-dst|l3proto|l4proto|secmark|helper|status|daddr|event|label|proto|state|saddr|mark|id)' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_expiration nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_expiration '\vexpiration\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_direction nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_direction '\vdirection\ze[ \t]' skipwhite contained

hi link nft_ct_expr_ct_key_keyword_proto_src nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_proto_src '\vproto\-src\ze[ \t]' skipwhite contained

hi link nft_ct_expr_ct_key_keyword_proto_dst nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_proto_dst '\vproto\-dst\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_dir_keyword_original nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_dir_keyword_original  '\voriginal\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_protocol nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_protocol '\vprotocol\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_l3proto nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_l3proto '\vl3proto\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_l4proto nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_l4proto '\vl4proto\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_key_dir_optional_keyword_packets nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_key_dir_optional_keyword_packets '\vpackets\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_secmark nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_secmark '\vsecmark\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt '\vavgpkt\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_status nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_status '\vstatus\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_helper nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_helper '\vhelper\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes '\vbytes\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_daddr nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_daddr '\vdaddr\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_event nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_event '\vevent\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_label nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_label '\vlabel\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_dir_keyword_reply nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_dir_keyword_reply '\vreply\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_saddr nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_saddr '\vsaddr\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_state nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_state '\vstate\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_mark nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_mark '\vmark\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_ct_key_dir_optional_keyword_zone nftHL_Substatement
syn match nft_ct_expr_ct_key_ct_key_dir_optional_keyword_zone '\vzone\ze[ \t]' skipwhite contained

hi link   nft_ct_expr_ct_key_keyword_id nftHL_Substatement
syn match nft_ct_expr_ct_key_keyword_id '\vid\ze[ \t]' skipwhite contained

" ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_primary_stmt_expr_ct_expr_keyword_ct nftHL_Command
syn match nft_primary_stmt_expr_ct_expr_keyword_ct 'ct' skipwhite contained
\ nextgroup=
\    nft_ct_expr_ct_key_keyword_expiration,
\    nft_ct_expr_ct_key_keyword_direction,
\    nft_ct_expr_ct_key_keyword_proto_src,
\    nft_ct_expr_ct_key_keyword_proto_dst,
\    nft_ct_expr_ct_key_ct_dir_keyword_original,
\    nft_ct_expr_ct_key_keyword_protocol,
\    nft_ct_expr_ct_key_keyword_l3proto,
\    nft_ct_expr_ct_key_keyword_l4proto,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_packets,
\    nft_ct_expr_ct_key_keyword_secmark,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt,
\    nft_ct_expr_ct_key_keyword_status,
\    nft_ct_expr_ct_key_keyword_helper,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes,
\    nft_ct_expr_ct_key_keyword_daddr,
\    nft_ct_expr_ct_key_keyword_event,
\    nft_ct_expr_ct_key_keyword_label,
\    nft_ct_expr_ct_key_ct_dir_keyword_reply,
\    nft_ct_expr_ct_key_keyword_saddr,
\    nft_ct_expr_ct_key_keyword_state,
\    nft_ct_expr_ct_key_keyword_mark,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_zone,
\    nft_ct_expr_ct_key_keyword_id,
\    nft_ct_expr_ct_key_proto_field_keyword_ip_ip6


" ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_primary_expr_ct_expr_keyword_ct nftHL_Command
syn match nft_primary_expr_ct_expr_keyword_ct 'ct' skipwhite contained
\ nextgroup=
\    nft_ct_expr_ct_key_keyword_expiration,
\    nft_ct_expr_ct_key_keyword_direction,
\    nft_ct_expr_ct_key_keyword_proto_src,
\    nft_ct_expr_ct_key_keyword_proto_dst,
\    nft_ct_expr_ct_key_ct_dir_keyword_original,
\    nft_ct_expr_ct_key_keyword_protocol,
\    nft_ct_expr_ct_key_keyword_l3proto,
\    nft_ct_expr_ct_key_keyword_l4proto,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_packets,
\    nft_ct_expr_ct_key_keyword_secmark,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_avgpkt,
\    nft_ct_expr_ct_key_keyword_status,
\    nft_ct_expr_ct_key_keyword_helper,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_bytes,
\    nft_ct_expr_ct_key_keyword_daddr,
\    nft_ct_expr_ct_key_keyword_event,
\    nft_ct_expr_ct_key_keyword_label,
\    nft_ct_expr_ct_key_ct_dir_keyword_reply,
\    nft_ct_expr_ct_key_keyword_saddr,
\    nft_ct_expr_ct_key_keyword_state,
\    nft_ct_expr_ct_key_keyword_mark,
\    nft_ct_expr_ct_key_ct_key_dir_optional_keyword_zone,
\    nft_ct_expr_ct_key_keyword_id,
\    nft_ct_expr_ct_key_proto_field_keyword_ip_ip6


" ct_expr->(primary_expr|primary_stmt_expr)
hi link   nft_primary_expr_ct_expr_keyword_ct nftHL_Command
syn match nft_primary_expr_ct_expr_keyword_ct 'ct' skipwhite contained
\ nextgroup=
\    nft_ct_expr_ct_key,
\    nft_ct_expr_ct_key_dir_optional,
\    nft_ct_expr_ct_dir,
\    nft_ct_expr_ct_key_proto_field_keyword_ip_ip6
