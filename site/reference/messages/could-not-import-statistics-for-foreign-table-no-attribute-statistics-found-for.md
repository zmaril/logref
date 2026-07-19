---
message: "could not import statistics for foreign table \"%s.%s\" --- no attribute statistics found for column \"%s\" of remote table \"%s.%s\""
slug: could-not-import-statistics-for-foreign-table-no-attribute-statistics-found-for
passthrough: false
api: [ereport]
level: [WARNING]
call_sites:
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6099"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6117"
reproduced: false
---

# `could not import statistics for foreign table "%s.%s" --- no attribute statistics found for column "%s" of remote table "%s.%s"`

## What it means

A warning that importing statistics for a foreign table could not find per-column (attribute) statistics for a column on the remote table, so that column's statistics were not imported.

## When it happens

It arises when a foreign table's statistics are imported and the remote side has not analyzed the named column, so no statistics exist to copy.

## Is this a problem?

Run `ANALYZE` on the remote table so the column has statistics, then re-import; or accept default planner estimates for that column. The import continues for columns that do have statistics.

## Example

*Illustrative* — missing remote column statistics.

```text
WARNING:  could not import statistics for foreign table "public.ft" --- no attribute statistics found for column "c1" of remote table "public.t"
```

## Related

- [could not find extended statistics object "%s.%s"](./could-not-find-extended-statistics-object.md)
- [could not find information of kind %u for entry of type %c](./could-not-find-information-of-kind-for-entry-of-type.md)
