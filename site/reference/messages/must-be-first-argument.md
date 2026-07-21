---
message: "--%s must be first argument"
slug: must-be-first-argument
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/bootstrap/bootstrap.c:278"
  - "postgres/src/backend/postmaster/postmaster.c:629"
  - "postgres/src/backend/tcop/postgres.c:4036"
reproduced: false
---

# `--%s must be first argument`

## What it means

A command-line option that has to appear before any other argument was found later in the argument list. Some bootstrap and postmaster options are only meaningful as the first argument, and this one was not.

## When it happens

Starting the server or a bootstrap process with an ordering-sensitive option placed after other arguments, typically from a hand-written or generated command line that put the flags in the wrong order.

## How to fix

Move the option to the front of the argument list so it precedes every other argument. Check the wrapper or service definition that assembles the command line if the ordering is generated.

## Example

*Illustrative* — an order-sensitive option placed too late.

```text
postgres -D /data --boot  # --boot must be the first argument
```

## Related

- [requires a value](./requires-a-value.md)
- [requires an integer value](./requires-an-integer-value.md)
