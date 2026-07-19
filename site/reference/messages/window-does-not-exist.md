---
message: "window \"%s\" does not exist"
slug: window-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:1098"
  - "postgres/src/backend/parser/parse_clause.c:3010"
reproduced: false
---

# `window "%s" does not exist`

## What it means

A window function or `OVER` clause referred to a named window that is not defined in the query's `WINDOW` clause.

## When it happens

It arises from `OVER <name>` when `<name>` was never declared, or is misspelled, in the statement's `WINDOW` list.

## How to fix

Define the window in a `WINDOW <name> AS (...)` clause and reference the exact name, or replace `OVER <name>` with an inline `OVER (...)` definition. Check spelling against the `WINDOW` clause.

## Example

*Illustrative* — referencing an undefined window.

```text
ERROR:  window "w" does not exist
```

## Related

- [window function calls cannot be nested](./window-function-calls-cannot-be-nested.md)
- [window functions are not allowed in %s](./window-functions-are-not-allowed-in.md)
