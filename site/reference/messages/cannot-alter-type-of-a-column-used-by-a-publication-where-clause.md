---
message: "cannot alter type of a column used by a publication WHERE clause"
slug: cannot-alter-type-of-a-column-used-by-a-publication-where-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15777"
reproduced: false
---

# `cannot alter type of a column used by a publication WHERE clause`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... TYPE` was blocked because a publication's row filter references the column. The `WHERE` clause of a publication depends on the column's type, so changing it could break the filter.

## When it happens

It occurs when the column being retyped appears in the `WHERE` row filter of a publication that includes the table.

## How to fix

Drop the column from the publication's row filter (or drop it from the publication), alter the column type, then add the row filter back. Review the filter expression so it stays valid against the new type.

## Example

*Illustrative* — a column used in a publication row filter.

```text
ERROR:  cannot alter type of a column used by a publication WHERE clause
```

## Related

- [cannot alter type of a column used by a view or rule](./cannot-alter-type-of-a-column-used-by-a-view-or-rule.md)
- [cannot alter type of a column used in a policy definition](./cannot-alter-type-of-a-column-used-in-a-policy-definition.md)
