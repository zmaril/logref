---
message: "corrupted line pointer: offset = %u, size = %zu"
slug: corrupted-line-pointer-offset-size-bdc6c1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/src/backend/storage/page/bufpage.c:1099"
  - "postgres/src/backend/storage/page/bufpage.c:1240"
  - "postgres/src/backend/storage/page/bufpage.c:1337"
reproduced: false
---

# `corrupted line pointer: offset = %u, size = %zu`

## What it means

Reading a heap or index page, the server found a line pointer (the small slot-array entry that locates a tuple within a page) whose offset and length point outside the page or overlap invalidly. The placeholders are the offset and size. It signals on-disk page corruption.

## When it happens

Accessing a page whose structure was damaged — storage faults, a crash with fsync/full-page-writes disabled, or bit-rot. It is not produced by valid data.

## How to fix

Treat it as corruption. Identify the affected relation and page (the surrounding context and logs help), verify with `amcheck`/`pg_amcheck`, and restore the affected object from a known-good backup. Investigate the storage hardware and disable-fsync-style misconfigurations. Report reproducible cases that are not explained by hardware or unsafe settings.

## Example

*Illustrative* — a damaged line pointer on a page.

```text
ERROR:  corrupted line pointer: offset = 8160, size = 40
```

## Related

- [corrupted BRIN index: inconsistent range map](./corrupted-brin-index-inconsistent-range-map.md)
- [null field found in pg_largeobject](./null-field-found-in-pg-largeobject.md)
