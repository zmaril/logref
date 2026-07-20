---
message: "cannot execute %s on temporary tables of other sessions"
slug: cannot-execute-on-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/repack.c:601"
  - "postgres/src/backend/commands/repack.c:2417"
reproduced: false
---

# `cannot execute %s on temporary tables of other sessions`

## What it means

A maintenance command (such as `REPACK`, `CLUSTER`, or `VACUUM FULL`) targeted a temporary table belonging to a different session. The placeholder is the command. A session cannot run these operations on another session's private temporary tables.

## When it happens

Naming another backend's temporary table — typically through a database-wide or schema-wide maintenance command that reaches temp tables of other sessions.

## How to fix

Restrict the maintenance command to your own tables and your own session's temporary tables. Other sessions' temporary tables are inaccessible for these operations and will be maintained by their owning sessions.

## Example

*Illustrative* — repacking another session's temp table.

```text
ERROR:  cannot execute REPACK on temporary tables of other sessions
```

## Related

- [cannot create relations in temporary schemas of other sessions](./cannot-create-relations-in-temporary-schemas-of-other-sessions.md)
- [cannot reindex while reindexing](./cannot-reindex-while-reindexing.md)
