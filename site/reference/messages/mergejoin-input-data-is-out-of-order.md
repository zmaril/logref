---
message: "mergejoin input data is out of order"
slug: mergejoin-input-data-is-out-of-order
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeMergejoin.c:904"
  - "postgres/src/backend/executor/nodeMergejoin.c:1147"
reproduced: false
---

# `mergejoin input data is out of order`

## What it means

Internal error. A merge join received input that is not sorted in the order the join key requires. The merge algorithm depends on sorted inputs, and this guard fired because an input row broke the expected order.

## When it happens

It fires during merge-join execution when a sort or index that was supposed to deliver ordered rows did not — often tied to a mismatched or corrupted operator class/collation, or a damaged index used to provide the order.

## How to fix

This is a consistency guard. Suspect a sort-order mismatch: check the collation and operator class for the join columns, and rebuild any index feeding the sorted input with `REINDEX`. As a workaround, `SET enable_mergejoin = off` forces a different join method. Capture the query and report a reproducible case.

## Example

*Illustrative* — unsorted input reaching a merge join.

```text
ERROR:  mergejoin input data is out of order
```

## Related

- [index is not a btree](./index-is-not-a-btree.md)
- [missing operator in partition opfamily](./missing-operator-in-partition-opfamily.md)
