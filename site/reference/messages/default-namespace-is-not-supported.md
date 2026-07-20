---
message: "DEFAULT namespace is not supported"
slug: default-namespace-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:4846"
reproduced: false
---

# `DEFAULT namespace is not supported`

## What it means

An XML query passed a default namespace declaration, which PostgreSQL's XPath support does not implement. Only prefixed namespaces are supported.

## When it happens

It fires from XML functions such as `xpath()` or `XMLTABLE` when the namespace array includes a default (empty-prefix) namespace binding.

## How to fix

Bind the namespace to an explicit prefix and use that prefix in the XPath expression instead of relying on a default namespace. For example, declare `ARRAY[ARRAY['n', 'http://example.com/ns']]` and write `/n:root/n:child`.

## Example

*Illustrative* — a default namespace binding.

```sql
SELECT xpath('/a', x, ARRAY[ARRAY['', 'http://ex/ns']]);
-- DEFAULT namespace is not supported
```

## Related

- [empty XPath expression](./empty-xpath-expression.md)
- [could not set up XML error handler](./could-not-set-up-xml-error-handler.md)
