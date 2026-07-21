---
message: "cannot assign to field \"%s\" of column \"%s\" because there is no such column in data type %s"
slug: cannot-assign-to-field-of-column-because-there-is-no-such-column-in-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_target.c:794"
reproduced: false
---

# `cannot assign to field "%s" of column "%s" because there is no such column in data type %s`

## What it means

An assignment used the `column.field` form to set a subfield, but the composite type has no attribute with that name. The field named on the left-hand side does not exist in the column's row type.

## When it happens

It occurs when writing `col.field = ...` where `col` is composite but `field` is not one of its attributes — often a typo or a stale reference after the type changed.

## How to fix

Use a field name that exists in the composite type. Inspect the type's attributes and correct the name, or add the attribute to the type if it is genuinely missing.

## Example

*Illustrative* — an unknown field name.

```text
ERROR:  cannot assign to field "zz" of column "c" because there is no such column in data type mytype
```

## Related

- [cannot assign to field of column because its type is not a composite type](./cannot-assign-to-field-of-column-because-its-type-is-not-a-composite-type.md)
- [cannot assign non-composite value to a row variable](./cannot-assign-non-composite-value-to-a-row-variable.md)
