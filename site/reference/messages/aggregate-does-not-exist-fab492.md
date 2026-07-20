---
message: "aggregate %s does not exist"
slug: aggregate-does-not-exist-fab492
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_func.c:2560"
reproduced: false
---

# `aggregate %s does not exist`

## What it means

A statement referred to an aggregate function that does not exist with a signature matching the arguments supplied, in any schema on the search path.

## When it happens

It occurs when calling an aggregate whose name is misspelled, whose argument types do not match a defined aggregate, or which lives in a schema not on the search path.

## How to fix

Verify the aggregate name and the argument types you pass. List available aggregates with `\da` in psql, cast arguments to match a defined signature, and schema-qualify the name or adjust the search path if needed.

## Example

*Illustrative* — a call that matches no aggregate signature.

```sql
SELECT median(name) FROM t;  -- ERROR:  aggregate median(text) does not exist
```

## Related

- [aggregate %s(*) does not exist](./aggregate-does-not-exist-80650f.md)
- [aggregate name is not unique](./aggregate-name-is-not-unique.md)
