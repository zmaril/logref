---
message: "cannot specify NULL in range bound"
slug: cannot-specify-null-in-range-bound
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:5082"
reproduced: false
---

# `cannot specify NULL in range bound`

## What it means

A range-partition bound was written with `NULL` as one of its values. Range partition bounds must be finite ordinary values or the special `MINVALUE`/`MAXVALUE` markers, and `NULL` is not permitted.

## When it happens

It occurs when `CREATE TABLE ... PARTITION OF ... FOR VALUES FROM (...) TO (...)` includes `NULL` in one of the bound tuples.

## How to fix

Replace `NULL` with a concrete value or with `MINVALUE`/`MAXVALUE` for an unbounded end. To capture rows whose partition key is null, use a default partition instead.

## Example

*Illustrative* — NULL used as a bound.

```sql
CREATE TABLE p PARTITION OF t FOR VALUES FROM (NULL) TO (10);
-- ERROR:  cannot specify NULL in range bound
```

## Related

- [cannot specify more than one DEFAULT partition](./cannot-specify-more-than-one-default-partition.md)
- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
