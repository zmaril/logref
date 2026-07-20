---
message: "cursor variable \"%s\" is null"
slug: cursor-variable-is-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4939"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:5027"
reproduced: false
---

# `cursor variable "%s" is null`

## What it means

A PL/pgSQL operation used a cursor variable whose value is null. The `%s` is the variable name. A null `refcursor` does not name a cursor to open, fetch, or close.

## When it happens

Fetching from or closing a `refcursor` variable that was never assigned a name or opened, or one explicitly set to NULL.

## How to fix

Assign the cursor variable before using it — open a bound cursor, or set an unbound `refcursor` to a name — so it is not null when referenced.

## Example

*Illustrative* — fetching from a null refcursor.

```text
ERROR:  cursor variable "c" is null
```

## Related

- [cursor is not positioned on a row](./cursor-is-not-positioned-on-a-row.md)
- [could not open implicit cursor for query](./could-not-open-implicit-cursor-for-query.md)
