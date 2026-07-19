---
message: "every bound following MAXVALUE must also be MAXVALUE"
slug: every-bound-following-maxvalue-must-also-be-maxvalue
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:5130"
reproduced: false
---

# `every bound following MAXVALUE must also be MAXVALUE`

## What it means

A range-partition bound used `MAXVALUE` in one column and then a concrete value in a later column of the same bound. Once a bound reaches `MAXVALUE` in one column, every following column of that bound must also be `MAXVALUE`.

## When it happens

It fires from `CREATE TABLE ... PARTITION OF ... FOR VALUES FROM (...) TO (...)` (or the equivalent `ALTER TABLE ATTACH`) when a multi-column range bound mixes `MAXVALUE` with a finite value after it.

## How to fix

Fill every column after the first `MAXVALUE` with `MAXVALUE` as well. `MAXVALUE` means unbounded above, so nothing finite can follow it in the same bound. Rewrite the bound so `MAXVALUE` only appears in a suffix of the column list.

## Example

*Illustrative* — a finite value cannot follow MAXVALUE.

```sql
... FOR VALUES FROM (1, MINVALUE) TO (MAXVALUE, 100);  -- invalid
... FOR VALUES FROM (1, MINVALUE) TO (MAXVALUE, MAXVALUE);  -- valid
```

## Related

- [every bound following MINVALUE must also be MINVALUE](./every-bound-following-minvalue-must-also-be-minvalue.md)
- [expected PartitionBoundSpec](./expected-partitionboundspec.md)
