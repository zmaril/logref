---
message: "could not parse numeric array \"%s\": invalid character in number"
slug: could-not-parse-numeric-array-invalid-character-in-number
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/common.c:1143"
reproduced: false
---

# `could not parse numeric array "%s": invalid character in number`

## What it means

`pg_dump` read a numeric array from the catalog (for example per-column statistics) and hit a character that is not part of a number. The `%s` value gives the raw array text. It parses these arrays to reproduce settings.

## When it happens

It happens during `pg_dump` when a stored numeric array contains an unexpected character — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions already match and the array is genuinely malformed, capture the reported text and report a reproducible case.

## Example

*Illustrative* — a non-numeric character in a numeric array.

```text
pg_dump: fatal: could not parse numeric array "{1,2,x}": invalid character in number
```

## Related

- [could not parse numeric array: too many numbers](./could-not-parse-numeric-array-too-many-numbers.md)
- [could not parse index statistic values](./could-not-parse-index-statistic-values.md)
