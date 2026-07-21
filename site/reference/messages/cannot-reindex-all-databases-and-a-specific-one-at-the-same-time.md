---
message: "cannot reindex all databases and a specific one at the same time"
slug: cannot-reindex-all-databases-and-a-specific-one-at-the-same-time
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/scripts/reindexdb.c:222"
reproduced: true
---

# `cannot reindex all databases and a specific one at the same time`

## What it means

`reindexdb` was given both the all-databases option and a specific database name. These targets are mutually exclusive, so the command cannot proceed.

## When it happens

It occurs when `reindexdb --all` is combined with a database name or a `--dbname` argument on the same command line.

## How to fix

Choose one target: use `--all` to reindex every database, or name a single database without `--all`. Run separate commands if you need both scopes.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  cannot reindex all databases and a specific one at the same time
```

## Related

- [cannot specify a database name with --all](./cannot-specify-a-database-name-with-all.md)
- [cannot reindex this type of relation concurrently](./cannot-reindex-this-type-of-relation-concurrently.md)
