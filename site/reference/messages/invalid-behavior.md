---
message: "invalid %s behavior"
slug: invalid-behavior
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4486"
  - "postgres/src/backend/parser/parse_expr.c:4515"
  - "postgres/src/backend/parser/parse_expr.c:4546"
  - "postgres/src/backend/parser/parse_expr.c:4572"
  - "postgres/src/backend/parser/parse_expr.c:4598"
  - "postgres/src/backend/parser/parse_jsontable.c:102"
reproduced: false
---

# `invalid %s behavior`

## What it means

A SQL/JSON query function was given an `ON EMPTY` or `ON ERROR` behavior clause that is not legal in that position. The placeholder names the behavior keyword. Each JSON function accepts only a subset of the behavior words, and this rejects one that does not belong.

## When it happens

Writing `JSON_VALUE`, `JSON_QUERY`, `JSON_TABLE`, or `JSON_EXISTS` with a behavior clause whose keyword the function does not allow — for example an `EMPTY ARRAY` default where only scalar behaviors are permitted.

## How to fix

Use a behavior valid for that function: `ERROR`, `NULL`, `DEFAULT <expr>`, `EMPTY ARRAY`, `EMPTY OBJECT`, `TRUE`, `FALSE`, or `UNKNOWN`, as the function allows. Consult the SQL/JSON function's syntax for which behaviors apply to `ON EMPTY` versus `ON ERROR`.

## Example

*Illustrative* — an unsupported behavior on a JSON function.

```sql
SELECT JSON_VALUE('1', '$' EMPTY ON ERROR);
```

## Related

- [invalid behavior for column](./invalid-behavior-for-column.md)
- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
