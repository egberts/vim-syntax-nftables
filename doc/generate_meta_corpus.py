#!/usr/bin/env python3

import os

# Output root directory
ROOT_DIR = "nft-tests/corpus/meta"

# Define meta keywords and their test styles
META_KEYWORDS = {
    "iifname": {
        "type": "device",
        "values": ['"eth0"', 'eth0']
    },
    "protocol": {
        "type": "protocol",
        "values": ['"802.1q"', "802_1q"]
    },
    "flow": {
        "type": "flow",
        "values": [
            "flow at eth0",
            "flow add at eth1",
            "flow offload at \"br-lan\""
        ]
    },
    "mark": {
        "type": "integer",
        "values": ["1234", "0x1", "any"]
    },
    "length": {
        "type": "range",
        "values": ["1200", "0-1500"]
    },
    "skuid": {
        "type": "integer",
        "values": ["1000", "any"]
    },
    # Add more as needed...
}

HEADER = """table ip filter {
  chain input {
    type filter hook input priority 0;
    policy accept;
"""

FOOTER = """  }
}
"""

def sanitize_filename(keyword):
    return keyword.replace(" ", "_").replace('"', '').replace('.', '_')

def generate_test_block(keyword, values, purpose):
    lines = [f"    meta {keyword} {v} accept;" for v in values]
    lines.append(f"    # purpose: test variations of {keyword} ({purpose})")
    return "\n".join(lines)

def main():
    os.makedirs(ROOT_DIR, exist_ok=True)

    for keyword, info in META_KEYWORDS.items():
        fname = sanitize_filename(keyword)
        path = os.path.join(ROOT_DIR, f"meta_{fname}.nft")
        with open(path, "w") as f:
            f.write(HEADER)
            f.write(generate_test_block(keyword, info["values"], info["type"]))
            f.write("\n")
            f.write(FOOTER)

    print(f"✅ Generated corpus for {len(META_KEYWORDS)} meta keywords in {ROOT_DIR}")

if __name__ == "__main__":
    main()

