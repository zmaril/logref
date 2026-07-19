---
message: "could not find extended statistics object \"%s.%s\""
slug: could-not-find-extended-statistics-object
passthrough: false
api: [ereport]
level: [WARNING]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/statistics/extended_stats_funcs.c:414"
  - "postgres/src/backend/statistics/extended_stats_funcs.c:1809"
reproduced: false
---

# `could not find extended statistics object "%s.%s"`

## What it means

A warning that an operation looked up an extended-statistics object by name and could not find it in the catalog.

## When it happens

It arises during statistics import (for example `pg_restore`/`pg_dump` handling of extended statistics) or a stats operation when the named `CREATE STATISTICS` object is absent on the target.

## Is this a problem?

Usually the operation continues without the statistics. If the object should exist, create it with `CREATE STATISTICS` before importing, or accept that the planner will fall back to default estimates until statistics are rebuilt.

## Example

*Illustrative* — a missing extended-statistics object.

```text
WARNING:  could not find extended statistics object "public.s1"
```

## Related

- [could not find schema "%s"](./could-not-find-schema.md)
- [could not import statistics for foreign table "%s.%s" --- no attribute statistics found for column "%s" of remote table "%s.%s"](./could-not-import-statistics-for-foreign-table-no-attribute-statistics-found-for.md)
