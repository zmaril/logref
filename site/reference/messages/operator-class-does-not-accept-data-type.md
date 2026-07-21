---
message: "operator class \"%s\" does not accept data type %s"
slug: operator-class-does-not-accept-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:2364"
  - "postgres/src/backend/commands/typecmds.c:2367"
reproduced: true
---

# `operator class "%s" does not accept data type %s`

## What it means

An operator class was named for a data type it does not support. The placeholders are the operator class and the data type. Each operator class works with a specific type (family).

## When it happens

It arises in `CREATE INDEX ... (col opclass)`, `CREATE OPERATOR CLASS`, or partition/collation setups when the chosen operator class is not defined for the column's type.

## How to fix

Choose an operator class that matches the column's data type, or omit it to use the type's default operator class. List operator classes with `\dAc` in psql, or query `pg_opclass`, to find one valid for the type and access method.

## Example

*Reproduced* — captured from `reproducers/scenarios/45_create_routines.sql`.

```sql
CREATE TYPE repro.rng_opc AS RANGE (SUBTYPE = int, SUBTYPE_OPCLASS = text_ops);
```

Produces:

```text
ERROR:  operator class "text_ops" does not accept data type integer
```

## Related

- [is not a base type](./is-not-a-base-type.md)
- [missing operator in partition opfamily](./missing-operator-in-partition-opfamily.md)
