---
message: "could not parse index statistic columns"
slug: could-not-parse-index-statistic-columns
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:18330"
reproduced: false
---

# `could not parse index statistic columns`

## What it means

`pg_dump` read the column list for an index's stored statistics targets and could not parse it. It dumps per-column statistics settings so they are restored, and the stored column list was not in the expected form.

## When it happens

It happens during `pg_dump` when the internal representation of an index's statistics columns is malformed or in an unexpected form — usually a version mismatch between the dumping tool and the server.

## How to fix

Use a `pg_dump` whose version matches (or is newer than) the server being dumped. If the versions already match, capture the surrounding output and report a reproducible case.

## Example

*Illustrative* — an unparsable index statistics column list.

```text
pg_dump: fatal: could not parse index statistic columns
```

## Related

- [could not parse index statistic values](./could-not-parse-index-statistic-values.md)
- [could not parse numeric array: too many numbers](./could-not-parse-numeric-array-too-many-numbers.md)
