---
message: "cannot perform COPY FREEZE on a partitioned table"
slug: cannot-perform-copy-freeze-on-a-partitioned-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:879"
reproduced: false
---

# `cannot perform COPY FREEZE on a partitioned table`

## What it means

A `COPY ... WITH (FREEZE)` targeted a partitioned table. Rows loaded into a partitioned table are routed to leaf partitions, so the freeze guarantee cannot be applied at the parent level.

## When it happens

It occurs when `COPY FREEZE` is used with a partitioned table as the target.

## How to fix

Run `COPY FREEZE` against the individual leaf partitions instead of the partitioned parent, creating or truncating each partition in the same transaction as its load. Load the parent with a plain `COPY` if you do not need the freeze.

## Example

*Illustrative* — COPY FREEZE into a partitioned parent.

```text
ERROR:  cannot perform COPY FREEZE on a partitioned table
```

## Related

- [cannot perform COPY FREEZE on a foreign table](./cannot-perform-copy-freeze-on-a-foreign-table.md)
- [cannot perform COPY FREEZE because of prior transaction activity](./cannot-perform-copy-freeze-because-of-prior-transaction-activity.md)
