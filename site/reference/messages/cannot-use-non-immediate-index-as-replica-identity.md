---
message: "cannot use non-immediate index \"%s\" as replica identity"
slug: cannot-use-non-immediate-index-as-replica-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19254"
reproduced: false
---

# `cannot use non-immediate index "%s" as replica identity`

## What it means

An `ALTER TABLE ... REPLICA IDENTITY USING INDEX` named an index whose uniqueness is not enforced immediately, such as a deferrable unique index. Replica identity requires an immediately enforced unique index, so this one is rejected.

## When it happens

It occurs when setting replica identity to a unique index that was created `DEFERRABLE` or `INITIALLY DEFERRED`.

## How to fix

Use a non-deferrable unique index or a primary key for the replica identity. Recreate the index without the deferrable option if it must serve this role.

## Example

*Illustrative* — a deferrable index as replica identity.

```text
ERROR:  cannot use non-immediate index "t_idx" as replica identity
```

## Related

- [cannot use non-unique index as replica identity](./cannot-use-non-unique-index-as-replica-identity.md)
- [cannot use expression index as replica identity](./cannot-use-expression-index-as-replica-identity.md)
