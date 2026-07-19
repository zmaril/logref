---
message: "%s cannot be specified multiple times"
slug: cannot-be-specified-multiple-times
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3084"
  - "postgres/src/backend/parser/analyze.c:3094"
reproduced: false
---

# `%s cannot be specified multiple times`

## What it means

A clause or option that may appear at most once in a statement was given more than once. The placeholder names the clause. The parser rejects the duplicate rather than pick one silently.

## When it happens

Writing a query with two of the same single-use clause — for example two `LIMIT` clauses, two `OFFSET`s, or a repeated single-use option in a command — often from string-built SQL that appends a clause already present.

## How to fix

Remove the duplicate so the clause appears once. If the SQL is assembled programmatically, check the code path that adds the clause; it is likely appending a clause the base query already contains.

## Example

*Illustrative* — two LIMIT clauses.

```sql
SELECT * FROM t LIMIT 10 LIMIT 5;
-- ERROR:  multiple LIMIT clauses not allowed
```

## Related

- [cannot be applied to VALUES](./cannot-be-applied-to-values.md)
- [conflicting or redundant WHERE clauses for table](./conflicting-or-redundant-where-clauses-for-table.md)
