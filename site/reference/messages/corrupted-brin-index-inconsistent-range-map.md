---
message: "corrupted BRIN index: inconsistent range map"
slug: corrupted-brin-index-inconsistent-range-map
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/src/backend/access/brin/brin_revmap.c:257"
  - "postgres/src/backend/access/brin/brin_revmap.c:381"
  - "postgres/src/backend/access/brin/brin_revmap.c:387"
reproduced: false
---

# `corrupted BRIN index: inconsistent range map`

## What it means

A BRIN index's range map (the metapage-referenced structure mapping heap page ranges to summary tuples) was found internally inconsistent. The placeholder-free message indicates the index's on-disk structure is damaged; the range map no longer describes the heap ranges correctly.

## When it happens

Reading or maintaining a BRIN index whose pages were corrupted — hardware faults, a crash with fsync disabled, or bit-rot in the index storage. It is not caused by ordinary queries.

## How to fix

Rebuild the index: `REINDEX INDEX <name>` recreates the BRIN structure from the heap. If corruption recurs, investigate storage/hardware and check the heap itself with `amcheck`/`pg_amcheck`. Restore from backup if the underlying data is also affected. Report reproducible cases not explained by hardware.

## Example

*Illustrative* — a damaged BRIN range map.

```text
ERROR:  corrupted BRIN index: inconsistent range map
```

## Related

- [corrupted line pointer offset size](./corrupted-line-pointer-offset-size-bdc6c1.md)
- [could not open parent table of index](./could-not-open-parent-table-of-index.md)
