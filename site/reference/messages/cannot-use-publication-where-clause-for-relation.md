---
message: "cannot use publication WHERE clause for relation \"%s\""
slug: cannot-use-publication-where-clause-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:733"
reproduced: false
---

# `cannot use publication WHERE clause for relation "%s"`

## What it means

A publication row filter with a `WHERE` clause was applied to a relation that cannot carry one, such as a table that is added only as part of a schema or a target that does not support row filtering.

## When it happens

It occurs on `CREATE PUBLICATION` or `ALTER PUBLICATION` when a `WHERE` clause is attached to a relation that does not accept a row filter.

## How to fix

Remove the `WHERE` clause for that relation, or add the table individually as a plain table target where a row filter is permitted rather than through a schema-level entry.

## Example

*Illustrative* — a row filter on an unsupported target.

```text
ERROR:  cannot use publication WHERE clause for relation "t"
```

## Related

- [cannot use a WHERE clause when removing a table from a publication](./cannot-use-a-where-clause-when-removing-a-table-from-a-publication.md)
- [cannot use different values of publish_generated_columns for table in different](./cannot-use-different-values-of-publish-generated-columns-for-table-in-different.md)
