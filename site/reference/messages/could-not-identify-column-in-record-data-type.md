---
message: "could not identify column \"%s\" in record data type"
slug: could-not-identify-column-in-record-data-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:423"
reproduced: false
---

# `could not identify column "%s" in record data type`

## What it means

A query referred to a field of a composite (record) value by name, and that record type has no column with that name. Field access on a composite value must name a column the record actually has.

## When it happens

It happens when selecting `value.field` (or `(value).field`) where `field` is not a column of the record's type — often a typo, a renamed column, or a record whose shape differs from what the query assumes.

## How to fix

Use a field name that exists in the record type. Check the composite type's or table's columns and correct the name; when working with an anonymous `record`, add a column definition list (`AS (...)`) that names the expected fields.

## Example

*Illustrative* — referencing a field the record does not have.

```sql
SELECT (row(1, 2)::myrec).missing;
-- ERROR:  could not identify column "missing" in record data type
```

## Related

- [could not get element type of array type](./could-not-get-element-type-of-array-type.md)
- [could not identify anycompatible type](./could-not-identify-anycompatible-type.md)
