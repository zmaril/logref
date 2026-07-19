---
message: "cannot update table \"%s\" because it does not have a replica identity and publishes updates"
slug: cannot-update-table-because-it-does-not-have-a-replica-identity-and-publishes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/executor/execReplication.c:1119"
reproduced: false
---

# `cannot update table "%s" because it does not have a replica identity and publishes updates`

## What it means

An `UPDATE` was attempted on a table that a publication replicates, but the table has no replica identity. Logical replication needs a replica identity to identify which remote rows to update, so the write is blocked.

## When it happens

It occurs when a table is part of a publication that publishes updates and its replica identity is `NOTHING`, or is `DEFAULT` with no primary key.

## How to fix

Give the table a replica identity: add a primary key, or set `ALTER TABLE t REPLICA IDENTITY USING INDEX ...` for a suitable unique index, or `REPLICA IDENTITY FULL` if no unique index fits.

## Example

*Illustrative* — updating a published table without replica identity.

```sql
UPDATE t SET a = 1;
-- ERROR:  cannot update table "t" because it does not have a replica identity and publishes updates
```

## Related

- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
- [cannot use relation as logical replication target](./cannot-use-relation-as-logical-replication-target.md)
