" File: tcp_hdr_expr.vim
" Directory: custom/nftables/table/chain/stmt/expr/
"
" Field     Datatype   Value Range,Notes
" sport     uint16     0-65535       Source port (e.g., tcp sport 80).
" dport     uint16     0-65535       Destination port (e.g., tcp dport 443).
" sequence  uint32     0-4294967295  Sequence number.
" ackseq    uint32     0-4294967295  Acknowledgment sequence number.
" doff      uint4      5-15          Data offset (header length in 32-bit words; minimum 5 for 20-byte header).
"                          0.5–1.875 * 32 bits
" reserved  uint4      0-15          Reserved bits (must be 0).
" flags     uint8      0-255         bitmask flags
"                                    CWR=128, ECE=64, URG=32, ACK=16, PSH=8, RST=4, SYN=2, FIN=1
" window    uint16     0-65535       Window size (bytes).
" checksum  uint16     0-65535       Checksum (calculated by kernel).
" urgptr    uint16     0-65535       Urgent pointer.
" kind      uint8      0-255
" length    uint8      0-255
"
" nftables 'tcp' gotchas:
"  - No chaining of tcp_hdr_field; you cannot omit 'tcp'
"    when chaining multiple TCP header fields or options
"    in nftables v1.1.4
"  - Convention: a separate line for each tcp field/option
"
" Option     Value    Field    Value    Notes
" kind                         Range
"
" echo       8        LENGTH   0–255    Option length.
" eol        0                          End of options (no fields).
" fastopen  34        LENGTH   0–255    Option length.
" md5sig    19        LENGTH   0–255    Option length (fixed 18).
" mptcp     30        SUBTYPE  0–255    MPTCP subtype (e.g., 0=MP_CAPABLE, 1=MP_JOIN).
" mss        2        SIZE     0–65535  Maximum segment size (e.g., tcp option mss size 1460).
" nop        1                          No operation (no fields).
" sack_perm  4        LENGTH   0–255    Option length (fixed 2).
" timestamp  8        TSVAL    0–4294967295  Timestamp value.
"                     TSECR,   0–4294967295  Timestamp echo reply.
" window     3        COUNT    0–255    Scale count (0–14).
" sack       5        LEFT     0–4294967295  Left edge of SACK.
" sack1      5        RIGHT    0–4294967295  Right edge of SACK.
" sack2      5                               Additional SACK edges (similar to LEFT/RIGHT).
" sack3      5                               Additional SACK edges (similar to LEFT/RIGHT).
" Custom     0–255    LENGTH   0–255    Generic option length.

let s:tcp_hdr_expr_list_filepaths_semantic_early = [
\        'table/chain/stmt/expr/tcp_hdr_option_type.vim'
\    ]
let s:tcp_hdr_expr_list_filepaths_semantic_later = []

if exists('b:did_nftables_tcp_hdr_expr')
  call nftables#syntax#log('INFO', 'Skipped tcp_hdr_expr (already loaded for buffer: ' . bufname('%') . ')')
  finish
endif

" save the filespec of this script into a stack for logging purpose
let s:filepath_this_script = resolve(expand('<sfile>:p'))
call nftables#syntax#push(s:filepath_this_script)
" now we can use nftables#syntax#log()

call nftables#syntax#log('OK', 'Begin.')

" BEGIN OF 'syntax' statements
"
try
  " non-terminal semantic action processing
  for s:this_semantic_file in s:tcp_hdr_expr_list_filepaths_semantic_early
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#debug('Loading tcp_hdr_expr syntax ...' )


  " INSERT 'syntax match' here
  " INSERT 'syntax region' here
  " INSERT 'syntax cluster' here
  "
" ************************* BEGIN 'tcp' ******************************

