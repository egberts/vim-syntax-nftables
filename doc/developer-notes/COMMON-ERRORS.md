# Error: Could not process rule: Operation not permitted

Well, first step is to use `sudo` or a root shell.

```console
    $ sudo nft list ruleset
```


# Error: Chain of type "filter" is not supported, perhaps kernel support is missing?

Usually means one of the following statement got illegally used inside a specific family chain or outside of a specific chain type:

  * `devices`  (only netdev family, filter type & ingress hook)
  * `dnat to` (only ip/ip6/inet family, nat type & prerouting/input hook)
  * `flags offload` (only filter type, ingress hook & netdev family)
  * `fwd to`  (only ip/ip6 family, filter type & forward hook)
  * `ibriport` (only bridge family, filter type & input/forward/output hook)
  * `ibrname` (only bridge family, filter type & input/forward hook)
  * `meta ibriport` (only bridge family, filter type & input/forward hook)
  * `meta obriport` (only bridge family, filter type & output/forward hook)
  * `obriport` (only bridge family, filter type & forward/output hook)
  * `obrname` (only bridge family, filter type & output/forward hook)
  * `redirect` (only ip/ip6/inet family, nat chain type & prerouting/input hook)
  * `snat to` (only ip/ip6/inet family, nat type & postrouting/output hook)

In ip (or implicit) family, invalid chain statements are:

  * `devices`  (netdev family only)
  * `dnat to` (only in nat type & prerouting/input hook)
  * `flags offload` (netdev family only)
  * `fwd to`  (only in filter type & forward hook)
  * `ibriport` (bridge family only)
  * `ibrname` (bridge family only)
  * `meta ibriport` (bridge family only)
  * `meta obriport` (bridge family only)
  * `obriport` (bridge family only)
  * `obrname` (bridge family only)
  * `redirect` (only in nat type & prerouting/input hook)

In ip6 family, invalid chain statements are:

  * `devices`  (netdev family only)
  * `dnat to` (only in nat type & prerouting/input hook)
  * `flags offload` (netdev family only)
  * `fwd to`  (only in filter type & forward hook)
  * `ibriport` (bridge family only)
  * `ibrname` (bridge family only)
  * `meta ibriport` (bridge family only)
  * `meta obriport` (bridge family only)
  * `obriport` (bridge family only)
  * `obrname` (bridge family only)
  * `redirect` (only in nat type & prerouting/input hook)
  * `snat to` (only in nat type & postrouting/output hook)

In inet family, invalid chain statements are:

  * `devices`  (netdev family only)
  * `dnat to` (only in nat type & prerouting/input hook)
  * `flags offload` (netdev family only)
  * `fwd to`  (ip/ip6 family only)
  * `ibriport` (bridge family only)
  * `ibrname` (bridge family only)
  * `meta ibriport` (bridge family only)
  * `meta obriport` (bridge family only)
  * `obriport` (bridge family only)
  * `obrname` (bridge family only)
  * `redirect` (only in nat chain type & prerouting/input hook)
  * `snat to` (only in nat type & postrouting/output hook)

In netdev family, invalid chain statements are:

  * `devices`  (only in filter type & ingress hook)
  * `dnat to` (ip/ip6/inet family only)
  * `flags offload` (only in filter type & ingress hook)
  * `fwd to`  (ip/ip6 family only)
  * `ibriport` (bridge family only)
  * `ibrname` (bridge family only)
  * `meta ibriport` (bridge family only)
  * `meta obriport` (bridge family only)
  * `obriport` (bridge family only)
  * `obrname` (bridge family only)
  * `redirect` (ip/ip6/inet family only)
  * `snat to` (ip/ip6/inet family only)

In bridge family, invalid chain statements are:

  * `devices`  (netdev family only)
  * `dnat to` (ip/ip6/inet family only)
  * `flags offload` (netdev family only)
  * `fwd to`  (ip/ip6 family only)
  * `redirect` (ip/ip6/inet family only)
  * `snat to` (ip/ip6/inet family only)

In arp family, invalid chain statements are:

  * `devices`  (netdev family only)
  * `dnat to` (ip/ip6/inet family only)
  * `flags offload` (netdev family only)
  * `fwd to`  (ip/ip6 family only)
  * `ibriport` (bridge family only)
  * `ibrname` (bridge family only)
  * `meta ibriport` (bridge family only)
  * `meta obriport` (bridge family only)
  * `obriport` (bridge family only)
  * `obrname` (bridge family only)
  * `redirect` (ip/ip6/inet family only)
  * `snat to` (ip/ip6/inet family only)

Inserted into Nftables.Org Wiki [Troubleshooting](https://wiki.nftables.org/wiki-nftables/index.php/Troubleshooting#Question_5:_Could_not_process_rule:_Operation_not_permitted) page.



