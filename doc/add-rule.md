Summary Table

Details on usage of 'add rule', 'rule', and implied 'add rule'.

| Form                           | Context | Common? | Why                                 |
|:-------------------------------| ---- | ---- |-------------------------------------|
| `add rule ip filter input ...` | CLI / scripts | ✅ Very common | Imperative (actually adds the rule) |
| `rule ip filter input ...`     | Inside tables, or nft output | ⚠️ Rare	 | Declarative object form, verbose    
| `ip protocol icmp drop`        | Inside chain block | ✅ Common | Clean declarative syntax            
| `add ip filter input ...`        | ❌ Invalid | ❌ | Grammar disallows it                