---
message: "column \"%s\" specified more than once"
slug: column-specified-more-than-once
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/commands/copy.c:1133"
  - "postgres/src/backend/commands/tablecmds.c:2695"
  - "postgres/src/backend/commands/trigger.c:968"
  - "postgres/src/backend/parser/parse_target.c:1089"
  - "postgres/src/backend/parser/parse_target.c:1100"
reproduced: true
---

# `column "%s" specified more than once`

## What it means

A column name appeared twice in a context that requires distinct columns. The placeholder is the repeated name. `COPY` column lists, `INSERT` target lists, and similar constructs each column may be named only once.

## When it happens

Listing the same column twice in a `COPY (col, col)` list, an `INSERT INTO t (a, a)` target list, an `ON CONFLICT` set, or a similar place where duplicates are not allowed.

## How to fix

Remove the duplicate so each column is listed once. If you meant two different columns, correct the misspelled or repeated name.

## Example

*Reproduced* — captured from `reproducers/scenarios/33_grant_roles_coerce_dml.sql`.

```sql
INSERT INTO repro.parent (id, label, id) VALUES (1, 'x', 2);
```

Produces:

```text
ERROR:  column "id" specified more than once
```

## Related

- [column reference is ambiguous](./column-reference-is-ambiguous.md)
- [conflicting NULL/NOT NULL declarations for column of table](./conflicting-null-not-null-declarations-for-column-of-table.md)
