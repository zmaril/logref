---
message: "could not import the requested snapshot"
slug: could-not-import-the-requested-snapshot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/storage/lmgr/predicate.c:1754"
  - "postgres/src/backend/utils/time/snapmgr.c:567"
  - "postgres/src/backend/utils/time/snapmgr.c:573"
reproduced: false
---

# `could not import the requested snapshot`

## What it means

A `SET TRANSACTION SNAPSHOT` (or an internal snapshot import, as in parallel and replication setup) referenced a snapshot that could not be imported. The placeholder-free message means the named snapshot is no longer valid — its exporting transaction ended, or the snapshot identifier does not correspond to an available snapshot.

## When it happens

Importing a snapshot whose exporting session has already ended or rolled back, using a stale snapshot name, or a timing gap between `pg_export_snapshot` and the import that let the snapshot expire.

## How to fix

Keep the exporting transaction open until every importer has run `SET TRANSACTION SNAPSHOT`, and import promptly. Re-export a fresh snapshot if the old one expired. For tools that coordinate this automatically (parallel dump, logical replication), a retry after re-establishing the exporting session usually resolves it.

## Example

*Illustrative* — importing an expired snapshot.

```sql
BEGIN;
SET TRANSACTION SNAPSHOT '00000003-0000001B-1';  -- could not import the requested snapshot
```

## Related

- [logical replication at prepare time requires a callback](./logical-replication-at-prepare-time-requires-a-callback.md)
- [could not obtain lock on relation](./could-not-obtain-lock-on-relation-da8ac5.md)
