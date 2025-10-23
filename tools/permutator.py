#!/usr/bin/env python3
import itertools

# Component lists in specified order
ip_fields = [
    'version', 'hdrlength', 'dscp', 'ecn', 'length', 'id',
    'frag-off', 'ttl', 'protocol', 'checksum', 'saddr', 'daddr'
]

operators = [
    '>', '<', '>=', '<=', '==', '!=', 'not in', 'in', 'not', 'lt', 'le', 'eq', 'ge', 'gt', 'ne'
]

rhs_values = [
    '0',  # lowest integer
    '4294967295',  # highest integer (UINT32_MAX)
    '0-4294967295',  # integer range
    '0x0',  # lowest hex
    '0xffffffff',  # highest hex
    'any',
    'missing',
    'exists',
    'none',
    '"eth0"',
    '"br*"',
    '127.0.0.1',
    '127.0.0.1-127.0.0.254',
    '@setname',  # setname
    '{ 1, 2, 3 }',  # inline set, integer
    '{ 1-4, 6-7 }',  # inline set, integer range
    '{ 127.0.0.1 }',  # inline set, IP
    '{ 127.0.0.1-127.0.0.254 }',  # inline set, IP range
    '{ 127.0.0.1/24 }',  # inline set with CIDR prefix
    '$IP_HDR_LENGTH'  # variable name
]


def generate_permutations():
    """Generate all permutations in 4-level nested iteration order"""
    count = 0
    total = len(ip_fields) * len(operators) * len(rhs_values)

    print("ip <field> <operator> <rhs>")
    print("-" * 50)

    for field in ip_fields:
        for op in operators:
            for rhs in rhs_values:
                expr = f"ip {field} {op} {rhs}"
                print(expr)
                count += 1

    print(f"\nTotal permutations: {count}/{total}")


if __name__ == "__main__":
    generate_permutations()