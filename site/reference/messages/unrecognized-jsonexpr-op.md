---
message: "unrecognized JsonExpr op: %d"
slug: unrecognized-jsonexpr-op
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/parser/parse_target.c:2023"
  - "postgres/src/backend/utils/adt/ruleutils.c:11135"
reproduced: false
---

# `unrecognized JsonExpr op: %d`

## What it means

Internal error. Executor code for SQL/JSON expressions met a `JsonExpr` operation code (the `JSON_VALUE`/`JSON_QUERY`/`JSON_EXISTS` selector) it does not handle.

## When it happens

It fires where a JSON expression's operation is switched on and the value is outside the known set. A valid SQL/JSON query does not produce it.

## How to fix

This is an internal guard. If a real SQL/JSON query triggers it, capture the query and report it as a reproducible bug.

## Example

*Illustrative* — an unhandled JsonExpr op.

```text
ERROR:  unrecognized JsonExpr op: 5
```

## Related

- [unrecognized jsonb type: %d](./unrecognized-jsonb-type.md)
- [unexpected jsonb value type: %d](./unexpected-jsonb-value-type-92f4ff.md)
