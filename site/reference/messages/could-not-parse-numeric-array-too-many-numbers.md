---
message: "could not parse numeric array \"%s\": too many numbers"
slug: could-not-parse-numeric-array-too-many-numbers
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/common.c:1131"
reproduced: false
---

# `could not parse numeric array "%s": too many numbers`

## What it means

`pg_dump` read a numeric array from the catalog and found more numbers than it expected. The `%s` value gives the raw array text. It parses these arrays to reproduce settings such as per-column statistics.

## When it happens

It happens during `pg_dump` when a stored numeric array has more elements than the tool expects — usually a version mismatch between the dumping tool and the server, or unusual catalog contents.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions already match, capture the reported text and report a reproducible case.

## Example

*Illustrative* — a numeric array with too many elements.

```text
pg_dump: fatal: could not parse numeric array "{1,2,3,4}": too many numbers
```

## Related

- [could not parse numeric array: invalid character in number](./could-not-parse-numeric-array-invalid-character-in-number.md)
- [could not parse index statistic columns](./could-not-parse-index-statistic-columns.md)
