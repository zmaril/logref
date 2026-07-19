---
message: "invalid attribute number %d"
slug: invalid-attribute-number
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/dblink/dblink.c:3026"
  - "postgres/contrib/dblink/dblink.c:3045"
  - "postgres/src/backend/executor/execTuples.c:2147"
  - "postgres/src/backend/executor/execUtils.c:1161"
  - "postgres/src/backend/parser/parse_relation.c:3767"
  - "postgres/src/backend/parser/parse_relation.c:3789"
  - "postgres/src/backend/parser/parse_relation.c:3807"
reproduced: false
---

# `invalid attribute number %d`

## What it means

An operation referenced a column by attribute number that is not valid for the relation or tuple. The placeholder is the number. Attribute numbers are 1-based positions in a row; a value that is zero, negative (beyond the defined system columns), or larger than the column count is rejected.

## When it happens

Functions that take an attribute number (`dblink` result mapping, tuple utilities, some inspection functions) given a bad index, or internal code building a tuple descriptor with a mismatched attribute reference. It can follow a schema change that shifted column positions.

## How to fix

Pass an attribute number within the relation's column range (1 to the number of columns). If the value comes from a mapping that assumed a fixed layout, re-derive it from the current schema (`pg_attribute.attnum`). For functions with an attno argument, verify it against the actual column count.

## Example

*Illustrative* — an out-of-range attribute number.

```text
ERROR:  invalid attribute number 9
```

## Related

- [column %d of relation does not exist](./column-of-relation-does-not-exist-df5695.md)
- [invalid large-object descriptor](./invalid-large-object-descriptor.md)
