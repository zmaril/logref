---
message: "invalid JSON_TABLE plan clause"
slug: invalid-json-table-plan-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_jsontable.c:302"
  - "postgres/src/backend/parser/parse_jsontable.c:641"
  - "postgres/src/backend/parser/parse_jsontable.c:800"
reproduced: false
---

# `invalid JSON_TABLE plan clause`

## What it means

The `PLAN` clause of a `JSON_TABLE` expression was not valid. The plan clause names how the nested path columns are joined, and it must reference the paths declared in the expression in a consistent way; this one did not.

## When it happens

Writing a `JSON_TABLE(...)` with an explicit `PLAN` or `PLAN DEFAULT` clause whose structure references a path name that was not declared, or combines the paths in a way the syntax does not allow.

## How to fix

Align the `PLAN` clause with the path names declared in the `COLUMNS` list. Every path referenced in the plan must be declared, and nested paths must be joined in a shape the grammar accepts. If the default join is what you want, drop the explicit plan and let `JSON_TABLE` derive it.

## Example

*Illustrative* — a plan clause referencing an undeclared path.

```sql
SELECT * FROM JSON_TABLE('{}', '$' COLUMNS (a int PATH '$.a') PLAN (nope));
```

## Related

- [total size of jsonb object elements exceeds the maximum](./total-size-of-jsonb-object-elements-exceeds-the-maximum-of-bytes.md)
- [invalid value for option](./invalid-value-for-option.md)
