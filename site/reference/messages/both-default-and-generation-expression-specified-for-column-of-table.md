---
message: "both default and generation expression specified for column \"%s\" of table \"%s\""
slug: both-default-and-generation-expression-specified-for-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_utilcmd.c:975"
reproduced: true
---

# `both default and generation expression specified for column "%s" of table "%s"`

## What it means

A column definition supplied both a `DEFAULT` clause and a `GENERATED ... AS` expression. A column may have one or the other, since a generated column computes its value and cannot also carry a default. The placeholders name the column and table.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE` when a column definition combines `DEFAULT` with `GENERATED ALWAYS AS (...) STORED`.

## How to fix

Choose one. Keep `DEFAULT` for a plain column whose value can be supplied or defaulted, or keep the generation expression for a computed column, and remove the other clause.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
CREATE TABLE repro.ct10 (a int DEFAULT 1 GENERATED ALWAYS AS (2) STORED);
```

Produces:

```text
ERROR:  both default and generation expression specified for column "a" of table "ct10"
```

## Related

- [both default and identity specified for column of table](./both-default-and-identity-specified-for-column-of-table.md)
- [both identity and generation expression specified for column of table](./both-identity-and-generation-expression-specified-for-column-of-table.md)