" ************************* BEGIN 'tcp doff' *************************
hi link   nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp doff in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_doff_inline_set_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_inline_set_integer_expr_num_uint4_hex '\v0x[5-9a-fA-F]|20|0x1[0-4]|[5-9]|1[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp doff in {  }
hi link    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set start=+{+ end=+}+ keepend skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_doff_inline_set_integer_expr_num_uint4_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex '\v\v0x[5-9a-fA-F]|20|0x1[0-4]|[5-9]|1[0-9]\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_doff_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_doff_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_Error

"   tcp doff
hi link   nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range '\v0x[5-9a-fA-F]|20|0x1[0-4]|[5-9]|1[0-9]\ze[ \t\-\n;]' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_dash_symbol,
\    nft_Error

" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_doff' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff '\vdoff\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_doff_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_doff_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_doff_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_doff_integer_expr_num_uint4_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" *************** END 'tcp doff' *************************************

" ************************* BEGIN 'tcp sport' ************************
hi link   nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

" === nftables service names - safe, single-quoted, no parentheses ===
hi link   nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpovertcp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines '\v(ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t,]' contained
\ nextgroup=
\    @nft_c_stmt

"  tcp sport in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_sport nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_sport '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp sport in {  }
hi link    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_sport_inline_set_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_inline_set_sport
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines nftHL_Define
" nftables service names - ORIGINAL ORDER (longest to shortest), <132 chars
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](clc-build-daemon|kerberos-master|zabbix-trapper|passwd-server|ms-wbt-server|gsigatekeeper|f5-globalsite|dhcpv6-server|dhcpv6-client|afs3-vlserver|afs3-prserver|afs3-kaserver|afs3-callback|zabbix-agent|moira-update|microsoft-ds|kerberos-adm|iscsi-target|gnutella-svc|gnutella-rtr|font-service|xmpp-server|xmpp-client|submissions|sge-qmaster)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](sa-msg-port|rpc2portmap|rmiregistry|radmin-port|radius-acct|ptp-general|netbios-ssn|netbios-dgm|mysql-proxy|ipsec-nat-t|datametrics|afs3-volser|afs3-update|afs3-rmtsys|zephyr-srv|zephyr-clt|syslog-tls|supfilesrv|supfiledbg|submission|rtcm-sc104|postgresql|netbios-ns|moira-ureg|ingreslock)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](cvspserver|codasrv-se|cmip-agent|cisco-sccp|bacula-dir|afpovertcp|zephyr-hm|snmp-trap|sge-execd|sane-port|ptp-event|lotusnote|kerberos4|groupwise|ftps-data|f5-iquery|dircproxy|codaauth2|clearcase|bacula-sd|bacula-fd|amidxtape|amandaidx|zope-ftp|zebrasrv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](venus-se|sgi-crsd|sgi-cmsd|poppassd|ms-sql-s|ms-sql-m|moira-db|krb-prop|kerberos|iso-tsap|http-alt|ftp-data|domain-s|cmip-man|cfengine|asf-rmcp|afs3-bos|acr-nema|telnets|skkserv|sip-tls|sgi-gcd|sgi-cad|printer|predict)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](pawserv|ospfapi|openvpn|omniorb|netstat|kpasswd|kamanda|hylafax|gsidcap|freeciv|discard|daytime|codasrv|chargen|xinetd|webmin|tproxy|telnet|tcpmux|tacacs|systat|sysrqd|svrloc|sunrpc|rmtcfg)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ripngd|remctl|radius|puppet|proofd|ospf6d|kshell|klogin|kermit|isakmp|ircs-u|gsiftp|gopher|gnunet|gds-db|gdomap|finger|domain|distcc|db-lsp|csync2|bootps|bootpc|amanda|zserv)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](zebra|z3950|xtelw|xmms2|xdmcp|x11-7|x11-6|x11-5|x11-4|x11-3|x11-2|x11-1|whois|venus|tfido|suucp|spamd|socks|sieve|shell|rsync|rplay|route|rootd|redis|pop3s)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ospfd|ntske|ntalk|nntps|mysql|munin|mailq|login|ldaps|isisd|iprop|imaps|imap2|icpv2|https|epmap|dicom|coaps|canna|binkp|babel|amqps|zope|xtel)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](wnn6|uucp|tinc|time|tftp|talk|snpp|snmp|smux|smtp|silc|saft|rtsp|ripd|qotd|qmtp|qmqp|pop3|nsca|nrpe|nntp|mdns|ldap|isns)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ircd|http|gris|gpsd|ftps|fido|exec|epmd|echo|dict|dcap|daap|coap|bgpd|auth|amqp|zip|x11|svn|ssh|sip|nut|ntp|nqs|nfs|nbp|nbd|mtn|mon|ldp|l2f)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt
syn match nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines '\v\ze[ \t](ipx|ipp|iax|hkp|git|ftp|fax|bgp|bbs|asp)\ze[ \t]' contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sport_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_sport_dash_symbol '\v[0-9]\zs\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_Error

