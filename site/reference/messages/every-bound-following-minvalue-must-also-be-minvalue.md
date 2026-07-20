---
message: "every bound following MINVALUE must also be MINVALUE"
slug: every-bound-following-minvalue-must-also-be-minvalue
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:5137"
reproduced: false
---

# `every bound following MINVALUE must also be MINVALUE`

## What it means

A range-partition bound used `MINVALUE` in one column and then a concrete value in a later column of the same bound. Once a bound reaches `MINVALUE` in one column, every following column of that bound must also be `MINVALUE`.

## When it happens

It fires from `CREATE TABLE ... PARTITION OF` or `ALTER TABLE ... ATTACH PARTITION` when a multi-column range bound mixes `MINVALUE` with a finite value after it.

## How to fix

Fill every column after the first `MINVALUE` with `MINVALUE`. `MINVALUE` means unbounded below, so nothing finite can follow it in the same bound. Rewrite the bound so `MINVALUE` only appears in a suffix of the column list.

## Example

*Illustrative* — a finite value cannot follow MINVALUE.

```sql
... FOR VALUES FROM (MINVALUE, 5) TO (10, MAXVALUE);  -- invalid
... FOR VALUES FROM (MINVALUE, MINVALUE) TO (10, MAXVALUE);  -- valid
```

## Related

- [every bound following MAXVALUE must also be MAXVALUE](./every-bound-following-maxvalue-must-also-be-maxvalue.md)
- [expected PartitionBoundSpec](./expected-partitionboundspec.md)
