---
message: "cannot use relation \"%s.%s\" as logical replication target"
slug: cannot-use-relation-as-logical-replication-target
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/executor/execReplication.c:1146"
reproduced: false
---

# `cannot use relation "%s.%s" as logical replication target`

## What it means

Logical replication tried to apply changes to a relation that cannot be a replication target, such as a view, a foreign table, or another non-ordinary relation. Only ordinary tables can receive replicated rows.

## When it happens

It occurs on the subscriber when the apply worker maps a published table to a local relation that is not a plain table.

## How to fix

Make the local target an ordinary table that matches the published table's shape. Replace a view or foreign table with a real table, or adjust the subscription mapping so it lands on one.

## Example

*Illustrative* — a non-table replication target.

```text
ERROR:  cannot use relation "public.v" as logical replication target
```

## Related

- [cannot update table because it does not have a replica identity and publishes updates](./cannot-update-table-because-it-does-not-have-a-replica-identity-and-publishes.md)
- [cannot update foreign table](./cannot-update-foreign-table.md)
