---
message: "function with OID %u does not exist"
slug: function-with-oid-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/tcop/fastpath.c:139"
  - "postgres/src/backend/utils/fmgr/fmgr.c:2125"
reproduced: false
---

# `function with OID %u does not exist`

## What it means

A lookup by function OID found no matching row in `pg_proc`. The `%u` is the OID. It fires in low-level paths such as fast-path calls or the function-manager cache when an OID no longer resolves to a function.

## When it happens

A function was dropped while a cached plan, fast-path call, or prepared reference still held its OID, or a client issued a fast-path call for a nonexistent function OID.

## How to fix

If a client uses the fast-path protocol, confirm it targets a function that exists. If it followed a `DROP FUNCTION`, re-plan or reconnect so stale OIDs are discarded. Persistent cases without concurrent DDL warrant a bug report.

## Example

*Illustrative* — a fast-path call for a missing function.

```text
ERROR:  function with OID 16400 does not exist
```

## Related

- [function name is not unique](./function-name-is-not-unique.md)
- [could not find tuple for function](./could-not-find-tuple-for-function.md)