"   tcp sport NUM
hi link   nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range '\v(6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|([0-9][0-9][0-9][0-9])|([0-9][0-9][0-9])|[0-9][0-9]|(0x[0-9a-fA-F]{1,4})|[0-9])\ze\-' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_sport' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport '\vsport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'tcp sport' **************************

" ************************* BEGIN 'tcp dport' ************************
"  tcp dport
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport '\vdport\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sport_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sport_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sport_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_sport_integer_expr_num_uint16_hex,
\    nft_Error
" ************************* END 'tcp dport' **************************

" ************************* BEGIN 'tcp flags' ************************
"                 Hex  Decimal
" Enum Name      Value  Value   Description
" TCP_FLAG_FIN    0x01    1     FIN flag (finish)
" TCP_FLAG_SYN    0x02    2     SYN flag (synchronize)
" TCP_FLAG_RST    0x04    4     RST flag (reset)
" TCP_FLAG_PSH    0x08    8     PSH flag (push)
" TCP_FLAG_ACK    0x10    16    ACK flag (acknowledge)
" TCP_FLAG_URG    0x20    32    URG flag (urgent)
" TCP_FLAG_ECE    0x40    64    ECN-Echo flag
" TCP_FLAG_CWR    0x80    128   Congestion Window Reduced flag
"
" These enums are used in tcp_hdr_field production for
" `tcp_hdr_expr` in `stmt` (e.g., 'tcp flags syn'), with
" values from linux/tcp.h.
"
" flags: syn, ack, fin, rst, psh, urg, ecn, cwr or 0 to 0xFF.
"  tcp flags in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp flags in { psh,syn,ack }
hi link   nft_payload_expr_close_scope_tcp_flags_inline_set_symbol_expr_string_keyword_defines nftHL_Define
syn match nft_payload_expr_close_scope_tcp_flags_inline_set_symbol_expr_string_keyword_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t\n,\-\}]'  skipwhite contained

"  tcp flags in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_flags_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_flags_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp flags in {  }
hi link    nft_payload_expr_tcp_hdr_field_flags_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_flags_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_flags_inline_set_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_flags_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines nftHL_Define
syn match nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines '\v(syn|ack|fin|rst|psh|urg|ecn|cwr)\ze[ \t;\}\n]'  skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_flags_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_flags_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp flags NUM
hi link   nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_flags_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_flags_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines,
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_flags_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_flags' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags '\vflags\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_string_keyword_defines,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_flags_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_flags_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_flags_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_flags_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_flags_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END tcp flags' *************************

" ************************* BEGIN  tcp window' *************************
hi link   nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp window in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_window nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_window '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n\-\},]' skipwhite contained

"  tcp window in {  }
hi link    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_inline_set_window
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_window_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_window_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex,
\    nft_Error

