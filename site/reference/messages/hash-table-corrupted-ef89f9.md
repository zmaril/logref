---
message: "hash table corrupted"
slug: hash-table-corrupted-ef89f9
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/shippable.c:84"
  - "postgres/src/backend/access/transam/xlogutils.c:189"
  - "postgres/src/backend/access/transam/xlogutils.c:217"
  - "postgres/src/backend/nodes/tidbitmap.c:565"
  - "postgres/src/backend/parser/parse_oper.c:1103"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:505"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:567"
  - "postgres/src/backend/tsearch/ts_typanalyze.c:484"
  - "postgres/src/backend/utils/adt/array_typanalyze.c:711"
  - "postgres/src/backend/utils/adt/mcxtfuncs.c:101"
  - "postgres/src/backend/utils/cache/attoptcache.c:77"
  - "postgres/src/backend/utils/cache/relfilenumbermap.c:76"
  - "postgres/src/backend/utils/cache/spccache.c:70"
reproduced: false
---

# `hash table corrupted`

## What it means

Internal error. An in-memory dynamic hash table failed an internal consistency check — its bookkeeping does not add up. This is a guard against memory corruption or a logic bug in code that manages the hash table.

## When it happens

Memory corruption (failing RAM, a buggy extension writing out of bounds), or a bug in core or extension code that mismanages a shared or local hash table. It is not caused by user data.

## How to fix

Treat it as serious. If it coincides with other corruption symptoms, run memory diagnostics (memtest) and check for failing hardware. If you run extensions with C code, suspect one that may be corrupting memory. Capture the workload and a stack trace and report it; a reproducible case is valuable.

## Example

*Illustrative* — an internal consistency check firing.

```text
ERROR:  hash table corrupted
```

## Related

- [out of shared memory](./out-of-shared-memory.md)
- [unexpected end of tuplestore](./unexpected-end-of-tuplestore.md)
