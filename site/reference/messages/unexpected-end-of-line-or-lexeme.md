---
message: "unexpected end of line or lexeme"
slug: unexpected-end-of-line-or-lexeme
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/dict_thesaurus.c:260"
  - "postgres/src/backend/tsearch/dict_thesaurus.c:276"
reproduced: false
---

# `unexpected end of line or lexeme`

## What it means

A text-search configuration or query parser reached the end of a line or lexeme where more input was expected. The tokenized input for a text-search resource or query is incomplete at that point.

## When it happens

It arises when parsing a text-search configuration file, a `tsquery`/`tsvector` input, or a dictionary resource that ends mid-token — a truncated or malformed source.

## How to fix

Inspect the input at the point of failure and complete or correct the truncated token/line. For configuration files, restore a valid version; for query/vector inputs, fix the malformed text before parsing.

## Example

*Illustrative* — text-search input ending mid-lexeme.

```text
ERROR:  unexpected end of line or lexeme
```

## Related

- [unexpected end of flag array](./unexpected-end-of-flag-array.md)
- [syntax error in file "%s" line %u: expected end of line](./syntax-error-in-file-line-expected-end-of-line.md)
