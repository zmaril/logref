---
message: "expression returning multiple columns is not valid in parameter list"
slug: expression-returning-multiple-columns-is-not-valid-in-parameter-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/xml2/xpath.c:753"
reproduced: false
---

# `expression returning multiple columns is not valid in parameter list`

## What it means

A function in the `xml2` contrib module was passed an XPath parameter expression that returned several columns where a single scalar was required.

## When it happens

It fires from `xml2` XPath table functions (such as `xpath_table`) when one of the supplied XPath expressions yields a multi-column row-typed result instead of a single value.

## How to fix

Rewrite each XPath parameter so it returns a single scalar column. Split a multi-column expression into separate parameters, one per output column. The `xml2` module is a legacy contrib; for new work consider the built-in XML functions (`xpath`, `xmltable`), which handle multi-column extraction more cleanly.

## Example

*Illustrative* — each XPath arg must be scalar.

```sql
SELECT xpath_table('id', 'data', 'docs', '/row/id', 'true');
```

## Related

- [expression contains variables](./expression-contains-variables.md)
- [expression contains variables of more than one relation](./expression-contains-variables-of-more-than-one-relation.md)