"   tcp window NUM
hi link   nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})\ze[ \t\-\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_window' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window '\vwindow\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'tcp window' *************************

" ************************* BEGIN 'tcp urgptr' ************************
hi link   nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp urgptr in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_urgptr nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_urgptr '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n\-\},]' skipwhite contained

"  tcp urgptr in {  }
hi link    nft_payload_expr_tcp_hdr_field_urgptr_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_urgptr_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_inline_set_urgptr
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_urgptr_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_urgptr_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex,
\    nft_Error

"   tcp urgptr NUM
hi link   nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})\ze[ \t\-\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_urgptr_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_urgptr_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_urgptr_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_urgptr_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_urgptr' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr '\vurgptr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_urgptr_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_urgptr_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_urgptr_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_urgptr_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_urgptr_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'tcp urgptr' *************************

" ************************* BEGIN 'tcp option' ***********************
" tcp option mss size '1460'      # no strings
" tcp option mss size ssh         # no service names
" tcp option mss size @mss_set    # set ≠ scalar
" tcp option sack-perm length     # missing expr
"
" Option     Value    Field    Value    Notes
" kind                         Range
"
" echo       8        LENGTH   0–255    Option length.
" eol        0                          End of options (no fields).
" fastopen  34        LENGTH   0–255    Option length.
" md5sig    19        LENGTH   0–255    Option length (fixed 18).
" mptcp     30        SUBTYPE  0–255    MPTCP subtype (e.g., 0=MP_CAPABLE, 1=MP_JOIN).
" mss        2        SIZE     0–65535  Maximum segment size (e.g., tcp option mss size 1460).
" nop        1                          No operation (no fields).
" sack_perm  4        LENGTH   0–255    Option length (fixed 2).
" timestamp  8        TSVAL    0–4294967295  Timestamp value.
"                     TSECR,   0–4294967295  Timestamp echo reply.
" window     3        COUNT    0–255    Scale count (0–14).
" sack       5        LEFT     0–4294967295  Left edge of SACK.
" sack1      5        RIGHT    0–4294967295  Right edge of SACK.
" sack2      5                               Additional SACK edges (similar to LEFT/RIGHT).
" sack3      5                               Additional SACK edges (similar to LEFT/RIGHT).
" Custom     0–255    LENGTH   0–255    Generic option length.

" ******************** BEGIN 'tcp option NUM' ********************
" ********************** END 'tcp option NUM' ********************
" ******************** BEGIN 'tcp option nop' ********************
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop '\vnop|1\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
" ********************** END 'tcp option nop' ********************

" ******************** BEGIN 'tcp option mss' ********************
"  tcp mss in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp mss in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_mss_inline_set_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mss_inline_set_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n\-\},]' skipwhite contained

"  tcp mss in {  }
hi link    nft_payload_expr_tcp_hdr_field_mss_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_mss_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_mss_inline_set_integer_expr_num_uint16_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_mss_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_mss_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_Error

"   tcp mss NUM
hi link   nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9][0-9][0-9][0-9])|[0-9][0-9][0-9][0-9]|[0-9][0-9][0-9]|[0-9][0-9]|[0-9]\ze[ \t\n\-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mss_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_mss_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mss_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_mss_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_mss_keyword_size nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_mss_keyword_size '\vsize\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_mss_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_mss' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss '\vmss|2\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_mss_keyword_size,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mss_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_mss_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_mss_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ********************** END 'tcp option mss' ********************

" ******************** BEGIN 'tcp option eol' ********************
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol '\veol|0\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt
" ********************** END 'tcp option eol' ********************

" ******************** BEGIN 'tcp option echo' ********************
"  tcp echo in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp echo in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_echo_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_echo_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp echo in {  }
hi link    nft_payload_expr_tcp_hdr_field_echo_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_echo_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_echo_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_echo_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_echo_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp echo NUM
hi link   nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_echo_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_echo_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_echo_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_echo_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_echo_keyword_length nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_echo_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_echo_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_echo' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo '\vecho|8\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_echo_keyword_length,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_echo_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_echo_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_echo_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ********************** END 'tcp option echo' ********************

" ******************** BEGIN 'tcp option sack' ********************
"  tcp sack in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp sack in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_sack_inline_set_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_inline_set_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n\-\},]' skipwhite contained

"  tcp sack in {  }
hi link    nft_payload_expr_tcp_hdr_field_sack_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_sack_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_sack_inline_set_integer_expr_num_uint32_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sack_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_sack_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error

"   tcp sack NUM
hi link   nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sack_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left nftHL_Keyword
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left '\vleft\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sack_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right nftHL_Keyword
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right '\vright\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sack_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_sack' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack '\vsack|5\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ********************** END 'tcp option sack' ********************

" ******************** BEGIN 'tcp option mptcp' ********************
"  tcp mptcp in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp mptcp in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_mptcp_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mptcp_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\},]' skipwhite contained

"  tcp mptcp in {  }
hi link    nft_payload_expr_tcp_hdr_field_mptcp_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_mptcp_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_mptcp_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_mptcp_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_mptcp_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp mptcp NUM
hi link   nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mptcp_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_mptcp_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_mptcp_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_mptcp_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_mptcp_keyword_subtype nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_mptcp_keyword_subtype '\vsubtype\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_mptcp_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_mptcp' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp '\vmptcp|30\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_mptcp_keyword_subtype,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mptcp_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_mptcp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_mptcp_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ******************** END 'tcp option mptcp' **********************

" ******************** BEGIN 'tcp option sack3' ********************
" 'payload_expr tcp_hdr_field_sack' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack3 nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack3 '\vsack3|5\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ******************** END 'tcp option sack3' **********************

" ******************** BEGIN 'tcp option sack2' ********************
" 'payload_expr tcp_hdr_field_sack2' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack2 nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack2 '\vsack2|5\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error
" ******************** END 'tcp option sack2' **********************

" ******************** BEGIN 'tcp option sack1' ********************
" 'payload_expr tcp_hdr_field_sack1' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack1 nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack1 '\vsack1|5\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error
" ******************** END 'tcp option sack1' **********************

" ******************** BEGIN 'tcp option sack0' ********************
" 'payload_expr tcp_hdr_field_sack0' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack0 nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack0 '\vsack0|5\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_right,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_left,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_integer_expr_num_uint32_hex,
\    nft_Error
" ******************** END 'tcp option sack0' **********************

" ******************** BEGIN 'tcp option window' ********************
"  tcp window in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp window in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_window_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_window_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp window in {  }
hi link    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_window_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_window_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_window_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp window NUM
hi link   nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_count nftHL_Keyword
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_count '\vcount\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_window_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_window' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_window nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_window '\vwindow|3\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_count,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_window_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_window_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_window_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ********************** END 'tcp option window' ********************

" ******************** BEGIN 'tcp option md5sig' ********************
"  tcp md5sig in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp md5sig in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_md5sig_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_md5sig_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp md5sig in {  }
hi link    nft_payload_expr_tcp_hdr_field_md5sig_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_md5sig_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_md5sig_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_md5sig_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_md5sig_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp md5sig NUM
hi link   nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_md5sig_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_md5sig_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_md5sig_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_md5sig_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_md5sig_keyword_length nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_md5sig_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_md5sig_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_md5sig' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig '\vmd5sig|19\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_md5sig_keyword_length,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_md5sig_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_md5sig_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_md5sig_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ********************** END 'tcp option md5sig' ********************

" ********************** END 'tcp option fastopen' ********************
"  tcp fastopen in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp fastopen in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_fastopen_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_fastopen_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp fastopen in {  }
hi link    nft_payload_expr_tcp_hdr_field_fastopen_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_fastopen_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_fastopen_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_fastopen_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_fastopen_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp fastopen NUM
hi link   nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_fastopen_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_fastopen_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_fastopen_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_fastopen_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_fastopen_keyword_length nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_fastopen_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_fastopen_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_fastopen' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen '\vfastopen|34\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_fastopen_keyword_length,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_fastopen_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_fastopen_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_fastopen_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ******************** END 'tcp option fastopen' *********************

" ******************** BEGIN 'tcp option timestamp' ******************
"  tcp timestamp in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp timestamp in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_timestamp_inline_set_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_timestamp_inline_set_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n\-\},]' skipwhite contained

"  tcp timestamp in {  }
hi link    nft_payload_expr_tcp_hdr_field_timestamp_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_timestamp_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_timestamp_inline_set_integer_expr_num_uint32_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_timestamp_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_timestamp_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_Error

"   tcp timestamp NUM
hi link   nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_timestamp_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_timestamp_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_timestamp_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_timestamp_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsecr nftHL_Keyword
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsecr '\vtsecr\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_timestamp_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_Error

hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsval nftHL_Keyword
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsval '\vtsval\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_timestamp_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_timestamp' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp '\vtimestamp\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsecr,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_kind_and_field_keyword_tsval,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_timestamp_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_timestamp_integer_expr_num_uint32_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ******************** END 'tcp option timestamp' ********************

" ******************** BEGIN 'tcp option sack-perm' ******************
"  tcp sack_perm in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp sack_perm in { 1,2,4 }
hi link   nft_payload_expr_close_scope_tcp_sack_perm_inline_set_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_perm_inline_set_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n\-\},]' skipwhite contained

