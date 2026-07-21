---
message: "cannot use partial index \"%s\" as replica identity"
slug: cannot-use-partial-index-as-replica-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19266"
reproduced: false
---

# `cannot use partial index "%s" as replica identity`

## What it means

An `ALTER TABLE ... REPLICA IDENTITY USING INDEX` named a partial index, one built with a `WHERE` clause. A partial index covers only some rows, so it cannot identify every row and is rejected as a replica identity.

## When it happens

It occurs when setting replica identity to a unique index that has a `WHERE` predicate.

## How to fix

Use a full unique index or a primary key for the replica identity. Build a non-partial unique index over the identifying columns and use that instead.

## Example

*Illustrative* — a partial index as replica identity.

```text
ERROR:  cannot use partial index "t_idx" as replica identity
```

## Related

- [cannot use expression index as replica identity](./cannot-use-expression-index-as-replica-identity.md)
- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
