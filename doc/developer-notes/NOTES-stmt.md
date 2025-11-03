Ok.  I am at this last stage of doing EBNF to LL(1) translation: the `stmt` symbol.

Some preparations needed are:

* Aggregate all the first encounter of terminal symbols pointed to by this 'stmt' non-terminal symbol
* * This entails deep navigation of all pathways until each first encounter of a terminal symbol (token keyword) is found
* * DHparser tool solves this problem.
* Reconcile multiple but disparate pathways together to that same first-encounter terminal symbol (translating to LL(1)).
* * This entails smashing graph branches together (no tools available)

If we are going to master the full pathways of all keywords hanging off of 'stmt', we must observe the following limitation f Vimscript:

# Terminology
Terminology used here in this document are both derived from Bison LEX/YACC and Vimscript syntax.

| Bison | Vimscript                                                                        |
|----|----------------------------------------------------------------------------------|
| symbol | group                                                                            |
| symbol name | group name                                                                       |
| terminal symbol | `syntax match` (or  `syntax keyword` that we do not use) |
| non-terminal symbol | `syntax cluster`                                                                 |
| state transition | between a `syntax match` group name and its `nextgroup=` / `contains=` groupname |
| token | keyword                                                                          |


# Vimscript limitation with LL(1)

1. The same regex cannot be used inside as well as outside a defined block region.  Regex duplication and unique group names are a must.

Cannot reuse a Bison symbol across defined block regions (also called Vimscript 'syntax region') boundaries; must duplicate Bison symbol by prepending a different pathway prefix to its group name.

