---
message: "CSV quote character must not appear in the %s specification"
slug: csv-quote-character-must-not-appear-in-the-specification
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:977"
  - "postgres/src/backend/commands/copy.c:1024"
reproduced: false
---

# `CSV quote character must not appear in the %s specification`

## What it means

A `COPY ... CSV` command set the quote character to a value that also appears in another CSV specification (the null string, delimiter, or similar). The `%s` names which specification. The characters would be ambiguous during parsing.

## When it happens

Choosing a `QUOTE`, `DELIMITER`, `NULL`, or escape combination where the quote character collides with one of the others in `COPY ... WITH (FORMAT csv, ...)`.

## How to fix

Pick a quote character distinct from the delimiter, null string, and escape. Adjust the conflicting `COPY` option so no two roles share a character.

## Example

*Illustrative* — the quote character appears in the null string.

```text
ERROR:  CSV quote character must not appear in the NULL specification
```

## Related

- [end-of-copy marker does not match previous newline style](./end-of-copy-marker-does-not-match-previous-newline-style.md)
- [could not write COPY data](./could-not-write-copy-data.md)
