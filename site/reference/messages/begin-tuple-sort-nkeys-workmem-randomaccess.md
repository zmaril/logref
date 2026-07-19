---
message: "begin tuple sort: nkeys = %d, workMem = %d, randomAccess = %c"
slug: begin-tuple-sort-nkeys-workmem-randomaccess
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:198"
  - "postgres/src/backend/utils/sort/tuplesortvariants.c:273"
reproduced: false
---

# `begin tuple sort: nkeys = %d, workMem = %d, randomAccess = %c`

## What it means

A trace line emitted when a sort operation begins, reporting the number of sort keys, the working-memory budget, and whether random access to the sorted result was requested.

## When it happens

It appears when sort-tracing is enabled (a debug build or a raised trace level). It is diagnostic detail about how a sort was set up, not a condition to act on.

## Is this a problem?

No action is needed. It is internal sort-diagnostics output; it appears only when trace-level logging for sorts is on. Lower the log level to silence it.

## Example

*Illustrative* — a sort-start trace line.

```text
LOG:  begin tuple sort: nkeys = 2, workMem = 65536, randomAccess = f
```

## Related

- [checkpoint record is at %X/%08X](./checkpoint-record-is-at.md)
- [key (%u, %u) -> %u](./key.md)
