---
message: "array of serial is not implemented"
slug: array-of-serial-is-not-implemented
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:638"
reproduced: false
---

# `array of serial is not implemented`

## What it means

A column was declared as an array of a serial type (for example `serial[]`), but arrays of serial are not supported, since `serial` is shorthand for an integer column tied to a sequence rather than a real element type.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE` when a column type is written as `serial[]`, `bigserial[]`, or `smallserial[]`.

## How to fix

Declare the column as an array of the underlying integer type (`integer[]`, `bigint[]`) and manage default values yourself if needed. `serial` is not a type that can be arrayed; there is no per-element sequence behavior.

## Example

*Illustrative* — an array-of-serial column.

```sql
CREATE TABLE t (ids serial[]);  -- ERROR:  array of serial is not implemented
```

## Related

- [array element type cannot be](./array-element-type-cannot-be.md)
- [a hash-partitioned table may not have a default partition](./a-hash-partitioned-table-may-not-have-a-default-partition.md)
