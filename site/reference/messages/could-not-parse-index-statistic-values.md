---
message: "could not parse index statistic values"
slug: could-not-parse-index-statistic-values
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:18332"
reproduced: false
---

# `could not parse index statistic values`

## What it means

`pg_dump` read the values for an index's stored statistics targets and could not parse them. It dumps per-column statistics settings so they are restored, and the stored values were not in the expected form.

## When it happens

It happens during `pg_dump` when the internal representation of an index's statistics values is malformed or unexpected — usually a version mismatch between the dumping tool and the server.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions already match, capture the surrounding output and report a reproducible case.

## Example

*Illustrative* — unparsable index statistics values.

```text
pg_dump: fatal: could not parse index statistic values
```

## Related

- [could not parse index statistic columns](./could-not-parse-index-statistic-columns.md)
- [could not parse numeric array: invalid character in number](./could-not-parse-numeric-array-invalid-character-in-number.md)
