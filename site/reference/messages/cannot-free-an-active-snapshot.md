---
message: "cannot free an active snapshot"
slug: cannot-free-an-active-snapshot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:272"
reproduced: false
---

# `cannot free an active snapshot`

## What it means

An internal guard in the logical-decoding snapshot builder fired: it tried to free a snapshot that is still active. A snapshot in use must not be released, so the free was refused.

## When it happens

It is reached inside snapshot-building bookkeeping when reference counting is out of step and code attempts to drop a snapshot still marked active. It reflects an internal issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the logical-decoding or replication setup that led to it and report it, since snapshot lifetimes here are managed by the decoding machinery.

## Example

*Illustrative* — freeing an in-use snapshot.

```text
ERROR:  cannot free an active snapshot
```

## Related

- [cannot export a snapshot from within a transaction](./cannot-export-a-snapshot-from-within-a-transaction.md)
- [cannot fetch toast data without an active snapshot](./cannot-fetch-toast-data-without-an-active-snapshot.md)
