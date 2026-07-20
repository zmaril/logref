---
message: "table \"%s\" has %d columns available but %d columns specified"
slug: table-has-columns-available-but-columns-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1277"
  - "postgres/src/backend/parser/parse_relation.c:1726"
  - "postgres/src/backend/parser/parse_relation.c:2515"
reproduced: false
---

# `table "%s" has %d columns available but %d columns specified`

## What it means

A column alias list gave more column names than the table or function output actually has. When you rename columns with an alias list, the number of aliases must not exceed the number of available columns, and it did.

## When it happens

Writing a `FROM` item with a parenthesized column alias list — `tbl(a, b, c)` or a function `f() AS t(a, b, c)` — that names more columns than the source produces.

## How to fix

Match the alias list to the number of columns the source provides. Remove the extra aliases, or check that the function or subquery returns as many columns as you are naming. The message reports both counts, which shows how many to drop.

## Example

*Illustrative* — too many column aliases.

```sql
SELECT * FROM (VALUES (1, 2)) AS t(a, b, c);  -- 2 columns available, 3 specified
```

## Related

- [invalid reference to from-clause entry for table](./invalid-reference-to-from-clause-entry-for-table.md)
- [a column definition list is required for functions returning record](./a-column-definition-list-is-required-for-functions-returning-record.md)
