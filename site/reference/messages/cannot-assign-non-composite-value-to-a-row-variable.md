---
message: "cannot assign non-composite value to a row variable"
slug: cannot-assign-non-composite-value-to-a-row-variable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5263"
reproduced: false
---

# `cannot assign non-composite value to a row variable`

## What it means

A PL/pgSQL assignment tried to store a scalar or otherwise non-row value into a `%ROWTYPE` (row) variable. A row variable holds all the columns of a row, so the source must produce a composite value.

## When it happens

It occurs in PL/pgSQL when assigning to a `%ROWTYPE` variable from an expression that returns a single scalar rather than a row.

## How to fix

Assign a row-valued source — a `SELECT ... INTO` on the row variable, or a composite value matching the row type. For a single value, use a scalar variable.

## Example

*Illustrative* — a scalar assigned to a row variable.

```text
ERROR:  cannot assign non-composite value to a row variable
```

## Related

- [cannot assign non-composite value to a record variable](./cannot-assign-non-composite-value-to-a-record-variable.md)
- [cannot assign to field of column because there is no such column in data type](./cannot-assign-to-field-of-column-because-there-is-no-such-column-in-data-type.md)
