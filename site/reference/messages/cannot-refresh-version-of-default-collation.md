---
message: "cannot refresh version of default collation"
slug: cannot-refresh-version-of-default-collation
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:445"
reproduced: false
---

# `cannot refresh version of default collation`

## What it means

An `ALTER COLLATION ... REFRESH VERSION` targeted the default collation. The default collation follows the database's `LC_COLLATE`/`datcollversion` setting rather than a stored per-collation version, so it has no version to refresh here.

## When it happens

It occurs when `ALTER COLLATION pg_catalog."default" REFRESH VERSION` is run.

## How to fix

Refresh named collations rather than the default. To address a default-collation version mismatch, use the database-level mechanism — for example `ALTER DATABASE ... REFRESH COLLATION VERSION` — after reviewing whether reindexing is needed.

## Example

*Illustrative* — refreshing the default collation's version.

```text
ERROR:  cannot refresh version of default collation
```

## Related

- [cannot refresh materialized view concurrently](./cannot-refresh-materialized-view-concurrently.md)
- [cannot set comment on relation](./cannot-set-comment-on-relation.md)
