---
message: "could not open parent table of index \"%s\""
slug: could-not-open-parent-table-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_TABLE
    code: "42P01"
call_sites:
  - "postgres/contrib/amcheck/verify_common.c:127"
  - "postgres/src/backend/access/brin/brin.c:1466"
  - "postgres/src/backend/access/brin/brin.c:1555"
reproduced: false
---

# `could not open parent table of index "%s"`

## What it means

An index-checking tool (here `amcheck`) could not open the table that an index belongs to. The placeholder names the index. Verifying an index requires access to its parent table; if that table cannot be opened, the check cannot run.

## When it happens

The parent table was dropped concurrently, is inaccessible, or the index-to-table relationship is inconsistent — for example running `bt_index_check` on an index whose table is being altered or removed.

## How to fix

Ensure the parent table exists and is accessible, and that no concurrent DDL is dropping or rewriting it while the check runs. Re-run the check on a quiescent object. If the index/table linkage is genuinely inconsistent, investigate the catalog for corruption and restore if needed.

## Example

*Illustrative* — amcheck unable to open an index's table.

```text
ERROR:  could not open parent table of index "t_idx"
```

## Related

- [cannot reindex system catalogs concurrently](./cannot-reindex-system-catalogs-concurrently.md)
- [corrupted BRIN index: inconsistent range map](./corrupted-brin-index-inconsistent-range-map.md)