"  tcp sack_perm in {  }
hi link    nft_payload_expr_tcp_hdr_field_sack_perm_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_sack_perm_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_sack_perm_inline_set_integer_expr_num_uint8_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9]{1,2})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_sack_perm_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_sack_perm_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_Error

"   tcp sack_perm NUM
hi link   nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range '\v(0x([A-Fa-f0-9]{1,2}))|(25[0-5])|(2[0-4][0-9])|(1[0-9][0-9])|([0-9][0-9])|[0-9]\ze[ \t\n-;]' skipwhite keepend contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_perm_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_sack_perm_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_sack_perm_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sack_perm_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

hi link   nft_payload_expr_close_scope_tcp_option_sack_perm_keyword_length nftHL_Keyword
syn match nft_payload_expr_close_scope_tcp_option_sack_perm_keyword_length '\vlength\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_sack_perm_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_Error

" 'payload_expr tcp_hdr_field_sack_perm' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm '\v4|sack\-permitted|sack\-perm\ze[ \t\;\n]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_option_sack_perm_keyword_length,
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_perm_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_sack_perm_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex_range,
\    nft_payload_expr_close_scope_tcp_sack_perm_integer_expr_num_uint8_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ******************** END 'tcp option sack-perm' ********************

hi link   nft_payload_expr_tcp_hdr_expr_keyword_option nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_keyword_option '\voption\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack_perm,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_timestamp,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_fastopen,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_md5sig,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_window,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mptcp,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack0,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack1,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack2,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack3,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_sack,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_echo,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_eol,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_mss,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_nop,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_option_type_keyword_num
" ************************* END 'tcp option' *************************

