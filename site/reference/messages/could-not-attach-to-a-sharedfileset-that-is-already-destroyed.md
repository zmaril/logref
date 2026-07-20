---
message: "could not attach to a SharedFileSet that is already destroyed"
slug: could-not-attach-to-a-sharedfileset-that-is-already-destroyed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/storage/file/sharedfileset.c:71"
reproduced: false
---

# `could not attach to a SharedFileSet that is already destroyed`

## What it means

A backend tried to attach to a shared temporary file set that has already been destroyed. The set is gone, so it cannot be joined. This guards parallel operations that share temporary files.

## When it happens

It happens during parallel query execution when a worker attempts to use a `SharedFileSet` after it was torn down, often following an error or early exit in a cooperating process.

## How to fix

This usually surfaces alongside another failure that tore down the operation. Address the primary error; retry the query. If it recurs without an obvious cause, capture the plan and report it, as it may indicate a parallel-execution bug.

## Example

*Illustrative* — attaching to a destroyed shared file set.

```text
ERROR:  could not attach to a SharedFileSet that is already destroyed
```

## Related

- [could not append BufFile with non-matching resource owner](./could-not-append-buffile-with-non-matching-resource-owner.md)
- [could not attach to per-session DSM segment](./could-not-attach-to-per-session-dsm-segment.md)
