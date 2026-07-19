---
message: "COPY delimiter character must not appear in the %s specification"
slug: copy-delimiter-character-must-not-appear-in-the-specification
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:968"
  - "postgres/src/backend/commands/copy.c:1015"
reproduced: false
---

# `COPY delimiter character must not appear in the %s specification`

## What it means

A `COPY` command chose a delimiter that also appears in another `COPY` specification string, such as the null string or the quote/escape characters. The placeholder names the conflicting specification. The delimiter must be distinct so parsing is unambiguous.

## When it happens

`COPY ... WITH (DELIMITER ..., NULL ...)` (or CSV quote/escape options) where the delimiter character is contained in the null string or another special-character option.

## How to fix

Choose a delimiter that does not occur in the null string, quote, or escape settings — or adjust those settings so they do not contain the delimiter. Pick characters that cannot collide across the `COPY` options.

## Example

*Illustrative* — a delimiter that appears in the null string.

```sql
COPY t TO STDOUT WITH (DELIMITER ',', NULL 'a,b');
-- ERROR:  COPY delimiter character must not appear in the NULL specification
```

## Related

- [COPY not recognized](./copy-not-recognized.md)
- [COPY from stdin failed](./copy-from-stdin-failed.md)
