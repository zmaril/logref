---
message: "empty XPath expression"
slug: empty-xpath-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_XQUERY
    code: "10608"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:4438"
reproduced: false
---

# `empty XPath expression`

## What it means

An XML function was given an empty XPath expression string. There is nothing to evaluate against the document.

## When it happens

It fires from `xpath()`, `xpath_exists()`, or `XMLTABLE` when the path argument is an empty string.

## How to fix

Pass a non-empty XPath expression, for example `'/root/item'`. Check that the value supplied for the path is not blank, especially when it comes from a column or parameter.

## Example

*Illustrative* — an empty XPath.

```sql
SELECT xpath('', x) FROM docs;
-- empty XPath expression
```

## Related

- [DEFAULT namespace is not supported](./default-namespace-is-not-supported.md)
- [could not set up XML error handler](./could-not-set-up-xml-error-handler.md)
