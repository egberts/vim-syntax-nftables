'rule'
# basic
T C <rule>
ip T C <rule>
arp T C <rule>
ip6 T C <rule>
inet T C <rule>
netdev T C <rule>
bridge T C <rule>

# 'rule'
rule T C <rule>
rule ip T C <rule>
rule arp T C <rule>
rule ip6 T C <rule>
rule inet T C <rule>
rule netdev T C <rule>
rule bridge T C <rule>

# 'add'-only, defaults to 'rule'
add T C <rule>
add ip T C <rule>
add arp T C <rule>
add ip6 T C <rule>
add inet T C <rule>
add netdev T C <rule>
add bridge T C <rule>

# 'add rule'
add rule T C <rule>
add rule ip T C <rule>
add rule arp T C <rule>
add rule ip6 T C <rule>
add rule inet T C <rule>
add rule netdev T C <rule>
add rule bridge T C <rule>

Prior to the First Lexical Order of 'rule'
==========================================

chain_spec_position_spec_NUM
chain_spec_handle_spec_NUM
chain_spec_index_spec_NUM

First Lexical Order of 'rule'
=============================
rule_alloc
  stmt+
    verdict_map
      primary_expr / * 'vmap' verdict_map_expr '{' verdict_map_list_member_expr
    match_stmt
      primary_expr / * 'vmap' verdict_map_expr '{' verdict_map_list_member_expr
    'masquerade' (masq_stmt/masq_stmt_alloc)
    'rtclassid' (meta_stmt)
    'continue' (verdict_stmt)
    'ibriport' (meta_stmt)
    'iffgroup' (meta_stmt)
    'obriport' (meta_stmt)
    'oifgroup' (meta_stmt)
    'redirect' (redir_stmt)
    'synproxy' (synproxy_stmt, objref_stmt/objref_stmt_synproxy)
    'cfgroup' (meta_stmt/meta_key_unqualified, meta_expr/meta_key_unqualified, 
    'counter' (stateful_stmt/counter_stmt/counter_stmt_alloc, objref_stmt/objref_stmt_counter)
    'ibrname' (meta_stmt)
    'iifname' (meta_stmt)
    'iiftype' (meta_stmt)
    'nftrace' (meta_stmt)
    'notrack' (meta_stmt)
    'obrname' (meta_stmt)
    'oifname' (meta_stmt)
    'oiftype' (meta_stmt)
    'pkttype' (meta_stmt)
    'udplite' (payload_stmt/payload_expr/udplite_hdr_expr)
    'accept' (verdict_stmt)
    'cgroup' (meta_stmt)
    'delete' (set_stmt/set_stmt_op, map_stmt/set_stmt_op)
    'geneve' (payload_stmt/payload_expr/geneve_hdr_expr)
    'gretap' (payload_stmt/payload_expr/gretap_hdr_expr)
    'reject' (reject_stmt/reject_stmt_alloc)
    'return' (verdict_stmt)
    'tproxy' (tproxy_stmt)
    'update' (set_stmt/set_stmt_op, map_stmt/set_stmt_op)
    'ether' (payload_stmt/payload_expr/ether_hdr_expr)
    'icmp6' (payload_stmt/payload_expr/icmp6_hdr_expr)
    'limit' (stateful_stmt/limit_stmt, objref_stmt/objref_stmt_limit)
    'meter' (meter_stmt_alloc)
    'queue' (queue_stmt)
    'quota' (stateful_stmt/quota_stmt, objref_stmt/objref_stmt_quota)
    'reset' (optstrip_stmt)
    'skgid' (meta_stmt)
    'skuid' (meta_stmt)
    'vxlan' (payload_stmt/payload_expr/vxlan_hdr_expr)
    'auth' (payload_stmt/payload_expr/auth_hdr_expr)
    'comp' (payload_stmt/payload_expr/comp_hdr_expr)
    'dccp' (payload_stmt/payload_expr/dccp_hdr_expr)
    'dnat' (nat_stmt/nat_stmt_alloc)
    'drop' (verdict_stmt)
    'flow' (meta_stmt)
    'goto' (chain_stmt/chain_stmt_type)
    'goto' (verdict_stmt)
    'icmp' (payload_stmt/payload_expr/icmp_hdr_expr)
    'igmp' (payload_stmt/payload_expr/igmp_hdr_expr)
    'jump' (verdict_expr (simple), chain_stmt/chain_stmt_type (by-label))
    'last' (stateful_stmt/last_stmt)
    'meta' (meta_stmt, meta_expr)
    'mark' (meta_stmt)
    'snat' (nat_stmt/nat_stmt_alloc)
    'add' (set_stmt/set_stmt_op, map_stmt/set_stmt_op)
    'arp' (payload_stmt/payload_expr/arp_hdr_expr)
    'cpu' (meta_stmt)
    'day' (meta_stmt)
    'dup' (dup_stmt)
    'esp' (payload_stmt/payload_expr/esp_hdr_expr)
    'fwd' (fwd_stmt)
    'gre' (payload_stmt/payload_expr/gre_hdr_expr)
    'iif' (meta_stmt)
    'ip6' (payload_stmt/payload_expr/ip6_hdr_expr)
    'log' (log_stmt/log_stmt_alloc)
    'oif' (meta_stmt)
    'set' (set_stmt)
    'tcp' (payload_stmt/payload_expr/tcp_hdr_expr)
    'udp' (payload_stmt/payload_expr/udp_hdr_expr)
    'at' (payload_stmt/payload_expr/at_hdr_expr)
    'ct' (stateful_stmt/connlimit_stmt)
    'ct' (ct_stmt *DUPLICATE!!!*)
    'ip' (payload_stmt/payload_expr/ip_hdr_expr)
    'th' (payload_stmt/payload_expr/th_hdr_expr)
    'xt' (xt_stmt, objref_stmt/objref_stmt_ct)
    '*'  (?????)
    '('  (?????)

Tip: We've been lucky so far, there are no lexical-first-order
keywords only found in primary_expr that are found in stmt:
in short, primary_expr is a subset of stmt, additional
keywords are only found in stmt.

'ct' duplicates:
Grammar Context  Role of ct keyword         Non-terminal            Example
stateful_stmt    Match on conntrack state   ct_expr (via ct_stmt)   ct state established
connlimit_stmt   Conntrack limiting action  connlimit_stmt          ct count over 100
ct_stmt          General conntrack expr     ct_stmt → ct_key expr   ct mark == 0x1234


ChatGPT came up with the following list:

'$'
'{'
ACCEPT
ADD
AH
ARP
ASTERISK_STRING
AT
COMP
COUNTER
CT
DCCP
DUP
ESP
ETHER
FWD
GENEVE
GRE
GRETAP
ICMP
IGMP
IP
JUMP
LAST
LIMIT
LOG
MASQUERADE
META
METER
QUEUE
QUOTA
QUOTED_STRING
REDIRECT
RESET
SCTP
SET
SNAT
STRING
SYNPROXY
TCP
TPROXY
TRANSPORT_HDR
UDP
UDPLITE
VLAN
VXLAN
XT
_REJECT


Vimscript, as suggested by ChatGPT:

let s:rule_start = join([
  'accept', 'drop', 'return', 'counter', 'limit',
  'meta', 'mark', 'ct', 'tcp', 'udp', 'icmp',
  'masquerade', 'snat', 'dnat', 'log',
], '\|')

syntax region NftRuleAlloc
  start='^\s*\%(' . s:rule_start . '\|\h\w*\)'
  end=';'
  contains=@NftStmtCluster
  keepend


