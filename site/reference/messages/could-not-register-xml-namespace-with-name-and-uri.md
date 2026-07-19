---
message: "could not register XML namespace with name \"%s\" and URI \"%s\""
slug: could-not-register-xml-namespace-with-name-and-uri
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/xml.c:4498"
reproduced: false
---

# `could not register XML namespace with name "%s" and URI "%s"`

## What it means

An XML function could not register a namespace prefix and its URI with the underlying XML library while evaluating an expression. The placeholders are the prefix name and the URI.

## When it happens

It fires inside XML processing — for example `xpath()` with a namespace mapping — when the library rejects the namespace registration, which usually points at an invalid prefix or URI in the mapping you supplied.

## How to fix

Check the namespace array you passed. Each entry needs a valid prefix and a well-formed URI, and the prefix must be a legal XML name. Correct the offending entry and rerun. If the mapping came from data, validate it before use.

## Example

*Illustrative* — a bad namespace mapping.

```sql
SELECT xpath('//a:x', d, ARRAY[ARRAY['a', '']]) FROM t;
-- ERROR:  could not register XML namespace with name "a" and URI ""
```

## Related

- [could not set up XML error handler](./could-not-set-up-xml-error-handler.md)
- [could not set libxslt security preferences](./could-not-set-libxslt-security-preferences.md)
