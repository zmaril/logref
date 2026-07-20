---
message: "duplicate JSON_TABLE column or path name: %s"
slug: duplicate-json-table-column-or-path-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_ALIAS
    code: "42712"
call_sites:
  - "postgres/src/backend/parser/parse_jsontable.c:206"
  - "postgres/src/backend/parser/parse_jsontable.c:220"
reproduced: false
---

# `duplicate JSON_TABLE column or path name: %s`

## What it means

A `JSON_TABLE` definition used the same name twice for a column or a named path. The `%s` is the repeated name. Column and path names within one `JSON_TABLE` must be unique.

## When it happens

Writing a `JSON_TABLE(...)` clause that declares two columns with the same name, or reuses a `PATH ... AS name` label.

## How to fix

Rename the colliding column or path so every name in the `JSON_TABLE` is unique.

## Example

*Illustrative* — two columns share a name.

```text
ERROR:  duplicate JSON_TABLE column or path name: id
```

## Related

- [duplicate JSON object key value](./duplicate-json-object-key-value-07bbf7.md)
- [function has wrong number of declared columns](./function-has-wrong-number-of-declared-columns.md)