" ************************* BEGIN tcp checksum' *************************
hi link   nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp checksum in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_inline_set_checksum nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_inline_set_checksum '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n\-\},]' skipwhite contained

"  tcp checksum in {  }
hi link    nft_payload_expr_tcp_hdr_field_checksum_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_checksum_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_inline_set_checksum
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_checksum_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_checksum_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex,
\    nft_Error

"   tcp checksum NUM
hi link   nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range '\v(0x[0-9a-fA-F]{1,4})|([0-9]{1,5})\ze[ \t\-\n;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_checksum_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_checksum_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_checksum_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_checksum_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_checksum' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum '\vchecksum\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_checksum_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_checksum_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_checksum_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_checksum_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex_range,
\    nft_payload_expr_close_scope_tcp_checksum_integer_expr_num_uint16_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'tcp checksum' ***********************

" ************************* BEGIN 'tcp ackseq' *************************
hi link   nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp ackseq in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_ackseq_inline_set_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_ackseq_inline_set_integer_expr_num_uint32_hex  '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n\-\},]' skipwhite contained

"  tcp ackseq in {  }
hi link    nft_payload_expr_tcp_hdr_field_ackseq_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_ackseq_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_ackseq_inline_set_integer_expr_num_uint32_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex '\v(0x[0-9a-fA-F]{1,4})|6553[0-5]|655[0-2][0-9]|(65[0-4][0-9][0-9])|(6[0-4][0-9][0-9][0-9])|([0-5][0-9]{0,4})\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_ackseq_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_ackseq_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_Error

