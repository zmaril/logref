---
message: "publication \"%s\" does not exist"
slug: publication-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:1669"
  - "postgres/src/backend/commands/publicationcmds.c:1709"
  - "postgres/src/backend/commands/publicationcmds.c:2243"
  - "postgres/src/backend/utils/cache/lsyscache.c:3993"
reproduced: false
---

# `publication "%s" does not exist`

## What it means

A command referenced a publication name that does not exist in the current database. The placeholder is the name. Publications are the publisher-side objects that define which tables a logical replication stream carries; a subscriber or an `ALTER PUBLICATION` that names a missing one cannot proceed.

## When it happens

`CREATE`/`ALTER SUBSCRIPTION ... PUBLICATION x`, `ALTER PUBLICATION x ...`, or `DROP PUBLICATION x` where `x` is misspelled, was dropped, or lives in a different database than the one you are connected to.

## How to fix

List existing publications with `\dRp` (or `SELECT pubname FROM pg_publication`) and use the correct name. Publications are per-database — connect to the database that owns the publication. On the subscriber side, the name must match a publication that exists on the publisher, not locally.

## Example

*Illustrative* — subscribing to a missing publication.

```sql
ALTER SUBSCRIPTION s SET PUBLICATION missing_pub;
```

## Related

- [subscription could not connect to the publisher](./subscription-could-not-connect-to-the-publisher.md)
- [cannot use different column lists for table in different publications](./cannot-use-different-column-lists-for-table-in-different-publications.md)
