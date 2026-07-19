---
message: "function %u returned NULL"
slug: function-returned-null-c63728
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeIncrementalSort.c:258"
  - "postgres/src/backend/utils/adt/rangetypes.c:2217"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1125"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1145"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1167"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1192"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1219"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1248"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1280"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1314"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1350"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1389"
  - "postgres/src/backend/utils/sort/sortsupport.c:58"
reproduced: false
---

# `function %u returned NULL`

## What it means

Internal error. A C-language function declared `STRICT` (or otherwise expected to return non-null) returned a NULL pointer where the caller required a value. The placeholder is the function OID. This indicates a misbehaving function implementation, not a SQL NULL.

## When it happens

A bug in a C function or an extension whose implementation returned NULL improperly, or a support function (comparison, hashing, I/O) that violated its contract. Ordinary SQL and PL/pgSQL functions do not cause this.

## How to fix

Identify the function by OID (`SELECT '16712'::regprocedure`) and suspect its C implementation or the extension that provides it. It is a bug in that function — report it to the extension author with the reproducing query. Do not mistake it for a data NULL; the fault is in the function's code.

## Example

*Illustrative* — a C function violating its non-null contract.

```text
ERROR:  function 16712 returned NULL
```

## Related

- [function %p returned NULL](./function-returned-null-700f5d.md)
- [cache lookup failed for function](./cache-lookup-failed-for-function.md)