"   tcp ackseq NUM
hi link   nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range '\v0x[0-9a-fA-F]{1,8}|429496729[0-5]|42949672[0-8][0-9]|4294967[01][0-9]{2}|429496[0-6][0-9]{3}|42949[0-5][0-9]{4}|4294[0-8][0-9]{5}|429[0-3][0-9]{6}|42[0-8][0-9]{7}|4[01][0-9]{8}|[1-3][0-9]{9}|[0-9]{1,9}\ze[ \t\n;\-]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_ackseq_dash_symbol,
\    nft_Error
" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_ackseq_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_ackseq_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_ackseq_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_ackseq' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq '\vackseq\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_ackseq_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END  tcp ackseq' *************************

" ************************* BEGINtcp sequence' *************************
" 'payload_expr tcp_hdr_field_sequence' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence '\vsequence\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_ackseq_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_ackseq_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_ackseq_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex_range,
\    nft_payload_expr_close_scope_tcp_ackseq_integer_expr_num_uint32_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END  tcp sequence' *************************

" ************************* BEGIN 'tcp reserved' *********************
hi link   nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr nftHL_Variable
syn match nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr '\v\$[a-zA-Z][a-zA-Z0-9\-_]{0,63}\ze[ \t\n;]' skipwhite contained
\ nextgroup=
\    @nft_c_stmt

"  tcp reserved in { 1,127,255 }
hi link   nft_payload_expr_close_scope_tcp_reserved_inline_set_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_reserved_inline_set_integer_expr_num_uint4_hex '\v0x[0-9a-fA-F]|1[0-5]|[0-9]\ze[ \t\-\},]' contained

"  tcp reserved in {  }
hi link    nft_payload_expr_tcp_hdr_field_reserved_set_expr_inline_set nftHL_BlockDelimitersSet
syn region nft_payload_expr_tcp_hdr_field_reserved_set_expr_inline_set start=+{+ end=+}+ skipwhite contained
\ contains=
\    nft_payload_expr_close_scope_tcp_reserved_inline_set_integer_expr_num_uint4_hex
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex '\v0x[0-9a-fA-F]|1[0-5]|[0-9]\ze[ \t\n;]' contained
\ nextgroup=
\    @nft_c_stmt

hi link   nft_payload_expr_close_scope_tcp_reserved_dash_symbol nftHL_Expression
syn match nft_payload_expr_close_scope_tcp_reserved_dash_symbol '\v\-' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex,
\    nft_Error

"   tcp reserved
hi link   nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range nftHL_Integer
syn match nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range '\v0x[0-9a-fA-F]|1[0-5]|[0-9]\ze[ \t\n\-\};]' contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_reserved_dash_symbol,
\    nft_Error

" END Operators - Scalar

hi link   nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_1char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_1char '\v\<|\>' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_2char '\v((\<|\>)\=)|gt|ge|lt|le' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex,
\    nft_UnexpectedCurlyBrace,
\    nft_UnexpectedQuote,
\    nft_UnexpectedAtSymbol,
\    nft_Error
" discrete operator ONLY with integer, inline set, setname, IP w/o CIDR
" discrete operator cannot do symbol-string (enum), IP w/ CIDR prefix, nor asterisk_string

