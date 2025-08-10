# Meta keyword in nftables #

Keyword `meta` is broken down into following semantic actions:

* `meta_stmt` - meta keys alway has an accompanied `set` subkeyword and a set of values, except:
  * `meta flow` meta key, but has an accompanied `at` subkeyword, not a `set`
  * `meta notrack`, no accompanied value nor keyword `at`/`set`
* `meta_expr` - 
* `meta_key` 

`parser_bison.y` is a state table of semantic actions
that covers far more state transitions than what the actual 
`scanner.c` allows.

Only `meta` keyword use ouside of expression is 
the `describe` command, which leverages `meta_expr` 
(does not have a value after its meta key).

Both `meta_stmt` and `meta_expr` are only found within 
the `rule` command (both at intial command and inside 
table-chain blocks.

Keywords that follow `meta` is called "meta key" and
are available depending on its initial state:

* In `describe_cmd` state, `primary_expr` covers only `meta_expr` but no values after its 'meta key':
cgroup, cpu, day, hour, ibriport, ibrname, iif, iifgroup, iifname, iitype, ipsec, mark, nftrace, obriport, obrname, oif, oifgroup, oifname, oiftype, pkktype, rtclassid, skgid, skuid, time.  Unsupported meta keys are `notrack`, `flow` and unqualified keys like `length`, `protocol`, `priority`, `random`, `secmark`.
* In expression state, all meta keys except `notrack`, `flow` are supported: qualified meta keys are cgroup, cpu, day, hour, ibriport, ibrname, iif, iifgroup, iifname, iitype, ipsec, mark, nftrace, obriport, obrname, oif, oifgroup, oifname, oiftype, pkktype, rtclassid, skgid, skuid, time.  Unqualified keys like `length`, `protocol`, `priority`, `random`, `secmark`.
* In statement state, all known meta keys are supported: qualified meta keys, unqualified meta keys plus `notrack` and `flow`.

Only `meta_stmt` can optionally specify unqualified meta keys without the `meta` keyword.

Some value notations are limited to certain meta keys:

* 'any' token only works as expression value for `protocol`, `iffname`, and `oifname` (e.g., `rule T C meta protocol == any`).
* 'in' token only works as precursor to a set of value(s) for `iifname`, `offname`, and `protocol` (e.g., `rule T C meta protocol == any`).

## `meta mark` ##
In nftables, the meta mark expression is used to match or manipulate the packet mark, which is a 32-bit value that can be used to tag packets for various purposes (e.g., for routing decisions, QoS, or firewalling).
After meta mark, the valid keywords or character sets that you can use are:
1. Exact Match (==)

    You can use the == operator to match packets with a specific mark value.

    Example:

    nft add rule ip filter input meta mark == 0x1 accept

    This matches packets with the mark value 0x1 (or 1 in decimal).

2. Negation (!=)

    The != operator allows you to match packets not having a specific mark value.

    Example:

    nft add rule ip filter input meta mark != 0x1 drop

    This drops packets not having the mark 0x1.

3. Range Match (>=, <=)

    You can use range comparisons to match packets whose mark value is within a certain range.

    Example:

    nft add rule ip filter input meta mark >= 0x10 && meta mark <= 0x20 accept

    This matches packets with marks in the range 0x10 to 0x20.

4. Bitwise AND Operation (&)

    You can use the & operator to match packets based on specific bits of the mark using a bitwise AND operation.

    Example:

    nft add rule ip filter input meta mark & 0x2 == 0x2 accept

    This matches packets where the second least significant bit of the mark is set to 1.

5. Assign/Set Mark Value (set)

    You can use set to modify or set the packet's mark value within a rule action.

    Example:

    nft add rule ip filter input meta mark set 0x1 accept

    This sets the mark to 0x1 on the incoming packet.

6. Wildcards

    You can also use a wildcard (any) to match any mark value. This is less common but useful for default or general matches.

    Example:

    nft add rule ip filter input meta mark == any accept

    This matches all packets regardless of their mark.

Common Syntax Overview:

    Exact Match:

meta mark == 0x1

Negation:

meta mark != 0x1

Range Match:

meta mark >= 0x10 && meta mark <= 0x20

Bitwise AND:

meta mark & 0x2 == 0x2

Setting a Mark:

    meta mark set 0x1

Summary of Valid Keywords/Operators after meta mark:

    Comparison Operators:

        == (Exact match)

        != (Negation)

        >=, <= (Range match)

        & (Bitwise match)

    Set Operation:

        set (To assign or modify the mark value)

These operators are typically used in combination with specific mark values (in hexadecimal or decimal) to apply specific conditions or modify packet marks in nftables rules.


## `meta iif`/`meta oif` ##
1. Interface Name

    You can directly match the name of the interface (like eth0, wlan0, etc.).

    Example:

    nft add rule inet filter input meta iif eth0 accept

    This matches packets that are received on interface eth0.

2. Set of Interfaces

    You can define a set of interfaces and use it with the iif to match packets received on any of the interfaces in the set.

    Example:

    nft add set inet filter ifaces { type ifname\; }
    nft add element inet filter ifaces { "eth0", "eth1", "wlan0" }
    nft add rule inet filter input meta iif @ifaces accept

    This matches packets received on any interface in the ifaces set.

3. Interface Type (e.g., ifindex)

    You can match by the interface index (a numeric identifier for interfaces). This is not as common, but it can be used in advanced setups.

    Example:

    nft add rule inet filter input meta iif "eth0" accept

    Here, eth0 is specified directly, but it’s based on an index internally (you can also work with indexes directly if needed).

4. Negation (!=)

    You can use negation to match packets not coming from a specific interface.

    Example:

    nft add rule inet filter input meta iif != eth0 drop

    This drops packets that are not received on eth0.

5. Wildcard in Keyword (Match all interfaces)

    The wildcard in can be used to match any interface, regardless of name or type.

    Example:

    nft add rule inet filter input meta iif in accept

    This will match packets received on any interface.

6. Interface as part of a conditional statement

    You can combine iif with other conditions in rules. For example, you might want to match packets from a certain interface and from a specific source IP.

    Example:

    nft add rule inet filter input meta iif eth0 ip saddr 192.168.1.1 accept

    This will match packets received on interface eth0 and from source address 192.168.1.1.

7. Using iif with other meta fields:

You can combine meta expressions like iif with other packet attributes for more complex rules, such as oif (output interface), mark, dev, etc.

    Example using iif with oif:

    nft add rule inet filter input meta iif eth0 oif eth1 accept

    This matches packets coming in on interface eth0 and going out on interface eth1.

## `mark iifname` ##

In nftables, the meta iifname expression is used to match the input interface name of a packet, i.e., the name of the network interface on which a packet was received. The iifname keyword specifically matches the interface based on its name, like eth0, wlan0, etc.

Here are the valid keywords or character sets that can come after meta iifname in nftables rule statements:
1. Interface Name (Exact Match)

    The most straightforward match is to specify the exact name of the input interface you want to match against.

    Example:

    nft add rule ip filter input meta iifname "eth0" accept

    This matches packets received on the interface named eth0.

2. Wildcard Matching with in

    You can use the in keyword to match any interface (i.e., it’s a wildcard for any input interface).

    Example:

    nft add rule ip filter input meta iifname in accept

    This matches packets received on any interface.

3. Negation (!=)

    You can use the negation operator to match packets not received on a specific interface.

    Example:

    nft add rule ip filter input meta iifname != "eth0" drop

    This drops packets that were not received on interface eth0.

4. Set of Interface Names

    You can define a set of interface names and use it to match packets received on any of the interfaces in the set.

    Example:

    nft add set inet filter interfaces { type ifname\; }
    nft add element inet filter interfaces { "eth0", "eth1", "wlan0" }
    nft add rule inet filter input meta iifname @interfaces accept

    This matches packets received on any of the interfaces in the interfaces set (eth0, eth1, wlan0).

5. Regular Expressions (Advanced Usage)

    nftables also supports the use of regular expressions for matching input interface names. This allows you to match interfaces that follow a certain pattern or name scheme.

    Example:

    nft add rule ip filter input meta iifname ~ "^eth.*" accept

    This matches packets received on any interface whose name starts with eth, such as eth0, eth1, etc.

6. Combination with Other Conditions

    You can combine meta iifname with other conditions to build more complex rules. For instance, you might want to match packets on a specific interface and check the source IP address.

    Example:

    nft add rule ip filter input meta iifname "eth0" ip saddr 192.168.1.1 accept

    This matches packets received on eth0 with a source IP address of 192.168.1.1.

Summary of Valid Keywords/Character Sets After meta iifname:

    Exact Match: Match packets received on a specific interface (e.g., "eth0").

meta iifname "eth0"

Wildcard Match: Match packets received on any interface using the in keyword.

meta iifname in

Negation: Match packets not received on a specific interface using the != operator.

meta iifname != "eth0"

Set of Interface Names: Use a set of interfaces to match packets received on any interface in the set.

meta iifname @set_name

Regular Expression: Use a regular expression to match interface names with specific patterns.

meta iifname ~ "^eth.*"

Combination with Other Fields: Combine meta iifname with other conditions like IP address, protocol, etc.

    meta iifname "eth0" ip saddr 192.168.1.1

These are the valid ways you can use meta iifname in nftables rule statements to match or filter packets based on the input interface name.

## `meta iiftype`

In nftables, the meta iiftype expression is used to match the type of the input interface. The interface type refers to the network interface's type (e.g., Ethernet, wireless, loopback, etc.). The value for meta iiftype can be expressed in terms of the interface types that nftables recognizes.
Valid Keywords or Character Sets After meta iiftype

Here are the common keywords or character sets that you can use after meta iiftype in nftables:
1. Interface Types (numeric values)

The meta iiftype expression uses numeric interface types based on the type of the interface. These numeric values are defined in the Linux kernel to represent different interface types. For example:

    1 — Ethernet (e.g., eth0, eth1)

    2 — Token Ring (rarely used)

    6 — IEEE 802.11 (Wireless)

    24 — Loopback (e.g., lo)

Example with a numeric type:

nft add rule ip filter input meta iiftype 1 accept

This rule matches packets received on an Ethernet interface.
2. Set of Interface Types

You can define a set of valid interface types, and then match packets received on any interface that matches one of the types in the set.

Example:

nft add set inet filter if_types { type integer\; }
nft add element inet filter if_types { 1, 6 }
nft add rule inet filter input meta iiftype @if_types accept

This rule accepts packets received on interfaces of type Ethernet (1) or Wireless (6).
3. Range Matching (>=, <=)

You can use range matching to match interface types within a specific range. This is generally more useful if you know the numeric values that correspond to specific interface types and want to match a range of them.

Example:

nft add rule ip filter input meta iiftype >= 1 && meta iiftype <= 2 accept

This matches packets received on interfaces of type Ethernet (1) or Token Ring (2).
4. Negation (!=)

You can use the negation operator (!=) to match packets not received on a specific interface type.

Example:

nft add rule ip filter input meta iiftype != 1 drop

This rule drops packets received on non-Ethernet interfaces (not type 1).
Valid Interface Types (Numeric Values)

Here are some valid numeric interface types that you can match against using meta iiftype in nftables:

    1: Ethernet (Ethernet interfaces, typically eth0, eth1, etc.)

    2: Token Ring (rarely used today)

    6: IEEE 802.11 (Wireless interfaces, typically wlan0, wlan1, etc.)

    24: Loopback (Typically the lo interface)

    17: PPP (Point-to-Point Protocol, used in dial-up connections, VPN, etc.)

    77: VETH (Virtual Ethernet, used in containers, Docker interfaces, etc.)

Example Rules Using meta iiftype:

    Matching Ethernet Interfaces:

nft add rule ip filter input meta iiftype 1 accept

Matching Wireless Interfaces:

nft add rule ip filter input meta iiftype 6 accept

Negating Interface Types (e.g., not Ethernet):

nft add rule ip filter input meta iiftype != 1 drop

Using a Set of Interface Types:

nft add set inet filter if_types { type integer\; }
nft add element inet filter if_types { 1, 6, 24 }
nft add rule inet filter input meta iiftype @if_types accept

This matches packets received on Ethernet (1), Wireless (6), or Loopback (24) interfaces.

Range Matching (Multiple Types):

    nft add rule ip filter input meta iiftype >= 1 && meta iiftype <= 6 accept

    This matches packets received on interfaces with types between Ethernet (1) and Wireless (6).

Summary of Valid Keywords/Character Sets After meta iiftype:

    Exact Match: Specific numeric interface type (e.g., 1, 6, 24).

    Set of Interface Types: You can use a set of interface types (e.g., @set_name).

    Range Matching: Use >=, <= to match a range of interface types.

    Negation: Use != to exclude certain interface types.

These operators and sets allow you to build more specific or flexible rules based on the type of interface a packet is received on, making nftables very powerful for fine-grained control over network traffic.


## `meta skgid` ##

In **nftables**, the `meta skgid` expression is used to match the **socket group ID** of a packet. The socket group ID (`skgid`) refers to the group ID (GID) associated with the socket that originated the packet. This can be useful for filtering packets based on which group the socket belongs to (for example, to implement group-based access control).

### **Valid Keywords or Character Sets After `meta skgid`**

Here are the valid keywords or character sets that can be used after `meta skgid` in nftables rule statements:

### 1. **Exact Match (`==`)**

* You can use the **exact match operator (`==`)** to match a specific socket group ID.
* Example:

  ```bash
  nft add rule ip filter input meta skgid == 1001 accept
  ```

  This matches packets with the socket group ID equal to `1001`.

### 2. **Negation (`!=`)**

* The **negation operator (`!=`)** can be used to match packets with a **socket group ID not equal to a specific value**.
* Example:

  ```bash
  nft add rule ip filter input meta skgid != 1001 drop
  ```

  This drops packets with a socket group ID not equal to `1001`.

### 3. **Range Match (`>=`, `<=`)**

* You can use the **range match operators (`>=`, `<=`)** to match socket group IDs that fall within a specific range.
* Example:

  ```bash
  nft add rule ip filter input meta skgid >= 1000 && meta skgid <= 2000 accept
  ```

  This matches packets with a socket group ID in the range from `1000` to `2000`.

### 4. **Bitwise AND Operation (`&`)**

* You can use a **bitwise AND operation (`&`)** to match packets where the socket group ID has specific bits set.
* Example:

  ```bash
  nft add rule ip filter input meta skgid & 0xFF == 0x1 accept
  ```

  This matches packets whose socket group ID has the least significant byte set to `0x1`.

### 5. **Set of Socket Group IDs**

* You can define a **set of socket group IDs** and use it to match packets received with any of the IDs in the set.
* Example:

  ```bash
  nft add set inet filter skgids { type integer\; }
  nft add element inet filter skgids { 1001, 1002, 1003 }
  nft add rule inet filter input meta skgid @skgids accept
  ```

  This matches packets with a socket group ID of `1001`, `1002`, or `1003`.

### Summary of **Valid Keywords/Character Sets** After `meta skgid`:

1. **Exact Match**: Match a specific socket group ID using `==`.

   ```bash
   meta skgid == 1001
   ```

2. **Negation**: Exclude packets with a specific socket group ID using `!=`.

   ```bash
   meta skgid != 1001
   ```

3. **Range Matching**: Match socket group IDs within a specific range using `>=` and `<=`.

   ```bash
   meta skgid >= 1000 && meta skgid <= 2000
   ```

4. **Bitwise Matching**: Use the bitwise AND (`&`) operator to match specific bits of the socket group ID.

   ```bash
   meta skgid & 0xFF == 0x1
   ```

5. **Set of Socket Group IDs**: Use a set to match packets with any of a list of socket group IDs.

   ```bash
   meta skgid @set_name
   ```

### Example Rule Using `meta skgid`:

1. **Exact Match**:

   ```bash
   nft add rule ip filter input meta skgid == 1001 accept
   ```

2. **Negation**:

   ```bash
   nft add rule ip filter input meta skgid != 1001 drop
   ```

3. **Range Matching**:

   ```bash
   nft add rule ip filter input meta skgid >= 1000 && meta skgid <= 2000 accept
   ```

4. **Bitwise Match**:

   ```bash
   nft add rule ip filter input meta skgid & 0xFF == 0x1 accept
   ```

5. **Using Set**:

   ```bash
   nft add set inet filter skgids { type integer\; }
   nft add element inet filter skgids { 1001, 1002, 1003 }
   nft add rule inet filter input meta skgid @skgids accept
   ```

These are the valid options for matching against the **socket group ID** in nftables rules. They provide flexibility in filtering based on socket-level attributes, such as group-based access control or logging.

## `meta rtclassid`

In **nftables**, the `meta rtclassid` expression is used to match the **routing class ID** (or **RTClassID**) of a packet. The routing class ID is typically associated with the packet’s routing, and this field can be used for various purposes, including Quality of Service (QoS) or traffic management. The `rtclassid` field is part of the **routing domain** for the packet, and it can help control how packets are handled by the network stack.

### **Valid Keywords or Character Sets After `meta rtclassid`**

Here are the valid keywords or character sets that can be used after `meta rtclassid` in nftables rule statements:

### 1. **Exact Match (`==`)**

* You can use the **exact match operator (`==`)** to match packets that have a specific routing class ID.
* Example:

  ```bash
  nft add rule ip filter input meta rtclassid == 1 accept
  ```

  This matches packets with a **routing class ID** equal to `1`.

### 2. **Negation (`!=`)**

* You can use the **negation operator (`!=`)** to match packets that do **not** have a specific routing class ID.
* Example:

  ```bash
  nft add rule ip filter input meta rtclassid != 1 drop
  ```

  This drops packets that have a **routing class ID** not equal to `1`.

### 3. **Range Match (`>=`, `<=`)**

* You can use the **range match operators (`>=`, `<=`)** to match packets whose routing class ID falls within a specific range.
* Example:

  ```bash
  nft add rule ip filter input meta rtclassid >= 1 && meta rtclassid <= 100 accept
  ```

  This matches packets with a **routing class ID** between `1` and `100` (inclusive).

### 4. **Bitwise AND Operation (`&`)**

* You can use a **bitwise AND operation (`&`)** to match packets based on specific bits of the routing class ID.
* Example:

  ```bash
  nft add rule ip filter input meta rtclassid & 0xFF == 0x01 accept
  ```

  This matches packets where the least significant byte of the **routing class ID** is equal to `0x01`.

### 5. **Set of Routing Class IDs**

* You can define a **set of routing class IDs** and use it to match packets received with any of the IDs in the set.
* Example:

  ```bash
  nft add set inet filter rtclassids { type integer\; }
  nft add element inet filter rtclassids { 1, 2, 3 }
  nft add rule inet filter input meta rtclassid @rtclassids accept
  ```

  This matches packets with a **routing class ID** of `1`, `2`, or `3`.

### 6. **Wildcard (`any`)**

* You can use `any` to match **any routing class ID**, essentially making the rule apply to all packets regardless of the routing class.
* Example:

  ```bash
  nft add rule ip filter input meta rtclassid == any accept
  ```

  This matches packets with any **routing class ID**.

### **Summary of Valid Keywords/Character Sets After `meta rtclassid`**

1. **Exact Match**: Use `==` to match a specific routing class ID.

   ```bash
   meta rtclassid == 1
   ```

2. **Negation**: Use `!=` to exclude a specific routing class ID.

   ```bash
   meta rtclassid != 1
   ```

3. **Range Matching**: Use `>=` and `<=` to match a range of routing class IDs.

   ```bash
   meta rtclassid >= 1 && meta rtclassid <= 100
   ```

4. **Bitwise Matching**: Use `&` to match specific bits of the routing class ID.

   ```bash
   meta rtclassid & 0xFF == 0x01
   ```

5. **Set of Routing Class IDs**: Use a set of class IDs to match packets with any ID in the set.

   ```bash
   meta rtclassid @set_name
   ```

6. **Wildcard Match**: Use `any` to match any routing class ID.

   ```bash
   meta rtclassid == any
   ```

### Example Rules Using `meta rtclassid`

1. **Exact Match**:

   ```bash
   nft add rule ip filter input meta rtclassid == 1 accept
   ```

2. **Negation**:

   ```bash
   nft add rule ip filter input meta rtclassid != 1 drop
   ```

3. **Range Match**:

   ```bash
   nft add rule ip filter input meta rtclassid >= 1 && meta rtclassid <= 100 accept
   ```

4. **Bitwise Match**:

   ```bash
   nft add rule ip filter input meta rtclassid & 0xFF == 0x01 accept
   ```

5. **Using Set**:

   ```bash
   nft add set inet filter rtclassids { type integer\; }
   nft add element inet filter rtclassids { 1, 2, 3 }
   nft add rule inet filter input meta rtclassid @rtclassids accept
   ```

---

These are the valid ways you can use the **`meta rtclassid`** in nftables rules to match or filter packets based on their routing class ID. This can be especially useful in advanced network management scenarios such as traffic classification and QoS.

## `meta ibriport`/`meta obriport`

In nftables, the meta ibriport expression is used to match the input bridge port of a packet. The bridge port is relevant in situations where you have a bridge interface (typically used in network bridging or bridging with virtual interfaces). The input bridge port refers to the port of the bridge through which the packet arrived.

However, the meta ibriport field is not a commonly used field in regular nftables filtering rules, and it may not be widely supported or referenced. Its usage is more likely to be specific to bridging contexts in network configurations that utilize Linux bridging. Below are some potential values and ways to work with it based on common usage patterns.
Valid Keywords or Character Sets After meta ibriport

    Exact Match (Port Names or Numbers)

        You can use exact port names (if available), like those associated with a bridge port, for matching. For example, in a bridge setup, you may have ports like eth0, eth1, br0, or veth0.

        Example:

    nft add rule bridge filter input meta ibriport "eth0" accept

    This would match packets that come through the port eth0 of a bridge.

Negation (!=)

    You can use the negation operator (!=) to match packets not arriving via a specific bridge port.

    Example:

    nft add rule bridge filter input meta ibriport != "eth0" drop

    This drops packets that do not come through the bridge port eth0.

Set of Bridge Ports

    You can define a set of bridge ports and match packets received on any port in the set.

    Example:

    nft add set bridge filter bridge_ports { type ifname\; }
    nft add element bridge filter bridge_ports { "eth0", "eth1", "br0" }
    nft add rule bridge filter input meta ibriport @bridge_ports accept

    This matches packets arriving on any of the ports defined in the bridge_ports set (e.g., eth0, eth1, br0).

Wildcard (Any Port)

    You can use the wildcard value any to match packets that arrive on any bridge port.

    Example:

        nft add rule bridge filter input meta ibriport == any accept

        This matches packets arriving on any bridge port.

Summary of Valid Keywords/Character Sets After meta ibriport

    Exact Match: Match a specific bridge port by name or ID (e.g., "eth0").

meta ibriport "eth0"

Negation: Match packets not received on a specific bridge port using !=.

meta ibriport != "eth0"

Set of Bridge Ports: Use a set of bridge ports to match packets received on any port in the set.

meta ibriport @set_name

Wildcard: Use any to match packets arriving on any bridge port.

    meta ibriport == any

Example Rules Using meta ibriport

    Exact Match:

nft add rule bridge filter input meta ibriport "eth0" accept

Negation:

nft add rule bridge filter input meta ibriport != "eth0" drop

Set of Ports:

nft add set bridge filter bridge_ports { type ifname\; }
nft add element bridge filter bridge_ports { "eth0", "eth1", "br0" }
nft add rule bridge filter input meta ibriport @bridge_ports accept

Wildcard Match:

    nft add rule bridge filter input meta ibriport == any accept

Notes:

    Bridge Ports: The meta ibriport feature typically deals with bridge ports, which can be physical interfaces (eth0, eth1, etc.) or virtual interfaces (veth, br0, etc.) depending on the network setup. The values you use in the rules will depend on how the system is configured.

    Bridge Context: Make sure that the rules involving meta ibriport are used in the context of a bridge configuration (e.g., bridge table type in nftables).

These keywords and character sets allow you to filter packets based on the input bridge port and provide flexibility in how packets are processed within a network bridge.:

## `meta pkttype`

In nftables, the meta pkttype expression is used to match the packet type of a network packet. The packet type is an indicator of the type of packet, such as whether it is a broadcast, multicast, or unicast packet. These types are defined by the network layer and are useful for filtering or controlling traffic based on how the packet is addressed.
Valid Keywords or Character Sets After meta pkttype

Here are the valid keywords or character sets that can be used after meta pkttype in nftables rule statements:
1. Valid Packet Types

The valid packet types that can be matched using meta pkttype are predefined and include the following:

    unicast: Matches unicast packets, which are addressed to a specific single host.

    multicast: Matches multicast packets, which are addressed to a specific group of hosts (e.g., packets sent to 224.0.0.0/4).

    broadcast: Matches broadcast packets, which are addressed to all hosts on a network (e.g., packets sent to the broadcast address 255.255.255.255).

    any: Matches any packet type, without filtering by specific packet type.

2. Exact Match (==)

    You can use exact matching to match packets of a specific type.

    Example:

nft add rule ip filter input meta pkttype == unicast accept

This rule accepts unicast packets.

Similarly:

nft add rule ip filter input meta pkttype == multicast accept

Example for broadcast:

    nft add rule ip filter input meta pkttype == broadcast drop

3. Negation (!=)

    You can use the negation operator (!=) to match packets that do not have a specific packet type.

    Example:

    nft add rule ip filter input meta pkttype != multicast drop

    This drops non-multicast packets (i.e., it will drop unicast and broadcast packets).

4. Wildcard (any)

    You can use any to match any packet type, which is useful when you want the rule to apply to all packet types.

    Example:

    nft add rule ip filter input meta pkttype == any accept

    This accepts any packet type, which can be useful for general rules that don’t need to filter by packet type.

Summary of Valid Keywords/Character Sets After meta pkttype

    unicast: Matches unicast packets.

meta pkttype == unicast

multicast: Matches multicast packets.

meta pkttype == multicast

broadcast: Matches broadcast packets.

meta pkttype == broadcast

any: Matches any packet type (unicast, multicast, or broadcast).

meta pkttype == any

Negation (!=): Matches packets that do not have a specific packet type.

    meta pkttype != unicast

Example Rules Using meta pkttype

    Exact Match (Unicast):

nft add rule ip filter input meta pkttype == unicast accept

Exact Match (Multicast):

nft add rule ip filter input meta pkttype == multicast accept

Exact Match (Broadcast):

nft add rule ip filter input meta pkttype == broadcast drop

Negation (Non-Broadcast):

nft add rule ip filter input meta pkttype != broadcast drop

Wildcard Match (Any Packet Type):

    nft add rule ip filter input meta pkttype == any accept

Summary

    meta pkttype is a versatile way to match packets based on their type (unicast, multicast, or broadcast).

    Use it to filter packets that are directed to specific hosts, groups of hosts, or to all hosts in a network.

    Valid packet types: unicast, multicast, broadcast, and any.

    This expression is useful for scenarios like network optimization or controlling traffic based on its destination type.

These keywords and expressions give you the flexibility to manage traffic more effectively based on the type of communication being used (i.e., point-to-point, group communication, or broadcast).

## `meta cpu`

In **nftables**, the `meta cpu` expression is used to match packets based on the **CPU core** (or **CPU ID**) that processed the packet. This feature is especially useful in systems with **multiple CPU cores** and can be applied for traffic shaping, filtering, or monitoring based on the core that handled the packet. It’s part of **CPU affinity** settings, which allow for fine-grained control over how packets are handled by specific cores in multi-core systems.

### **Valid Keywords or Character Sets After `meta cpu`**

The `meta cpu` expression can be followed by several valid patterns to match CPU core IDs or specific conditions related to the CPU that processed the packet.

### 1. **Exact Match (CPU Core ID)**

* You can match **a specific CPU core** by using the **exact match operator (`==`)**.

* Example:

  ```bash
  nft add rule ip filter input meta cpu == 0 accept
  ```

  This rule matches packets that were processed by **CPU core 0**.

* Similarly:

  ```bash
  nft add rule ip filter input meta cpu == 1 drop
  ```

  This drops packets processed by **CPU core 1**.

### 2. **Negation (`!=`)**

* The **negation operator (`!=`)** can be used to exclude packets that were processed by a specific CPU core.
* Example:

  ```bash
  nft add rule ip filter input meta cpu != 0 drop
  ```

  This drops packets that were processed by **any CPU core except core 0**.

### 3. **Range Matching (`>=`, `<=`)**

* You can use **range match operators** to match packets processed by CPU cores within a certain range.
* Example:

  ```bash
  nft add rule ip filter input meta cpu >= 0 && meta cpu <= 3 accept
  ```

  This rule accepts packets processed by any of the first **4 CPU cores** (core 0 to core 3).

### 4. **Bitwise Operations (`&`)**

* You can use **bitwise AND operations (`&`)** to match packets based on specific bits of the CPU ID. This can be useful for matching packets processed by a subset of CPU cores that share common bits.
* Example:

  ```bash
  nft add rule ip filter input meta cpu & 0x1 == 0x1 accept
  ```

  This rule matches packets processed by **odd-numbered CPU cores** (since the least significant bit is `1`).

### 5. **Set of CPU Core IDs**

* You can define a **set of CPU core IDs** and match packets processed by any core in the set.
* Example:

  ```bash
  nft add set ip filter cpu_cores { type integer\; }
  nft add element ip filter cpu_cores { 0, 2, 4 }
  nft add rule ip filter input meta cpu @cpu_cores accept
  ```

  This rule matches packets processed by **CPU cores 0, 2, or 4**.

### 6. **Wildcard (`any`)**

* You can use `any` to match **any CPU core**, effectively making the rule apply to packets processed by **any available core**.
* Example:

  ```bash
  nft add rule ip filter input meta cpu == any accept
  ```

  This rule matches **any CPU core**, meaning packets processed by any core will be accepted.

### **Summary of Valid Keywords/Character Sets After `meta cpu`**

1. **Exact Match**: Match packets processed by a specific CPU core ID using `==`.

   ```bash
   meta cpu == 0
   ```

2. **Negation**: Exclude packets processed by a specific CPU core using `!=`.

   ```bash
   meta cpu != 0
   ```

3. **Range Match**: Match packets processed by CPU cores within a specified range using `>=` and `<=`.

   ```bash
   meta cpu >= 0 && meta cpu <= 3
   ```

4. **Bitwise Match**: Use `&` to match packets based on specific bits of the CPU core ID.

   ```bash
   meta cpu & 0x1 == 0x1
   ```

5. **Set of CPU Core IDs**: Match packets processed by any core in a defined set.

   ```bash
   meta cpu @set_name
   ```

6. **Wildcard**: Use `any` to match packets processed by any CPU core.

   ```bash
   meta cpu == any
   ```

### **Example Rules Using `meta cpu`**

1. **Exact Match (CPU Core 0)**:

   ```bash
   nft add rule ip filter input meta cpu == 0 accept
   ```

2. **Negation (Not CPU Core 0)**:

   ```bash
   nft add rule ip filter input meta cpu != 0 drop
   ```

3. **Range Match (CPU Cores 0 to 3)**:

   ```bash
   nft add rule ip filter input meta cpu >= 0 && meta cpu <= 3 accept
   ```

4. **Bitwise Match (Odd-numbered Cores)**:

   ```bash
   nft add rule ip filter input meta cpu & 0x1 == 0x1 accept
   ```

5. **Using Set of CPU Cores**:

   ```bash
   nft add set ip filter cpu_cores { type integer\; }
   nft add element ip filter cpu_cores { 0, 2, 4 }
   nft add rule ip filter input meta cpu @cpu_cores accept
   ```

6. **Wildcard (Any CPU Core)**:

   ```bash
   nft add rule ip filter input meta cpu == any accept
   ```

---

### **Summary**

The `meta cpu` expression in nftables is useful for filtering or controlling traffic based on which **CPU core** processed the packet. You can use it with various operators:

* **Exact match** (`==`) to specify a particular core.
* **Negation** (`!=`) to exclude specific cores.
* **Range matching** (`>=`, `<=`) for core ranges.
* **Bitwise operations** (`&`) for matching subsets of cores.
* **Set matching** (`@set_name`) to filter based on predefined sets of cores.
* **Wildcard** (`any`) to match packets processed by any core.

This allows for advanced traffic management in systems with multiple CPU cores, enabling optimization or specific handling based on CPU affinity.

## `meta time`


In nftables, the meta time expression is used to match the time when a packet was received, typically in seconds since the Unix epoch. This can be useful for filtering or handling packets based on specific times of day, week, or year.
Valid Keywords or Character Sets After meta time

The meta time expression in nftables allows for several kinds of time-based matching. Here's a breakdown of the possible valid keywords or character sets that can follow meta time:
1. Exact Match (Specific Time)

    You can match packets received at an exact timestamp. This is useful for filtering based on the exact time of receipt.

    Example:

    nft add rule ip filter input meta time == 1632767100 accept

    This matches packets that arrived at exactly 1632767100 seconds since the Unix epoch.

2. Range Match (>=, <=)

    You can match packets based on whether their timestamp falls within a range.

    Example:

    nft add rule ip filter input meta time >= 1632767100 && meta time <= 1632768100 accept

    This matches packets received between 1632767100 and 1632768100 seconds.

3. Negation (!=)

    You can exclude packets that were received at a specific time or within a specific range.

    Example:

    nft add rule ip filter input meta time != 1632767100 drop

    This drops packets that were received at exactly 1632767100 seconds.

4. Modulus Match (%)

    You can use the modulus operator (%) to match packets based on their timestamp, which is useful for periodic matching. For instance, you can match packets that are received at regular intervals.

    Example:

    nft add rule ip filter input meta time % 3600 == 0 accept

    This matches packets received on the hour, every hour (i.e., timestamps divisible by 3600).

5. Wildcard (any)

    You can use the wildcard value any to match any time.

    Example:

    nft add rule ip filter input meta time == any accept

    This rule accepts all packets regardless of the time they were received.

6. Time Range with date Format (Advanced Usage)

    In some cases, you might need to use more complex time matching, like matching based on the day of the week, month, or specific hours of the day. While this is not directly supported by meta time, some advanced nftables setups or external scripting can use date-specific checks in combination with meta time.

Summary of Valid Keywords/Character Sets After meta time

    Exact Match: Match packets received at a specific timestamp (seconds since Unix epoch).

meta time == 1632767100

Range Match: Match packets with timestamps within a range using >= and <=.

meta time >= 1632767100 && meta time <= 1632768100

Negation: Exclude packets received at a specific time using !=.

meta time != 1632767100

Modulus Match: Use the modulus operator (%) to match packets received at regular intervals.

meta time % 3600 == 0

Wildcard (any): Match packets at any time.

    meta time == any

Example Rules Using meta time

    Exact Match (Specific Time):

nft add rule ip filter input meta time == 1632767100 accept

Range Match (Time Interval):

nft add rule ip filter input meta time >= 1632767100 && meta time <= 1632768100 accept

Negation (Exclude a Specific Time):

nft add rule ip filter input meta time != 1632767100 drop

Modulus Match (Hourly Packets):

nft add rule ip filter input meta time % 3600 == 0 accept

Wildcard (Any Time):

    nft add rule ip filter input meta time == any accept

Considerations:

    The meta time expression uses seconds since the Unix epoch, which means it represents absolute time (e.g., 1632767100 refers to a specific point in time).

    While simple exact matches and range matches are common use cases, the modulus operator allows for periodic matching (e.g., matching every hour or every day).

    Time-based filtering can be helpful for rate-limiting or time-sensitive traffic, such as restricting access to a service during specific hours of the day or filtering out traffic based on specific events or intervals.

This makes meta time a useful tool for advanced traffic control based on the time of packet arrival.

## `meta day` ##

In **nftables**, the `meta day` expression is used to match the **day of the week** when a packet was received. It allows for filtering based on specific days, which can be useful for rules that are time-sensitive, such as blocking or allowing traffic on certain days of the week.

### **Valid Keywords or Character Sets After `meta day`**

The `meta day` expression matches the **day of the week**, which is represented as an **integer**. The days of the week are numbered as follows:

* **0** = Sunday
* **1** = Monday
* **2** = Tuesday
* **3** = Wednesday
* **4** = Thursday
* **5** = Friday
* **6** = Saturday

### **1. Exact Match (Specific Day)**

* You can match packets based on **exactly which day of the week** they were received.

* Example:

  ```bash
  nft add rule ip filter input meta day == 0 accept  # Matches packets received on Sunday
  ```

  This rule accepts packets that were received on **Sunday**.

* Similarly:

  ```bash
  nft add rule ip filter input meta day == 5 drop  # Matches packets received on Friday
  ```

  This rule drops packets that were received on **Friday**.

### **2. Negation (`!=`)**

* You can use the **negation operator (`!=`)** to exclude packets received on a specific day.
* Example:

  ```bash
  nft add rule ip filter input meta day != 0 accept  # Excludes packets received on Sunday
  ```

  This rule accepts packets received on **any day except Sunday**.

### **3. Range Matching (`>=`, `<=`)**

* You can use **range match operators** to match packets received on specific days or within a range of days.
* Example:

  ```bash
  nft add rule ip filter input meta day >= 1 && meta day <= 3 accept  # Matches Monday to Wednesday
  ```

  This rule accepts packets received on **Monday**, **Tuesday**, or **Wednesday**.

### **4. Modulus Match (`%`)**

* You can use the **modulus operator (`%`)** to match packets that arrive on specific days at regular intervals.
* Example:

  ```bash
  nft add rule ip filter input meta day % 2 == 0 accept  # Matches Sunday, Tuesday, Thursday, Saturday
  ```

  This rule matches packets that are received on **even days of the week** (Sunday, Tuesday, Thursday, Saturday).

### **5. Wildcard (`any`)**

* You can use the **wildcard value** `any` to match packets received on **any day** of the week.
* Example:

  ```bash
  nft add rule ip filter input meta day == any accept  # Matches packets on any day
  ```

  This rule accepts **all packets**, regardless of the day they are received.

### **Summary of Valid Keywords/Character Sets After `meta day`**

1. **Exact Match**: Match packets received on a specific day of the week using `==`.

   ```bash
   meta day == 0  # Sunday
   ```

2. **Negation**: Exclude packets received on a specific day using `!=`.

   ```bash
   meta day != 0  # Not Sunday
   ```

3. **Range Match**: Match packets received within a specific **range of days** using `>=` and `<=`.

   ```bash
   meta day >= 1 && meta day <= 3  # Monday to Wednesday
   ```

4. **Modulus Match**: Match packets based on the **remainder** when the day is divided by a number using `%`.

   ```bash
   meta day % 2 == 0  # Matches Sunday, Tuesday, Thursday, Saturday
   ```

5. **Wildcard (`any`)**: Match packets received on **any day** of the week.

   ```bash
   meta day == any  # Any day of the week
   ```

### **Example Rules Using `meta day`**

1. **Exact Match (Sunday)**:

   ```bash
   nft add rule ip filter input meta day == 0 accept  # Matches packets received on Sunday
   ```

2. **Negation (Not Friday)**:

   ```bash
   nft add rule ip filter input meta day != 5 drop  # Excludes packets received on Friday
   ```

3. **Range Match (Monday to Wednesday)**:

   ```bash
   nft add rule ip filter input meta day >= 1 && meta day <= 3 accept  # Matches packets received from Monday to Wednesday
   ```

4. **Modulus Match (Even Days)**:

   ```bash
   nft add rule ip filter input meta day % 2 == 0 accept  # Matches packets received on Sunday, Tuesday, Thursday, and Saturday
   ```

5. **Wildcard (Any Day)**:

   ```bash
   nft add rule ip filter input meta day == any accept  # Matches packets received on any day
   ```

---

### **Summary**

* The `meta day` expression matches the **day of the week** when a packet was received, using integer values from **0 (Sunday) to 6 (Saturday)**.
* You can use it with operators like `==`, `!=`, `>=`, `<=`, and `%` for various filtering scenarios.
* The `meta day` expression is useful for **time-based filtering**, allowing for network traffic control depending on the specific day of the week.

This feature is helpful for use cases like restricting access on weekends, allowing traffic only on certain days, or implementing **time-based security policies**.


## `meta hour` ##

In **nftables**, the `meta hour` expression allows you to match packets based on the **hour** of the day when they are received. This feature is particularly useful for **time-based filtering**, where you want to apply certain rules during specific hours of the day (e.g., restricting access during off-hours).

### **Valid Keywords or Character Sets After `meta hour`**

The `meta hour` expression matches the **hour of the day**, which is represented as an **integer** from **0** to **23** (where 0 represents midnight and 23 represents 11 PM).

### 1. **Exact Match (Specific Hour)**

* You can match packets received at a **specific hour** of the day.

* Example:

  ```bash
  nft add rule ip filter input meta hour == 9 accept  # Matches packets received at 9 AM
  ```

  This rule accepts packets received at **9 AM**.

* Similarly:

  ```bash
  nft add rule ip filter input meta hour == 18 drop  # Matches packets received at 6 PM
  ```

  This rule drops packets received at **6 PM**.

### 2. **Negation (`!=`)**

* You can use the **negation operator (`!=`)** to exclude packets received during a specific hour.
* Example:

  ```bash
  nft add rule ip filter input meta hour != 12 accept  # Excludes packets received at 12 PM
  ```

  This rule accepts packets received at **any hour except 12 PM**.

### 3. **Range Matching (`>=`, `<=`)**

* You can use **range match operators** to match packets received during a range of hours (e.g., between 9 AM and 5 PM).
* Example:

  ```bash
  nft add rule ip filter input meta hour >= 9 && meta hour <= 17 accept  # Matches packets between 9 AM and 5 PM
  ```

  This rule accepts packets received between **9 AM** and **5 PM**.

### 4. **Modulus Match (`%`)**

* You can use the **modulus operator (`%`)** to match packets received at regular intervals (e.g., every 2 hours).
* Example:

  ```bash
  nft add rule ip filter input meta hour % 2 == 0 accept  # Matches packets received on even hours (e.g., 0, 2, 4, ...)
  ```

  This rule matches packets received on **even-numbered hours** (e.g., 0, 2, 4, 6, etc.).

### 5. **Wildcard (`any`)**

* You can use the **wildcard value `any`** to match packets received during **any hour**.
* Example:

  ```bash
  nft add rule ip filter input meta hour == any accept  # Matches packets received at any hour
  ```

  This rule accepts **all packets**, regardless of the hour they were received.

### **Summary of Valid Keywords/Character Sets After `meta hour`**

1. **Exact Match**: Match packets received at a **specific hour** of the day using `==`.

   ```bash
   meta hour == 9  # 9 AM
   ```

2. **Negation**: Exclude packets received during a specific hour using `!=`.

   ```bash
   meta hour != 12  # Exclude 12 PM
   ```

3. **Range Match**: Match packets received during a range of hours using `>=` and `<=`.

   ```bash
   meta hour >= 9 && meta hour <= 17  # Between 9 AM and 5 PM
   ```

4. **Modulus Match**: Use `%` to match packets received at **regular intervals** of hours (e.g., every 2 hours).

   ```bash
   meta hour % 2 == 0  # Even hours (0, 2, 4, ...)
   ```

5. **Wildcard (`any`)**: Match packets received during **any hour**.

   ```bash
   meta hour == any  # Any hour of the day
   ```

### **Example Rules Using `meta hour`**

1. **Exact Match (9 AM)**:

   ```bash
   nft add rule ip filter input meta hour == 9 accept  # Matches packets received at 9 AM
   ```

2. **Negation (Not 12 PM)**:

   ```bash
   nft add rule ip filter input meta hour != 12 accept  # Excludes packets received at 12 PM
   ```

3. **Range Match (9 AM to 5 PM)**:

   ```bash
   nft add rule ip filter input meta hour >= 9 && meta hour <= 17 accept  # Matches packets between 9 AM and 5 PM
   ```

4. **Modulus Match (Every 2 Hours)**:

   ```bash
   nft add rule ip filter input meta hour % 2 == 0 accept  # Matches packets received on even hours (0, 2, 4, ...)
   ```

5. **Wildcard (Any Hour)**:

   ```bash
   nft add rule ip filter input meta hour == any accept  # Matches packets received at any hour
   ```

---

### **Summary**

The `meta hour` expression allows you to filter packets based on the **hour of the day** they were received. You can use it with various operators:

* **Exact match** (`==`) to match a specific hour.
* **Negation** (`!=`) to exclude a specific hour.
* **Range match** (`>=`, `<=`) to match a range of hours.
* **Modulus match** (`%`) to match packets at regular hourly intervals.
* **Wildcard** (`any`) to match packets received at any hour.

This functionality is particularly useful for implementing **time-based access control** or **traffic filtering** based on the hour of the day, enabling policies such as **restricting traffic during off-hours** or **allowing certain traffic only during business hours**.
## `meta notrack` ##

In nftables, the meta notrack expression is used to match packets that are not being tracked by the connection tracking system. This is useful for filtering packets that are part of new connections or unsolicited traffic, which are not part of any previously established connections tracked by the system.

When you use meta notrack, you are essentially instructing nftables to apply rules to packets that do not have an entry in the connection tracking table.
Valid Keywords or Character Sets After meta notrack

The meta notrack expression does not have a set of keywords or complex parameters that can follow it, since its purpose is simply to match packets that are not being tracked. It is a binary flag used in connection tracking and doesn't require additional arguments or keywords.
Usage of meta notrack

Here are the common scenarios where meta notrack is used:

    Match Untracked Packets:

        meta notrack matches packets that are not being tracked by the connection tracking system.

        Example:

    nft add rule ip filter input meta notrack accept  # Accepts packets that are not tracked

Use with other Filters:

    You can combine meta notrack with other conditions (e.g., IP, ports, etc.) to apply rules to specific untracked packets.

    Example:

    nft add rule ip filter input meta notrack ip daddr 192.168.1.1 accept  # Accepts untracked packets destined for 192.168.1.1

Drop Untracked Packets:

    You can use meta notrack to drop untracked packets, especially when dealing with unsolicited or new traffic that is not part of an established connection.

    Example:

        nft add rule ip filter input meta notrack drop  # Drops untracked packets

Summary of How meta notrack Works

    The meta notrack expression does not require any additional keywords or character sets. It is a simple binary match used to identify packets that are not being tracked by the connection tracking system.

    It is typically used with accept or drop actions in firewall rules to handle new or unsolicited packets that do not belong to any known connection.

Examples of meta notrack Usage:

    Accept Untracked Packets:

nft add rule ip filter input meta notrack accept

Drop Untracked Packets:

nft add rule ip filter input meta notrack drop

Accept Untracked Packets with Specific Destination IP:

nft add rule ip filter input meta notrack ip daddr 192.168.1.1 accept

Block Untracked Packets on a Specific Port:

    nft add rule ip filter input meta notrack tcp dport 80 drop

In Summary:

    meta notrack is a simple, binary expression in nftables.

    There are no specific keywords or character sets that can come after meta notrack; it is used to filter packets that are not tracked by the connection tracking system.

    Common use cases include accepting or dropping untracked packets, especially for new connections or unsolicited traffic.

## `meta flow` ##

In **nftables**, the `meta flow` expression is used to match **flow identifiers** associated with the packet's flow in the connection tracking system. The flow ID is a unique identifier assigned to a network flow, which is essentially a set of packets that share common characteristics such as source and destination IP addresses, ports, and protocol.

When using the `meta flow` statement, you are working with the **flow label** and can apply it to filter based on the flow's properties. This is useful in scenarios where you need to identify or manipulate packets that belong to the same network flow.

### **Valid Keywords or Character Sets After `meta flow`**

Here’s a breakdown of the types of matches and keywords that can follow the `meta flow` expression:

### 1. **Exact Match (Flow ID)**

* You can match packets based on a **specific flow ID**. The flow ID is an integer that identifies a flow.
* Example:

  ```bash
  nft add rule ip filter input meta flow == 12345 accept
  ```

  This rule accepts packets that belong to **flow ID 12345**.

### 2. **Range Matching (`>=`, `<=`)**

* You can match packets whose flow ID is within a **range** of flow IDs.
* Example:

  ```bash
  nft add rule ip filter input meta flow >= 1000 && meta flow <= 2000 accept
  ```

  This rule matches packets whose **flow ID** is between **1000** and **2000**.

### 3. **Negation (`!=`)**

* You can **exclude** packets belonging to a **specific flow ID** by using the negation operator (`!=`).
* Example:

  ```bash
  nft add rule ip filter input meta flow != 12345 drop
  ```

  This rule drops packets **not belonging to flow ID 12345**.

### 4. **Modulus Match (`%`)**

* You can use the **modulus operator (`%`)** to match packets based on a regular interval of flow IDs. This is useful for periodic matching of flows.
* Example:

  ```bash
  nft add rule ip filter input meta flow % 2 == 0 accept
  ```

  This rule matches packets whose flow ID is **even** (i.e., divisible by **2**).

### 5. **Wildcard (`any`)**

* You can use the **wildcard value** `any` to match packets from **any flow ID**. This would allow all packets, regardless of the flow ID, to be processed.
* Example:

  ```bash
  nft add rule ip filter input meta flow == any accept
  ```

  This rule accepts **all packets**, regardless of their flow ID.

### **Summary of Valid Keywords/Character Sets After `meta flow`**

1. **Exact Match**: Match packets with a **specific flow ID**.

   ```bash
   meta flow == 12345
   ```

2. **Range Match**: Match packets with a flow ID within a specific **range**.

   ```bash
   meta flow >= 1000 && meta flow <= 2000
   ```

3. **Negation**: Exclude packets with a **specific flow ID** using `!=`.

   ```bash
   meta flow != 12345
   ```

4. **Modulus Match**: Match packets based on the **modulus** of the flow ID (useful for regular intervals).

   ```bash
   meta flow % 2 == 0
   ```

5. **Wildcard (`any`)**: Match packets from **any flow ID**.

   ```bash
   meta flow == any
   ```

### **Example Rules Using `meta flow`**

1. **Exact Match (Flow ID 12345)**:

   ```bash
   nft add rule ip filter input meta flow == 12345 accept  # Matches packets with flow ID 12345
   ```

2. **Range Match (Flow IDs between 1000 and 2000)**:

   ```bash
   nft add rule ip filter input meta flow >= 1000 && meta flow <= 2000 accept  # Matches flow IDs between 1000 and 2000
   ```

3. **Negation (Exclude Flow ID 12345)**:

   ```bash
   nft add rule ip filter input meta flow != 12345 drop  # Drops packets not belonging to flow ID 12345
   ```

4. **Modulus Match (Even Flow IDs)**:

   ```bash
   nft add rule ip filter input meta flow % 2 == 0 accept  # Matches packets with even flow IDs
   ```

5. **Wildcard (Any Flow ID)**:

   ```bash
   nft add rule ip filter input meta flow == any accept  # Matches packets with any flow ID
   ```

---

### **Summary**

* The `meta flow` expression in **nftables** is used to filter packets based on their **flow ID**.
* It can be used with operators like:

  * `==` (exact match) to match a specific flow ID.
  * `!=` (negation) to exclude a specific flow ID.
  * `>=` and `<=` for range matching of flow IDs.
  * `%` for periodic matching (modulus match) of flow IDs.
  * `any` to match any flow ID.

This functionality is useful for filtering traffic based on specific **network flows**, which can be helpful in scenarios like **traffic analysis**, **flow-based filtering**, or **advanced connection tracking**.


# Qualified Meta Keys

## `meta length` ##

In **nftables**, the `meta length` expression is used to match packets based on the **length of the packet**, specifically the size of the packet's payload (excluding the headers). This can be useful for scenarios where you want to apply specific filtering rules based on the size of the packet (e.g., filtering large packets, dropping small packets, etc.).

### **Valid Keywords or Character Sets After `meta length`**

The `meta length` expression works by comparing the **packet length** to a given value or range. You can use several types of operators to filter packets based on their length.

Here are the valid operators and expressions you can use after `meta length`:

### 1. **Exact Match (`==`)**

* You can match packets with a **specific length**.
* Example:

  ```bash
  nft add rule ip filter input meta length == 128 accept  # Matches packets with exactly 128 bytes of payload
  ```

### 2. **Range Matching (`>=`, `<=`)**

* You can match packets where the **length** is within a specific **range**.
* Example:

  ```bash
  nft add rule ip filter input meta length >= 100 && meta length <= 500 accept  # Matches packets with length between 100 and 500 bytes
  ```

### 3. **Negation (`!=`)**

* You can **exclude** packets with a **specific length** using `!=`.
* Example:

  ```bash
  nft add rule ip filter input meta length != 150 drop  # Drops packets that are not 150 bytes in length
  ```

### 4. **Modulus Match (`%`)**

* You can use the **modulus operator (`%`)** to match packets whose length follows a regular interval (e.g., matching every 50 bytes).
* Example:

  ```bash
  nft add rule ip filter input meta length % 50 == 0 accept  # Matches packets whose length is divisible by 50
  ```

### 5. **Wildcard (`any`)**

* You can use `any` to match packets of **any length**. This allows all packets, regardless of size, to be processed by the rule.
* Example:

  ```bash
  nft add rule ip filter input meta length == any accept  # Matches packets of any length
  ```

### **Summary of Valid Keywords/Character Sets After `meta length`**

1. **Exact Match**: Match packets with a **specific length** using `==`.

   ```bash
   meta length == 128  # Exact match for packets with 128 bytes length
   ```

2. **Range Match**: Match packets whose length is within a **specific range** using `>=` and `<=`.

   ```bash
   meta length >= 100 && meta length <= 500  # Packets between 100 and 500 bytes
   ```

3. **Negation**: Exclude packets with a **specific length** using `!=`.

   ```bash
   meta length != 150  # Exclude packets that are 150 bytes in length
   ```

4. **Modulus Match**: Use `%` to match packets whose length is a multiple of a number.

   ```bash
   meta length % 50 == 0  # Matches packets whose length is divisible by 50
   ```

5. **Wildcard (`any`)**: Match packets of **any length** using `any`.

   ```bash
   meta length == any  # Matches packets of any length
   ```

### **Example Rules Using `meta length`**

1. **Exact Match (128 bytes)**:

   ```bash
   nft add rule ip filter input meta length == 128 accept  # Matches packets with exactly 128 bytes
   ```

2. **Range Match (100 to 500 bytes)**:

   ```bash
   nft add rule ip filter input meta length >= 100 && meta length <= 500 accept  # Matches packets between 100 and 500 bytes
   ```

3. **Negation (Not 150 bytes)**:

   ```bash
   nft add rule ip filter input meta length != 150 drop  # Drops packets that are not 150 bytes in length
   ```

4. **Modulus Match (Every 50 bytes)**:

   ```bash
   nft add rule ip filter input meta length % 50 == 0 accept  # Matches packets whose length is divisible by 50
   ```

5. **Wildcard (Any Length)**:

   ```bash
   nft add rule ip filter input meta length == any accept  # Matches packets of any length
   ```

---

### **Summary**

The `meta length` expression allows you to filter packets based on their **length**, with several types of operators available:

* **Exact match** (`==`) to match a specific packet length.
* **Range match** (`>=`, `<=`) to match packets within a range of lengths.
* **Negation** (`!=`) to exclude packets of a specific length.
* **Modulus match** (`%`) to match packets at regular intervals of length.
* **Wildcard** (`any`) to match packets of any length.

This is particularly useful in scenarios where you want to **filter based on packet size**, such as allowing or dropping **small packets**, **large packets**, or **packets of certain sizes** for specific network security purposes.


## `meta protocol` ##

In nftables, the meta protocol expression is used to match packets based on the protocol type specified in the IP header. This can be useful for applying rules to traffic of a specific protocol, such as TCP, UDP, ICMP, etc.
Valid Keywords or Character Sets After meta protocol

The meta protocol expression compares the protocol field from the IP header to a specific protocol value. The protocols are represented by numeric values or can be referred to by their protocol names.
Common Protocols and Their Numeric Values

Here are some common protocols and their corresponding values that can be used with meta protocol:

    ICMP (Internet Control Message Protocol):

        Protocol number: 1

        Used for ping requests, error messages, etc.

    TCP (Transmission Control Protocol):

        Protocol number: 6

        Used for reliable communication between hosts.

    UDP (User Datagram Protocol):

        Protocol number: 17

        Used for connectionless communication.

    GRE (Generic Routing Encapsulation):

        Protocol number: 47

        Used for tunneling and routing.

    ESP (Encapsulating Security Payload):

        Protocol number: 50

        Used for VPNs and IPsec.

    AH (Authentication Header):

        Protocol number: 51

        Used for IPsec authentication.

    IPIP (IP-in-IP Encapsulation):

        Protocol number: 4

        Used for tunneling.

    SCTP (Stream Control Transmission Protocol):

        Protocol number: 132

        Used for multi-homed connections.

    PPTP (Point-to-Point Tunneling Protocol):

        Protocol number: 115

        Used for VPN connections.

    OSPF (Open Shortest Path First):

    Protocol number: 89

    Used in routing protocols.

    Raw IP (Raw packets):

    Protocol number: 255

    Represents raw IP packets without higher-level protocol encapsulation.

Syntax and Example Usage

Here are the valid ways to use meta protocol:
1. Exact Match (Protocol Name or Number)

You can specify the protocol using its numeric value or its name (as a keyword). Here are some examples:

    ICMP (Protocol 1):

nft add rule ip filter input meta protocol == 1 accept  # Matches ICMP (e.g., ping)

or using the protocol name:

nft add rule ip filter input meta protocol == icmp accept  # Matches ICMP

TCP (Protocol 6):

nft add rule ip filter input meta protocol == 6 accept  # Matches TCP

or using the protocol name:

nft add rule ip filter input meta protocol == tcp accept  # Matches TCP

UDP (Protocol 17):

nft add rule ip filter input meta protocol == 17 accept  # Matches UDP

or using the protocol name:

nft add rule ip filter input meta protocol == udp accept  # Matches UDP

GRE (Protocol 47):

    nft add rule ip filter input meta protocol == 47 accept  # Matches GRE

2. Negation (!=)

You can use the negation operator (!=) to exclude packets with a specific protocol:

    Exclude ICMP:

    nft add rule ip filter input meta protocol != 1 drop  # Drops packets that are not ICMP

3. Range Matching (>=, <=)

While meta protocol typically works with exact protocol matches, you can use range operators (>=, <=) to apply rules to multiple protocol numbers if the protocol numbers are contiguous. This can be useful for matching multiple protocols with similar numeric ranges, though it's not as commonly used in practice.

    Example (this will match protocols between 6 and 17, inclusive):

    nft add rule ip filter input meta protocol >= 6 && meta protocol <= 17 accept  # Matches TCP, UDP, and similar protocols

4. Wildcard (any)

You can use any to match any protocol in the protocol field:

    Match Any Protocol:

    nft add rule ip filter input meta protocol == any accept  # Matches any protocol

Summary of Valid Keywords/Character Sets After meta protocol

    Exact Match:

        You can match a specific protocol by using its numeric value or name.

        Examples:

            meta protocol == 1 or meta protocol == icmp (matches ICMP).

            meta protocol == 6 or meta protocol == tcp (matches TCP).

            meta protocol == 17 or meta protocol == udp (matches UDP).

    Negation (!=):

        Exclude specific protocols.

        Example: meta protocol != 1 (exclude ICMP).

    Range Match (>=, <=):

        Match protocols within a specific range (e.g., meta protocol >= 6 && meta protocol <= 17 for TCP and UDP).

    Wildcard (any):

        Match any protocol.

        Example: meta protocol == any.

Example Rules Using meta protocol

    Allow ICMP (Ping):

nft add rule ip filter input meta protocol == icmp accept  # Accepts ICMP (e.g., ping requests)

Drop Non-TCP Packets:

nft add rule ip filter input meta protocol != tcp drop  # Drops packets that are not TCP

Accept UDP Packets Only:

nft add rule ip filter input meta protocol == udp accept  # Accepts only UDP packets

Accept Packets for TCP or UDP:

nft add rule ip filter input meta protocol == tcp accept  # Accepts TCP packets
nft add rule ip filter input meta protocol == udp accept  # Accepts UDP packets

Match Any Protocol:

    nft add rule ip filter input meta protocol == any accept  # Matches packets of any protocol

Summary

The meta protocol expression is used to match packets based on the protocol field in the IP header. You can match protocols using:

    Exact match with protocol names (e.g., icmp, tcp, udp) or numeric values (e.g., 1, 6, 17).

    Negation (!=) to exclude a specific protocol.

    Range match (>=, <=) to match protocols within a specific numeric range.

    Wildcard (any) to match any protocol.

This allows for precise control over filtering traffic based on the type of protocol being used in the packet, which is crucial for implementing protocol-specific rules or broad network traffic management.

## `meta priority` ##

In nftables, the meta priority expression is used to match packets based on their priority value. The priority is typically associated with network traffic to indicate its relative importance, especially in the context of Quality of Service (QoS) or traffic classification.

The priority is typically used in conjunction with diffserv (Differentiated Services) and traffic management to distinguish between packets with different levels of importance or urgency.
Valid Keywords or Character Sets After meta priority

The meta priority expression works by comparing the priority field in the packet’s header to a given value. This priority value is typically a 16-bit integer representing a packet's priority in the network.
Valid Operators After meta priority

Here are the types of operations you can use after meta priority:
1. Exact Match (==)

    You can match a specific priority value.

    Example:

    nft add rule ip filter input meta priority == 5 accept  # Matches packets with priority 5

2. Range Match (>=, <=)

    You can match packets with priority values within a specific range.

    Example:

    nft add rule ip filter input meta priority >= 3 && meta priority <= 7 accept  # Matches priorities between 3 and 7

3. Negation (!=)

    You can exclude packets with a specific priority value using !=.

    Example:

    nft add rule ip filter input meta priority != 10 drop  # Drops packets that do not have priority 10

4. Modulus Match (%)

    You can match packets with a priority that is divisible by a certain value (i.e., modulus matching).

    Example:

    nft add rule ip filter input meta priority % 2 == 0 accept  # Matches packets with an even priority value

5. Wildcard (any)

    You can use any to match packets with any priority value.

    Example:

    nft add rule ip filter input meta priority == any accept  # Matches packets with any priority

Summary of Valid Keywords/Character Sets After meta priority

    Exact Match: Match a packet with a specific priority value using ==.

        Example: meta priority == 5

    Range Match: Match packets with a priority within a range using >= and <=.

        Example: meta priority >= 3 && meta priority <= 7

    Negation: Exclude packets with a specific priority using !=.

        Example: meta priority != 10

    Modulus Match: Use the modulus operator (%) to match priority values that are divisible by a given number.

        Example: meta priority % 2 == 0 (matches even priority values).

    Wildcard (any): Match packets with any priority using any.

        Example: meta priority == any

Example Rules Using meta priority

    Allow Packets with Priority 5:

nft add rule ip filter input meta priority == 5 accept  # Accepts packets with priority 5

Drop Packets with Priority Less Than 10:

nft add rule ip filter input meta priority < 10 drop  # Drops packets with priority less than 10

Accept Packets with Priority Between 3 and 7:

nft add rule ip filter input meta priority >= 3 && meta priority <= 7 accept  # Matches priority between 3 and 7

Drop Packets with Odd Priorities:

nft add rule ip filter input meta priority % 2 != 0 drop  # Drops packets with odd priorities

Match Any Priority:

    nft add rule ip filter input meta priority == any accept  # Accepts packets with any priority

Summary

The meta priority expression allows you to filter packets based on their priority value. You can use the following operators:

    Exact match (==) to match a specific priority.

    Range match (>=, <=) to match priorities within a given range.

    Negation (!=) to exclude specific priority values.

    Modulus match (%) to match packets with a priority divisible by a given number.

    Wildcard (any) to match packets with any priority.

This expression is typically used in network traffic management scenarios to filter or prioritize traffic based on its priority level.

## `meta random` ##

In nftables, the meta random expression is used to match packets based on random sampling or to apply probabilistic filtering to network traffic. This is often used in scenarios where you want to drop or accept a fraction of packets randomly, such as in load balancing, traffic shaping, or probabilistic sampling for monitoring purposes.

The meta random expression doesn't match a specific value in the packet itself but allows you to filter packets based on a random decision governed by a defined probability.
Valid Keywords or Character Sets After meta random

The syntax and behavior of meta random generally works by associating a probability with each packet, often expressed as a fraction or a range. It is commonly used with operators like <=, ==, or >= to compare the random value generated for the packet with a defined threshold.
Common Use of meta random

    Probabilistic Matching Using <, <=, ==, >=:

        The meta random value is often compared to a threshold, where the packet is accepted or dropped based on the result of this comparison.

        The packet has a random value assigned, typically in the range of [0, 1], which represents a probabilistic decision.

1. Random Matching (<=, >=)

    You can match packets that fall below or above a random threshold.

    Example:

    nft add rule ip filter input meta random <= 0.1 accept  # Accepts 10% of packets randomly

    Here, 10% of the packets will be accepted randomly, as the random value is compared to 0.1.

2. Exact Match (==)

    You can specify an exact value for random matching (although this is less common since meta random is usually used with a probabilistic threshold).

    Example:

    nft add rule ip filter input meta random == 0.5 drop  # Drops packets with a random value exactly equal to 0.5

3. Negation (!=)

    You can exclude packets with a specific random value or exclude packets based on a threshold.

    Example:

    nft add rule ip filter input meta random != 0.5 drop  # Drops packets that do not have a random value equal to 0.5

4. Range Matching (>=, <=)

    You can match packets based on a range of random values. This can be useful if you want to accept or drop packets based on a range of random values rather than a single threshold.

    Example:

    nft add rule ip filter input meta random >= 0.2 && meta random <= 0.8 accept  # Accepts packets with a random value between 0.2 and 0.8

5. Wildcard (any)

    Wildcard matching allows matching any random value. While this is generally less useful in practice, it can be used to match all packets when combined with other conditions.

    Example:

    nft add rule ip filter input meta random == any accept  # Matches all packets (accepting them)

Summary of Valid Keywords/Character Sets After meta random

    Threshold Comparison (<=, >=): Compare the random value with a probabilistic threshold.

        Example: meta random <= 0.1 (accepts 10% of packets randomly).

    Exact Match (==): Match packets with an exact random value (usually less common).

        Example: meta random == 0.5 (matches packets with a random value equal to 0.5).

    Negation (!=): Exclude packets with a specific random value.

        Example: meta random != 0.5 (excludes packets with a random value equal to 0.5).

    Range Match (>=, <=): Match packets with a random value within a range.

        Example: meta random >= 0.2 && meta random <= 0.8 (matches packets with a random value between 0.2 and 0.8).

    Wildcard (any): Matches any random value (useful when applying rules to all packets).

        Example: meta random == any (matches packets with any random value).

Example Rules Using meta random

    Accept 10% of Packets Randomly:

nft add rule ip filter input meta random <= 0.1 accept  # Accepts 10% of packets randomly

Drop 50% of Packets Randomly:

nft add rule ip filter input meta random <= 0.5 drop  # Drops 50% of packets randomly

Accept Packets with Random Value Between 0.2 and 0.8:

nft add rule ip filter input meta random >= 0.2 && meta random <= 0.8 accept  # Accepts packets with random value between 0.2 and 0.8

Drop Packets with Random Value Exactly Equal to 0.5:

nft add rule ip filter input meta random == 0.5 drop  # Drops packets with random value exactly equal to 0.5

Match All Packets (Any Random Value):

    nft add rule ip filter input meta random == any accept  # Matches all packets with any random value

Summary

The meta random expression in nftables allows you to apply probabilistic filtering to packets by comparing a random value associated with each packet. Valid comparisons include:

    Threshold comparison using <=, >= (e.g., meta random <= 0.1 for 10% acceptance).

    Exact match using == for specific random values (less common).

    Negation using != to exclude specific random values.

    Range matching using >= and <= to match random values within a range.

    Wildcard matching with any to match all packets.

This is useful in scenarios like traffic shaping, load balancing, and probabilistic sampling.

## `meta secmark` ##

ChatGPT said:

In nftables, the meta secmark expression is used to match packets based on their security mark (secmark). This is often used in security policy enforcement, particularly in contexts such as SELinux or AppArmor, where a security mark can be applied to packets to indicate their security classification.

The secmark is a 32-bit value attached to the packet, which can be used for filtering, policy enforcement, and managing network traffic according to security levels.
Valid Keywords or Character Sets After meta secmark

After meta secmark, you can use various comparison operators to filter based on the security mark applied to the packet. The value of the secmark is a 32-bit unsigned integer.

Here are the valid operators and how they can be applied:
1. Exact Match (==)

    You can match packets with a specific security mark value.

    Example:

    nft add rule ip filter input meta secmark == 100 accept  # Matches packets with secmark equal to 100

2. Negation (!=)

    You can exclude packets with a specific security mark value.

    Example:

    nft add rule ip filter input meta secmark != 100 drop  # Drops packets where secmark is not 100

3. Range Match (>=, <=)

    You can match packets whose security mark is within a certain range. This can be useful for classifying packets into security levels or categories.

    Example:

    nft add rule ip filter input meta secmark >= 100 && meta secmark <= 200 accept  # Accepts packets with secmark between 100 and 200

4. Wildcard (any)

    The any keyword can be used as a wildcard to match any security mark.

    Example:

    nft add rule ip filter input meta secmark == any accept  # Accepts all packets with any secmark

Summary of Valid Keywords/Character Sets After meta secmark

    Exact Match (==): Match packets with a specific security mark value.

        Example: meta secmark == 100

    Negation (!=): Exclude packets with a specific security mark value.

        Example: meta secmark != 100

    Range Match (>=, <=): Match packets with a security mark within a certain range.

        Example: meta secmark >= 100 && meta secmark <= 200

    Wildcard (any): Match any security mark.

        Example: meta secmark == any

Example Rules Using meta secmark

    Accept Packets with Specific Security Mark:

nft add rule ip filter input meta secmark == 100 accept  # Accepts packets with secmark 100

Drop Packets with a Different Security Mark:

nft add rule ip filter input meta secmark != 100 drop  # Drops packets with any secmark other than 100

Accept Packets with Security Mark Between 100 and 200:

nft add rule ip filter input meta secmark >= 100 && meta secmark <= 200 accept  # Accepts secmark in the range [100, 200]

Match Any Security Mark:

    nft add rule ip filter input meta secmark == any accept  # Matches packets with any security mark

Summary

The meta secmark expression is used to filter packets based on their security mark value. The valid operators include:

    Exact match (==) to match a specific secmark.

    Negation (!=) to exclude packets with a specific secmark.

    Range match (>=, <=) to match packets with a secmark within a specified range.

    Wildcard (any) to match packets with any secmark.

This feature is useful in contexts where network traffic is classified based on security labels, such as with SELinux or other security-enhanced Linux distributions.
