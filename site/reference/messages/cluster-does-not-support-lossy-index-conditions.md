---
message: "CLUSTER does not support lossy index conditions"
slug: cluster-does-not-support-lossy-index-conditions
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/heapam_handler.c:724"
reproduced: false
---

# `CLUSTER does not support lossy index conditions`

## What it means

An internal guard fired: the `CLUSTER` implementation was handed an index scan condition that can return false matches, which it cannot use to order the rewrite. `CLUSTER` needs exact index results, so a lossy condition is not supported.

## When it happens

It is reached from `CLUSTER` execution when the chosen index scan would be lossy. It reflects an internal planning inconsistency rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the `CLUSTER` command, the table and index involved, and the server log, then report it. It points to a bug in the cluster scan setup.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  CLUSTER does not support lossy index conditions
```

## Related

- [close of when was expected](./close-of-when-was-expected.md)
- [clustering of table in database failed](./clustering-of-table-in-database-failed.md)
