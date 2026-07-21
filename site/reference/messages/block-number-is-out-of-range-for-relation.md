---
message: "block number %u is out of range for relation \"%s\""
slug: block-number-is-out-of-range-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/pageinspect/rawpage.c:179"
reproduced: true
---

# `block number %u is out of range for relation "%s"`

## What it means

A function was asked to act on a block number that lies beyond the current size of the relation. The placeholders are the block number and the relation. The relation has fewer blocks than the requested position.

## When it happens

It occurs with functions that take an explicit block number, such as `pg_prewarm` or `pageinspect`, when the number exceeds the relation's block count.

## How to fix

Choose a block number within range. Find the relation's size in blocks with `pg_relation_size(rel) / current_setting('block_size')::int` or `pg_relpages`, and keep the requested block below that count.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT get_raw_page('repro.parent', 999999);
```

Produces:

```text
ERROR:  block number 999999 is out of range for relation "parent"
```

## Related

- [block 0 is a meta page](./block-0-is-a-meta-page.md)
- [autoprewarm block dump file is corrupted at line](./autoprewarm-block-dump-file-is-corrupted-at-line.md)
