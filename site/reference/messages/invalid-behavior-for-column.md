---
message: "invalid %s behavior for column \"%s\""
slug: invalid-behavior-for-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4496"
  - "postgres/src/backend/parser/parse_expr.c:4525"
  - "postgres/src/backend/parser/parse_expr.c:4554"
  - "postgres/src/backend/parser/parse_expr.c:4582"
  - "postgres/src/backend/parser/parse_expr.c:4608"
reproduced: false
---

# `invalid %s behavior for column "%s"`

## What it means

A `JSON_TABLE` column was given an `ON EMPTY`/`ON ERROR` behavior that is not allowed for that column's kind. The placeholders are the behavior keyword and the column name. Different `JSON_TABLE` column types accept different behavior clauses.

## When it happens

Writing a `JSON_TABLE` definition where a column specifies a behavior word — such as `EMPTY ARRAY` or `DEFAULT` — that the column's type (ordinary, `EXISTS`, `FORMAT JSON`) does not permit.

## How to fix

Use a behavior valid for that column kind. Regular columns accept `ERROR`/`NULL`/`DEFAULT <expr>`; `EXISTS` columns accept boolean behaviors; check the `JSON_TABLE` syntax for the specific column type and adjust the clause.

## Example

*Illustrative* — an unsupported behavior on a JSON_TABLE column.

```text
ERROR:  invalid EMPTY ARRAY behavior for column "a"
```

## Related

- [invalid behavior](./invalid-behavior.md)
- [cannot call on a scalar](./cannot-call-on-a-scalar.md)
