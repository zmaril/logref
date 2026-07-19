---
message: "cannot fetch toast data without an active snapshot"
slug: cannot-fetch-toast-data-without-an-active-snapshot
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/toast_internals.c:644"
reproduced: false
---

# `cannot fetch toast data without an active snapshot`

## What it means

An internal guard fired: code tried to read out-of-line TOAST data without an active snapshot. TOAST chunks are read under a snapshot that fixes their visibility, and this path had none.

## When it happens

It is reached when a value that was TOASTed out of line is detoasted after its snapshot has been released — often when a datum outlives the transaction or snapshot that produced it. It usually points to an extension or code path holding a value too long.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that retains values across snapshot boundaries and report it. Avoid caching TOAST-pointer values beyond the snapshot that read them.

## Example

*Illustrative* — detoasting with no active snapshot.

```text
ERROR:  cannot fetch toast data without an active snapshot
```

## Related

- [cannot execute SQL without an outer snapshot or portal](./cannot-execute-sql-without-an-outer-snapshot-or-portal.md)
- [cannot free an active snapshot](./cannot-free-an-active-snapshot.md)
