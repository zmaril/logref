---
message: "conflicting NULL/NOT NULL declarations for column \"%s\" of table \"%s\""
slug: conflicting-null-not-null-declarations-for-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:743"
  - "postgres/src/backend/parser/parse_utilcmd.c:761"
  - "postgres/src/backend/parser/parse_utilcmd.c:869"
  - "postgres/src/backend/parser/parse_utilcmd.c:902"
reproduced: false
---

# `conflicting NULL/NOT NULL declarations for column "%s" of table "%s"`

## What it means

A column definition declared both `NULL` and `NOT NULL` (or two contradictory nullability constraints). The placeholders are the column and table names. A column's nullability must be unambiguous, so contradictory declarations are rejected.

## When it happens

Writing `CREATE TABLE`/`ALTER TABLE` where one column carries conflicting nullability — for example `col int NULL NOT NULL`, or an inherited/merged definition that combines a `NOT NULL` parent constraint with a `NULL` declaration.

## How to fix

Declare each column's nullability once. Choose `NOT NULL` or leave it nullable, and remove the contradictory keyword. When inheritance or `LIKE` is involved, reconcile the child's declaration with the parent's constraints.

## Example

*Illustrative* — contradictory nullability.

```sql
CREATE TABLE t (a int NULL NOT NULL);
```

## Related

- [column specified more than once](./column-specified-more-than-once.md)
- [conkey is not a 1-D smallint array](./conkey-is-not-a-1-d-smallint-array.md)
