

" ************************* BEGIN 'udp length' ************************
hi link   nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  udp length in { 1,127,255 }
hi link   nft_payload_expr_close_scope_udp_inline_set_length nftHL_Integer
syn match nft_payload_expr_close_scope_udp_inline_set_length '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n\-\},]' skipwhite contained

"  udp length in {  }
hi link    nft_payload_expr_udp_hdr_field_length_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_hdr_field_length_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_udp_inline_set_length
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex
\  '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_length_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_udp_length_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex,
\    nft_Error

"   udp length NUM
hi link   nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range
\ '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_length_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_udp_length_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_length_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_length_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_length_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_length_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_length_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_length_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr udp_hdr_field_length' implied match
hi link   nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_length nftHL_Substatement
syn match nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_udp_length_relational_op_equality_2char,
\    nft_payload_expr_close_scope_udp_length_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_udp_length_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_udp_length_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_length_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_length_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'udp length' **************************

" ************************* BEGIN 'udp sport' ************************
hi link   nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" === nftables service names - safe, single-quoted, no parentheses ===
hi link   nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpoverudp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|udpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt

"  udp sport in { 1,127,255 }
hi link   nft_payload_expr_close_scope_udp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_close_scope_udp_inline_set_sport '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n\-\},]' skipwhite contained

"  udp sport in {  }
hi link    nft_payload_expr_udp_hdr_field_sport_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_hdr_field_sport_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_udp_sport_inline_set_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_udp_inline_set_sport
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex
\  '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpoverudp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|udpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_udp_sport_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_Error

"   udp sport NUM
hi link   nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range
\ '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_udp_sport_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_sport_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_sport_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_sport_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_sport_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_sport_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr udp_hdr_field_sport' implied match
hi link   nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport nftHL_Substatement
syn match nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_udp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_udp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_udp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'udp sport' **************************

" ************************* BEGIN 'udp dport' ************************
"  udp dport
hi link   nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport nftHL_Substatement
syn match nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_udp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_udp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_udp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_udp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" ************************* END 'udp dport' **************************

"  udp dport in { 1,127,255 }
hi link   nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  udp dport in { 1,2,4 }
hi link   nft_payload_expr_close_scope_udp_dport_inline_set_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_udp_dport_inline_set_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n\-\},]' skipwhite contained

"  udp dport in {  }
hi link    nft_payload_expr_udp_hdr_field_dport_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_hdr_field_dport_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_udp_dport_inline_set_integer_expr_num_uint16_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_dport_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_udp_dport_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex,
\    nft_Error

"   udp dport NUM
hi link   nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]\ze[ \t\n\-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_dport_dash_symbol,
\    @nft_c_stmt,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_udp_dport_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_dport_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_dport_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_dport_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_dport_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_dport_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_dport_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr udp_hdr_field_dport' implied match
hi link   nft_payload_expr_udp_hdr_expr_udp_hdr_option_type_keyword_dport nftHL_Substatement
syn match nft_payload_expr_udp_hdr_expr_udp_hdr_option_type_keyword_dport '\vdport|2\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_udp_dport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_udp_dport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_dport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_udp_dport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_dport_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* BEGIN 'udp dport' ************************


" ************************* BEGIN 'udp checksum' ************************
hi link   nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  udp checksum in { 1,127,255 }
hi link   nft_payload_expr_close_scope_udp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_close_scope_udp_inline_set_checksum '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n\-\},]' skipwhite contained

"  udp checksum in {  }
hi link    nft_payload_expr_udp_hdr_field_checksum_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_udp_hdr_field_checksum_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_udp_inline_set_checksum
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex
\  '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_udp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_udp_checksum_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex,
\    nft_Error

"   udp checksum NUM
hi link   nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range
\ '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_checksum_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_udp_checksum_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_udp_checksum_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_checksum_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr udp_hdr_field_checksum' implied match
hi link   nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_checksum nftHL_Substatement
syn match nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_udp_checksum_relational_op_equality_2char,
\    nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_udp_checksum_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_udp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_udp_hdr_field_checksum_set_expr_inline_set,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_udp_checksum_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'udp checksum' **************************

" udp_hdr_expr is valid in chain_block and stmt_list
" udp_hdr_expr 'udp'
" 'udp'->udp_hdr_expr->inner_inet_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" 'udp'->udp_hdr_expr->gre_hdr_expr->payload_expr->(payload_stmt|primary_expr|primary_stmt_expr)
hi link   nft_payload_expr_udp_hdr_expr_keyword_udp nftHL_Statement
syn match nft_payload_expr_udp_hdr_expr_keyword_udp '\v[ \n]\zsudp\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_checksum,
\    nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_length,
\    nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_dport,
\    nft_payload_expr_udp_hdr_expr_udp_hdr_field_keyword_sport,
\    nft_UnexpectedSemicolon,
\    nft_Error
