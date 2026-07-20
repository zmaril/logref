---
message: "failed to find requested node %d in SPGiST inner tuple"
slug: failed-to-find-requested-node-in-spgist-inner-tuple
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/spgist/spgdoinsert.c:67"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1485"
reproduced: false
---

# `failed to find requested node %d in SPGiST inner tuple`

## What it means

Internal error in SPGiST. A traversal expected a particular child node within an inner tuple and did not find it. The `%d` is the node number. It is a consistency guard in SPGiST navigation.

## When it happens

It fires during SPGiST search or insertion when an inner tuple's node layout did not match what the code expected. Ordinary queries do not raise it; it can accompany index corruption.

## How to fix

Reindex the affected SPGiST index. If it recurs, check storage health and capture the index and a reproducible case for a bug report.

## Example

*Illustrative* — a missing node in an SPGiST inner tuple.

```text
ERROR:  failed to find requested node 2 in SPGiST inner tuple
```

## Related

- [failed to divide leaf tuple groups across pages](./failed-to-divide-leaf-tuple-groups-across-pages.md)
- [failed to add item of size to SPGiST index page](./failed-to-add-item-of-size-to-spgist-index-page-bd2e6a.md)
