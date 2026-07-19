---
message: "cannot use non-unique index \"%s\" as replica identity"
slug: cannot-use-non-unique-index-as-replica-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19248"
reproduced: false
---

# `cannot use non-unique index "%s" as replica identity`

## What it means

An `ALTER TABLE ... REPLICA IDENTITY USING INDEX` named an index that is not unique. Replica identity must identify each row uniquely so the subscriber can match it, so a non-unique index cannot serve that role.

## When it happens

It occurs when setting replica identity to an index built without `UNIQUE`.

## How to fix

Use a unique index or a primary key for the replica identity. Create a unique index over columns that identify rows, or set `REPLICA IDENTITY FULL` if no unique key exists.

## Example

*Illustrative* — a non-unique index as replica identity.

```text
ERROR:  cannot use non-unique index "t_idx" as replica identity
```

## Related

- [cannot use non-immediate index as replica identity](./cannot-use-non-immediate-index-as-replica-identity.md)
- [cannot use partial index as replica identity](./cannot-use-partial-index-as-replica-identity.md)
