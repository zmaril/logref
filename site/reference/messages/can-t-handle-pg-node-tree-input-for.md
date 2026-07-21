---
message: "can't handle pg_node_tree input for %s.%s"
slug: can-t-handle-pg-node-tree-input-for
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:739"
reproduced: false
---

# `can't handle pg_node_tree input for %s.%s`

## What it means

Input for a `pg_node_tree` value was supplied in a context that cannot accept it. The placeholders name the catalog and column. The `pg_node_tree` type stores serialized internal trees and does not accept arbitrary user input. It is an internal guard.

## When it happens

It is a can't-happen check reached when something attempts to write a `pg_node_tree` column directly rather than through the catalog machinery.

## How to fix

There is no user action for normal SQL. `pg_node_tree` columns are maintained internally; do not write them directly. If an extension or tool triggered it, report it to that tool's author.

## Example

*Illustrative* — direct pg_node_tree input.

```text
ERROR:  can't handle pg_node_tree input for pg_index.indexprs
```

## Related

- [byval datum but length](./byval-datum-but-length.md)
- [cache entry already complete](./cache-entry-already-complete.md)
