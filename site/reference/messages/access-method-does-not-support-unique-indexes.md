---
message: "access method \"%s\" does not support unique indexes"
slug: access-method-does-not-support-unique-indexes
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:884"
reproduced: true
---

# `access method "%s" does not support unique indexes`

## What it means

A unique index or unique constraint was requested on an access method that cannot enforce uniqueness.

## When it happens

It occurs with `CREATE UNIQUE INDEX ... USING method` or a unique/primary-key constraint when `method` is not one that supports unique enforcement, such as GIN, GiST, BRIN, or (historically) hash.

## How to fix

Use B-tree, which supports unique indexes, for uniqueness and primary keys. Switch the `USING` clause to B-tree, or drop the `UNIQUE` requirement if the chosen method is needed for other reasons.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CREATE UNIQUE INDEX ON repro.child USING gin (amount);
```

Produces:

```text
ERROR:  access method "gin" does not support unique indexes
```

## Related

- [access method does not support exclusion constraints](./access-method-does-not-support-exclusion-constraints.md)
- [access method does not support multicolumn indexes](./access-method-does-not-support-multicolumn-indexes.md)
