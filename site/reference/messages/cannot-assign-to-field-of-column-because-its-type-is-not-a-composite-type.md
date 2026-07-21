---
message: "cannot assign to field \"%s\" of column \"%s\" because its type %s is not a composite type"
slug: cannot-assign-to-field-of-column-because-its-type-is-not-a-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:785"
reproduced: false
---

# `cannot assign to field "%s" of column "%s" because its type %s is not a composite type`

## What it means

An `UPDATE` or assignment used the `column.field` form to set a subfield, but the column's type is not composite. Field assignment only works on columns whose type is a composite (row) type with named attributes.

## When it happens

It occurs when a target list writes `col.field = ...` for a column whose declared type is a scalar or a non-composite type.

## How to fix

Assign to the whole column instead of a field, or change the column to a composite type that has the named field. Confirm the column's type actually has the attribute you are trying to set.

## Example

*Illustrative* — field assignment on a scalar column.

```text
ERROR:  cannot assign to field "x" of column "c" because its type integer is not a composite type
```

## Related

- [cannot assign to field of column because there is no such column in data type](./cannot-assign-to-field-of-column-because-there-is-no-such-column-in-data-type.md)
- [cannot assign non-composite value to a record variable](./cannot-assign-non-composite-value-to-a-record-variable.md)
