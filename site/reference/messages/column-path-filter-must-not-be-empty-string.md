---
message: "column path filter must not be empty string"
slug: column-path-filter-must-not-be-empty-string
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_XQUERY
    code: "10608"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:4909"
reproduced: false
---

# `column path filter must not be empty string`

## What it means

An `XMLTABLE` column definition supplied an empty string as its XPath (column path) expression. A column path must be a non-empty XPath, so an empty one is rejected.

## When it happens

It happens in `XMLTABLE(... COLUMNS name type PATH '')` when the `PATH` expression evaluates to an empty string.

## How to fix

Give each column a valid, non-empty XPath expression, or omit `PATH` to use the default (the column name). Check any expression that computes the path at runtime.

## Example

*Illustrative* — an empty column PATH in XMLTABLE.

```sql
SELECT * FROM XMLTABLE('/r' PASSING x COLUMNS c text PATH '');
-- ERROR:  column path filter must not be empty string
```

## Related

- [invalid XML comment](./invalid-xml-comment.md)
- [invalid XML processing instruction](./invalid-xml-processing-instruction.md)
