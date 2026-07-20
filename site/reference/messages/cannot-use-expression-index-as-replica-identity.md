---
message: "cannot use expression index \"%s\" as replica identity"
slug: cannot-use-expression-index-as-replica-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19260"
reproduced: false
---

# `cannot use expression index "%s" as replica identity`

## What it means

An `ALTER TABLE ... REPLICA IDENTITY USING INDEX` named an index built on an expression. Replica identity must map directly to stored columns so the subscriber can match rows, and an expression index does not, so it is rejected.

## When it happens

It occurs when setting replica identity to a unique index whose definition includes an expression rather than plain columns.

## How to fix

Choose a unique index over plain columns for the replica identity, or add a primary key. Build a simple-column unique index if none exists and use that.

## Example

*Illustrative* — an expression index as replica identity.

```text
ERROR:  cannot use expression index "t_expr_idx" as replica identity
```

## Related

- [cannot use partial index as replica identity](./cannot-use-partial-index-as-replica-identity.md)
- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
