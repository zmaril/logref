---
message: "cannot delete from table \"%s\" because it does not have a replica identity and publishes deletes"
slug: cannot-delete-from-table-because-it-does-not-have-a-replica-identity-and
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/executor/execReplication.c:1125"
reproduced: false
---

# `cannot delete from table "%s" because it does not have a replica identity and publishes deletes`

## What it means

A `DELETE` was blocked because the table is published for logical replication but has no replica identity that lets downstream subscribers identify the deleted rows. Without a usable replica identity, deletes cannot be replicated, so they are refused. The placeholder is the table name.

## When it happens

It occurs when deleting from a table in a publication that publishes deletes, while the table has no primary key and no configured `REPLICA IDENTITY`.

## How to fix

Give the table a replica identity: add a primary key, or set `ALTER TABLE ... REPLICA IDENTITY FULL` or `USING INDEX` on a unique, non-null index. Then deletes can be published.

## Example

*Illustrative* — deleting from a published table without replica identity.

```text
ERROR:  cannot delete from table "t" because it does not have a replica identity and publishes deletes
```

## Related

- [cannot delete from foreign table](./cannot-delete-from-foreign-table.md)
- [cannot delete tuples during a parallel operation](./cannot-delete-tuples-during-a-parallel-operation.md)