Ideal naming convention for nftable Bison 'stmt' semantic action symbolc that is 
found in the following commands:

    add chain T C <stmt>  # add_cmd
    add rule T C <stmt>  # add_cmd
    rule T C <stmt>   # add_cmd
    insert rule T C <stmt>  # insert_cmd
    replace rule T C <stmt>  # replace_cmd
    table T { chain C { <stmt>; }  # chain_block
    table T { chain C { jump { <stmt> }; }  # chain_stmt

would be to note boundaries of '{' braces as 'syntax region's. 

The 'stmt' in 'add chain' is top-level region.  So is 'add rule'.
Also 'rule T C <stmt>'.

The 'stmt' in 'table T { chain {' is in 3rd-level block region (2-nested), 
we cannot reuse the same Vimscript group name inside a different region 
without breaking its `start=`/`end=` mechanism that neatly parse the boundaries of 
each block region.

If 'stmt' symbol is to be reused deeper inside nest block(s) (eg. the chain block inside table block), 
that 'stmt' group must be duplicated and its group name would have to be 
uniquely renamed, such as 'nft_chain_block_stmt'.

Recap of NFT commands and its group name:

    add chain T C <stmt>             nft_stmt
    add rule T C <stmt>              nft_stmt
    rule T C <stmt>                  nft_stmt
    insert rule T C <stmt>           nft_stmt
    replace rule T C <stmt>          nft_stmt
    table T { chain C { <stmt>; }    nft_table_block_chain_block_chain_rule_rule_alloc_stmt
    table T { chain C { jump { <stmt> }; }   nft_table_block_chain_block_chain_rul_rule_alloc_stmt_verdict_stmt_verdict_expr_chain_expr

The nft_table_block_chain_block_stmt group (`stmt`) be reused if they share the same parent region.  
'add chain', 'add rule', and 'rule' are the same level (top-level) region nesting.

Reuse of a group is ok if they are distant but disjoint relatives, but not directly related.
This means 'nft_stmt' can be reused for 'add rule', 'rule', as well as 'add chain'.  But not 'table { chain { rule ...'.

In short, duplicate/split and rename is only needed if direct 
ancestral/descendant pathway line is seen between two points of group names; 

I thought using the more simple `nft_chain_block_stmt` instead, but we 
have multiple nestings of blocks going on throughout the nftables syntax so seeing two(2) 
blocks in the group name would be a helpful reading/debugging aid.

It is paramount to be tracking the closing curly braces (NFT syntax) delimiter to ensure that it matches up with its paired starting curly brace delimiter.

# First-Occurance Keywords to `stmt`

A list of keywords that are first encountered in the `stmt` non-terminal symbol:
             
```
masquerade/masq_stmt_alloc/masq_stmt

rtclassid/meta_key_unqualified/meta_stmt
rtclassid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
rtclassid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
rtclassid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt

continue/verdict_expr/verdict_stmt
ibriport/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
ibriport/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ibriport/meta_key_unqualified/meta_stmt
ibriport/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
iifgroup/meta_key_unqualified/meta_stmt
iifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
iifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
iifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
obriport/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
obriport/meta_key_unqualified/meta_stmt
obriport/meta_key_unqualified/meta_expr/primary_expr/basic_exprconcat_expr/expr/relational_expr/match_stmt
obriport/meta_key_unqualified/meta_expr/primary_expr/basic_exprconcat_expr/map_expr/expr/relational_expr/match_stmt
oifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
oifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
oifgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oifgroup/meta_key_unqualified/meta_stmt
redirect/redir_stmt_alloc/redir_stmt
synproxy/objref_stmt_synproxy/objref_stmt
synproxy/synproxy_stmt_alloc/synproxy_stmt

cfgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
cfgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
cfgroup/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
counter/counter_stmt/stateful_stmt
counter/objref_stmt_counter/objref_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ibrname/meta_key_unqualified/meta_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ibrname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
iifname/meta_key_unqualified/meta_stmt
iifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
iifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
iifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
iiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
iiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
iiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
iiftype/meta_key_unqualified/meta_stmt
nftrace/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
nftrace/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
nftrace/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
nftrace/meta_key_unqualified/meta_stmt
notrack/meta_stmt
obrname/meta_key_unqualified/meta_stmt
oifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
oifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
oifname/meta_key_unqualified/meta_stmt
oifname/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oiftype/meta_key_unqualified/meta_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
oiftype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
pkttype/meta_key_unqualified/meta_stmt
pkttype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
pkttype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
pkttype/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
symhash/hash_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
symhash/hash_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
symhash/hash_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
udplite/udplite_hdr_expr/payload_expr/payload_stmt
udplite/udplite_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt

accept/verdict_expr/verdict_stmt
cgroup/meta_key_unqualified/meta_stmt
delete/set_stmt_op/set_stmt
delete/set_stmt_op/map_stmt
exthdr/exthdr/exthdr_exists_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
geneve/geneve_hdr_expr/payload_expr/payload_stmt
geneve/geneve_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
gretap/gretap_hdr_expr/payload_expr/payload_stmt
gretap/gretap_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
numgen/numgen_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
numgen/numgen_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
numgen/numgen_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
reject/reject_stmt_alloc/reject_stmt
return/verdict_expr/verdict_stmt
socket/socket_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
socket/socket_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
socket/socket_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
tproxy/tproxy_stmt_alloc/tproxy_stmt
update/set_stmt_op/set_stmt
update/set_stmt_op/map_stmt

icmp6/icmp6_hdr_expr/payload_expr/payload_stmt
icmp6/icmp6_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ipsec/meta_key_unqualified/meta_stmt
ipsec/xfrm_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
ipsec/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
ipsec/xfrm_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ipsec/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ipsec/xfrm_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ipsec/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
jhash/hash_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
jhash/hash_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
jhash/hash_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
limit/objref_stmt_limit/objref_stmt
limit/limit_stmt/stateful_stmt
meter/meter_stmt_alloc/meter_stmt
queue/queue_stmt_alloc/queue_stmt
queue/queue_stmt_alloc/queue_stmt_compat/queue_stmt
quota/quota_stmt/stateful_stmt
quota/objref_stmt_quota/objref_stmt
reset/optstrip_stmt
skgid/meta_key_unqualified/meta_stmt
skgid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
skgid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
skgid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
skuid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
skuid/meta_key_unqualified/meta_stmt
skuid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
skuid/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
vxlan/vxlan_hdr_expr/payload_expr/payload_stmt
vxlan/vxlan_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt

auth/auth_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
auth/auth_hdr_expr/payload_expr/payload_stmt
comp/comp_hdr_expr/payload_expr/payload_stmt
comp/comp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
dccp/dccp_hdr_expr/payload_expr/payload_stmt
dnat/nat_stmt_alloc/nat_stmt
drop/verdict_expr/verdict_stmt
flow/meta_stmt
frag/frag_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
goto/chain_stmt_type/chain_stmt
goto/verdict_expr/verdict_stmt
hour/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
hour/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
hour/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
hour/meta_key_unqualified/meta_stmt
icmp/icmp_hdr_expr/payload_expr/payload_stmt
icmp/icmp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
igmp/igmp_hdr_expr/payload_expr/payload_stmt
igmp/igmp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
jump/chain_stmt_type/chain_stmt
jump/verdict_expr/verdict_stmt
last/last_stmt/stateful_stmt
mark/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
mark/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
mark/meta_key_unqualified/meta_stmt
mark/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
meta/meta_stmt
meta/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
sctp/sctp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
sctp/sctp_hdr_expr/payload_expr/payload_stmt
snat/nat_stmt_alloc/nat_stmt
time/meta_key_unqualified/meta_stmt
time/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
time/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
time/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
vlan/vlan_hdr_expr/payload_expr/payload_stmt
vlan/vlan_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt

add/set_stmt_op/map_stmt
add/set_stmt_op/set_stmt
arp/arp_hdr_expr/payload_expr/payload_stmt
arp/arp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
cpu/meta_key_unqualified/meta_stmt
day/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
day/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
day/meta_key_unqualified/meta_stmt
day/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
dst/dst_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
dup/dup_stmt
esp/esp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
esp/esp_hdr_expr/payload_expr/payload_stmt
eth/eth_hdr_expr/payload_expr/payload_stmt
eth/eth_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
fib/fib_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
fib/fib_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
fib/fib_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
fwd/fwd_stmt
gre/gre_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
gre/gre_hdr_expr/payload_expr/payload_stmt
hbh/hbh_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
iif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
iif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
iif/meta_key_unqualified/meta_stmt
iif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ip6/ip6_hdr_expr/payload_expr/payload_stmt
ip6/ip6_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
log/log_stmt_alloc/log_stmt
oif/meta_key_unqualified/meta_stmt
oif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
oif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
oif/meta_key_unqualified/meta_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
osf/osf_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
osf/osf_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
osf/osf_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
rt0/rt0_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
rt2/rt2_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
rt4/rt4_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
set/fwd_stmt
udp/udp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
udp/udp_hdr_expr/payload_expr/payload_stmt
tcp/tcp_hdr_expr/payload_expr/payload_stmt
tcp/tcp_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt

at/payload_raw_expr/payload_expr/payload_stmt
at/payload_raw_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ct/ct_stmt
ct/ct_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
ct/ct_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
ct/ct_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
ct/objref_stmt_ct/objref_stmt
ct/connlimit_stmt/stateful_stmt
ip/ip_hdr_expr/payload_expr/payload_stmt
ip/ip_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
mh/mh_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
rt/rt_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
rt/rt_expr/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
rt/rt_expr/primary_expr/basic_expr/concat_expr/expr/relational_expr/match_stmt
rt/rt_hdr_expr/exthdr_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
th/th_hdr_expr/payload_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
th/th_hdr_expr/payload_expr/payload_stmt
xt/xt_stmt

'{'/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
'{'/primary_expr/basic_expr/concat_expr/map_expr/expr/relational_expr/match_stmt
'{'/primary_expr/basic_expr/concat_expr//expr/relational_expr/match_stmt
'{'set_expr/expr/relational_expr/match_stmt
quoted_string/string/symbol_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
string/string/symbol_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
asterisk_string/string/symbol_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
$variable/symbol_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
[0-9]{1,10}/integer_expr/primary_expr/basic_expr/concat_expr/verdict_map_stmt/verdict_stmt
```



