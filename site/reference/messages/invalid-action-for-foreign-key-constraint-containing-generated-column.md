---
message: "invalid %s action for foreign key constraint containing generated column"
slug: invalid-action-for-foreign-key-constraint-containing-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10397"
  - "postgres/src/backend/commands/tablecmds.c:10403"
reproduced: false
---

# `invalid %s action for foreign key constraint containing generated column`

## What it means

A foreign key names a referential action (such as `ON UPDATE SET NULL` or `ON DELETE SET DEFAULT`) that is not allowed because the constraint includes a generated column. The `%s` is the action keyword.

## When it happens

It arises when defining a foreign key whose columns include a `GENERATED ALWAYS AS ... STORED` column together with a `SET NULL`, `SET DEFAULT`, or similar action that would have to write that column — which is not permitted, since generated columns cannot be assigned directly.

## How to fix

Choose an action compatible with the generated column — typically `NO ACTION`, `RESTRICT`, or `CASCADE` on delete — or remove the generated column from the foreign key. A generated column cannot participate in `SET NULL`/`SET DEFAULT` because its value is computed, not set.

## Example

*Illustrative* — a set-null action over a generated key column.

```sql
FOREIGN KEY (g) REFERENCES p(id) ON DELETE SET NULL  -- g is generated
```

## Related

- [multiple primary keys for table are not allowed](./multiple-primary-keys-for-table-are-not-allowed.md)
- [not-null constraints on partitioned tables cannot be NO INHERIT](./not-null-constraints-on-partitioned-tables-cannot-be-no-inherit.md)
