---
message: "cannot assign non-composite value to a record variable"
slug: cannot-assign-non-composite-value-to-a-record-variable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5295"
reproduced: false
---

# `cannot assign non-composite value to a record variable`

## What it means

A PL/pgSQL assignment tried to store a scalar or otherwise non-row value into a `record` variable. A record variable holds a whole row, so the right-hand side must produce a composite value.

## When it happens

It occurs in PL/pgSQL when assigning to a `record` variable from an expression that returns a single scalar rather than a row.

## How to fix

Assign a row-valued expression — a `SELECT ... INTO`, a `ROW(...)`, or a composite-typed value. To store a single scalar, declare a scalar variable instead of a `record`.

## Example

*Illustrative* — a scalar assigned to a record.

```text
ERROR:  cannot assign non-composite value to a record variable
```

## Related

- [cannot assign non-composite value to a row variable](./cannot-assign-non-composite-value-to-a-row-variable.md)
- [cannot assign to field of column because its type is not a composite type](./cannot-assign-to-field-of-column-because-its-type-is-not-a-composite-type.md)