hi link   nft_payload_expr_close_scope_tcp_reserved_relational_op_equality_2char nftHL_Operator
syn match nft_payload_expr_close_scope_tcp_reserved_relational_op_equality_2char '\v\=\=|\!\=' skipwhite contained
\ nextgroup=
\    nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_reserved_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex,
\    nft_UnexpectedQuote,
\    nft_Error
" equality operator cannot support asterisk_string, IP w/ CIDR prefix, nor set (equality is scalar only)

" 'payload_expr tcp_hdr_field_reserved' implied match
hi link   nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_reserved nftHL_Substatement
syn match nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_reserved '\vreserved\ze[ \t]' skipwhite contained
\ nextgroup=
\    nft_verdict_stmt_verdict_map_stmt_keyword_vmap,
\    nft_map_expr_keyword_map,
\    nft_payload_expr_close_scope_tcp_reserved_relational_op_equality_2char,
\    nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_2char,
\    nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr,
\    nft_payload_expr_close_scope_tcp_reserved_relational_op_discrete_1char,
\    nft_payload_expr_close_scope_tcp_reserved_symbol_expr_variable_expr,
\    nft_payload_expr_tcp_hdr_field_reserved_set_expr_inline_set,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex_range,
\    nft_payload_expr_close_scope_tcp_reserved_integer_expr_num_uint4_hex,
\    nft_Error
" implied match is good for any type of values; scalar, set membership, symbol name, $variable, @setname
" ************************* END 'tcp reserved' *************************

" tcp_hdr_expr is valid in chain_block and stmt_list
" tcp_hdr_expr 'tcp'
" 'tcp'->tcp_hdr_expr->inner_inet_expr->inner_expr->(vxlan_hdr_expr|gretap_hdr_expr|geneve_hdr_expr)
" 'tcp'->tcp_hdr_expr->gre_hdr_expr->payload_expr->(payload_stmt|primary_expr|primary_stmt_expr)
hi link   nft_payload_expr_tcp_hdr_expr_keyword_tcp nftHL_Statement
syn match nft_payload_expr_tcp_hdr_expr_keyword_tcp '\v[ \t\n]\zstcp\ze[ \t;]' skipwhite contained
\ nextgroup=
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_checksum,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_reserved,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sequence,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_ackseq,
\    nft_payload_expr_tcp_hdr_expr_keyword_option,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_urgptr,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_window,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_dport,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_flags,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_sport,
\    nft_payload_expr_tcp_hdr_expr_tcp_hdr_field_keyword_doff,
\    nft_UnexpectedSemicolon,
\    nft_Error
" *************** End of payload_expr tcp_hdr_expr 'tcp' *************************

  for s:this_semantic_file in s:tcp_hdr_expr_list_filepaths_semantic_later
    call nftables#syntax#log('OK', 'Loading ' . s:this_semantic_file)
    call nftables#syntax#load(s:this_semantic_file)
    call nftables#syntax#log('OK', 'Loaded ' . s:this_semantic_file)
  endfor
  call nftables#syntax#log('INFO', 'Loaded tcp_hdr_expr for buffer: ' . bufname('%'))
catch
  call nftables#syntax#log('ERROR', 'Failed to define tcp_hdr_expr.vim: ' . v:exception . ' at line ' . line('.') . ' in ' . expand('<sfile>:t') . ' at ' . v:throwpoint)
endtry


" END OF 'syntax' statements
"

call nftables#syntax#log('OK', 'End.')

" pop off the filespec of this script from its stack for logging purpose
call nftables#syntax#pop()

" Then mark this script file as not-to-be-run-again
let b:nft_did_nftables_tcp_hdr_expr = v:true
