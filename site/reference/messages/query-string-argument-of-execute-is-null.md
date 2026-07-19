---
message: "query string argument of EXECUTE is null"
slug: query-string-argument-of-execute-is-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3661"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4560"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:9082"
reproduced: false
---

# `query string argument of EXECUTE is null`

## What it means

A PL/pgSQL `EXECUTE` statement was handed a null query string. `EXECUTE` runs the text it is given as SQL, and null is not runnable text, so it is rejected.

## When it happens

Building the query string for a dynamic `EXECUTE` from an expression that evaluated to `NULL` — often a concatenation where one operand was null, which makes the whole string null.

## How to fix

Ensure the query string is non-null. Guard the components with `COALESCE`, or use `format()` to assemble the statement, which handles values more safely than raw concatenation. Check any variable interpolated into the string that could be null.

## Example

*Illustrative* — a null concatenated into the query text.

```sql
EXECUTE 'SELECT ' || maybe_null;  -- whole string becomes null
```

## Related

- [query returned more than one row](./query-returned-more-than-one-row.md)
- [no query buffer](./no-query-buffer.md)
