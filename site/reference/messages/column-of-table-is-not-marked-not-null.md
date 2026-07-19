---
message: "column \"%s\" of table \"%s\" is not marked NOT NULL"
slug: column-of-table-is-not-marked-not-null
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9687"
reproduced: false
---

# `column "%s" of table "%s" is not marked NOT NULL`

## What it means

An internal check found that a column expected to carry a `NOT NULL` marking does not have one. This guards an operation (such as identity or primary-key handling) that relies on the column being non-null.

## When it happens

It fires from table-command internals when a prerequisite `NOT NULL` is missing on a column at a point where the code assumed it was already set.

## How to fix

In normal use this is reached only through the higher-level errors that ask you to mark the column `NOT NULL` first. Add the `NOT NULL` constraint on the column and retry the original operation; if it appears on its own, treat it as an internal inconsistency to investigate.

## Example

*Illustrative* — a missing NOT NULL marking behind an identity or key operation.

```text
ERROR:  column "id" of table "t" is not marked NOT NULL
```

## Related

- [column of relation must be declared NOT NULL before identity can be added](./column-of-relation-must-be-declared-not-null-before-identity-can-be-added.md)
- [column of table contains null values](./column-of-table-contains-null-values.md)
