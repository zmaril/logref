---
message: "function %p returned NULL"
slug: function-returned-null-700f5d
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/fmgr/fmgr.c:808"
  - "postgres/src/backend/utils/fmgr/fmgr.c:830"
  - "postgres/src/backend/utils/fmgr/fmgr.c:855"
  - "postgres/src/backend/utils/fmgr/fmgr.c:882"
  - "postgres/src/backend/utils/fmgr/fmgr.c:911"
  - "postgres/src/backend/utils/fmgr/fmgr.c:943"
  - "postgres/src/backend/utils/fmgr/fmgr.c:977"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1013"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1052"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1081"
  - "postgres/src/backend/utils/fmgr/fmgr.c:1103"
reproduced: false
---

# `function %p returned NULL`

## What it means

Internal error. A C function called via a function pointer returned NULL where a non-null result was required (a `STRICT` function or a support function). The placeholder is the function pointer address. Like the OID form, this indicates a misbehaving C implementation, not a SQL NULL.

## When it happens

A bug in a C function or extension whose implementation returned NULL improperly, reached through an internal call site that identifies the function only by pointer. Ordinary SQL/PL functions do not cause it.

## How to fix

Suspect the C code or extension providing the function. It violates the non-null contract and is a bug to report to its author. The pointer address is not directly actionable, but the surrounding operation and stack trace localize which function is at fault.

## Example

*Illustrative* — a C support function returning NULL.

```text
ERROR:  function 0x7f3a1c returned NULL
```

## Related

- [function %u returned NULL](./function-returned-null-c63728.md)
- [cache lookup failed for function](./cache-lookup-failed-for-function.md)
