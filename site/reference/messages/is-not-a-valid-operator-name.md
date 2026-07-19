---
message: "\"%s\" is not a valid operator name"
slug: is-not-a-valid-operator-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_NAME
    code: "42602"
call_sites:
  - "postgres/src/backend/catalog/pg_operator.c:211"
  - "postgres/src/backend/catalog/pg_operator.c:353"
reproduced: false
---

# `"%s" is not a valid operator name`

## What it means

A string given where an operator name is expected is not a valid operator. Operator names are built from a specific set of symbol characters; the placeholder shows the rejected name.

## When it happens

It arises from `CREATE OPERATOR`, operator references in `CREATE OPERATOR CLASS`/`FAMILY`, or functions that parse operator names, when the name contains characters not allowed in operators or is otherwise malformed.

## How to fix

Use a name composed only of the allowed operator characters (such as `+ - * / < > = ~ ! @ # % ^ & | ` ?`), following the operator-naming rules. If you meant a function or ordinary identifier, use the appropriate command instead.

## Example

*Illustrative* — a name that is not a valid operator.

```sql
CREATE OPERATOR abc (...);  -- 'abc' is not a valid operator name
```

## Related

- [operator cannot be its own negator](./operator-cannot-be-its-own-negator.md)
- [invalid name syntax](./invalid-name-syntax.md)
