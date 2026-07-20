---
message: "btree index keys must be ordered by attribute"
slug: btree-index-keys-must-be-ordered-by-attribute
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:269"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:345"
reproduced: false
---

# `btree index keys must be ordered by attribute`

## What it means

Internal error. Btree key preprocessing found the scan keys were not in attribute order, which the btree code requires before it can process them. It is a consistency check the planner should have satisfied.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in how btree scan keys were assembled, not to your query.

## How to fix

Treat it as an internal bug. Capture the query and, where possible, its plan, and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — btree keys not in attribute order.

```text
ERROR:  btree index keys must be ordered by attribute
```

## Related

- [index key does not match expected index column](./index-key-does-not-match-expected-index-column.md)
- [missing support function for attribute of index](./missing-support-function-for-attribute-of-index-34bf15.md)
