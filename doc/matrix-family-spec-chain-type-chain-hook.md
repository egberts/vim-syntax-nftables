Matrix of chain hook, chain type, and family\_spec\_explicit:

Sorted in nft keyword sequence LL(1) order (`parser_bison.y`) from:
  - Family\_spec
  - chain type
  - chain hook
  - priority (non-numerical pre-defined keywords)

ip -
  - filter
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - forward
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - nat
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - route
    - output
      - raw, mangle, filter, security

ip6 -
  - filter
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - forward
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - nat
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - route
    - output
      - raw, mangle, filter, security

inet -
  - filter
    - ingress
      - filter
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - forward
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - nat
    - prerouting
      - raw, mangle, dstnat, filter, security,
    - input
      - raw, mangle, filter, security
    - output
      - raw, mangle, filter, security
    - postrouting
      - raw, mangle, filter, security, srcnat,
  - route
    - output
      - raw, mangle, filter, security

bridge -
  - filter
    - prerouting
      - dstnat
      - filter
    - input
      - filter
    - forward
      - filter
    - output
      - filter
      - out
    - postrouting
      - filter
      - srcnat

netdev -
  - filter
    - ingress
      - filter
    - egress
      - filter

arp -
  - filter
    - input
      - filter
    - output
      - filter


Specially-defined non-numerical keywords for priority level:

  - bridge: dstnat, filter, srcnat, out
  - inet: security, dstnat, filter, mangle, srcnat, raw
  - (other family\_spec): security, dstnat, filter, mangle, srcnat, raw


References:

* [Configuring chains](https://wiki.nftables.org/wiki-nftables/index.php/Configuring_chains)
* [Priority table](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks#Priority_within_hook)
* [Netfilter hooks](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks)

