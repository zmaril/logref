---
message: "bind message supplies %d parameters, but prepared statement \"%s\" requires %d"
slug: bind-message-supplies-parameters-but-prepared-statement-requires
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:1774"
reproduced: false
---

# `bind message supplies %d parameters, but prepared statement "%s" requires %d`

## What it means

A Bind message provided a different number of parameter values than the prepared statement it binds to expects. The placeholders are the supplied count, the statement name, and the required count.

## When it happens

It occurs when a client binds a prepared statement with the wrong number of parameters — too few or too many for the statement's placeholders.

## How to fix

Supply exactly as many parameter values as the prepared statement has placeholders. This is usually a client-driver or application bug in how parameters are counted or passed; align the bind call with the statement's parameter list.

## Example

*Illustrative* — the wrong parameter count on bind.

```text
ERROR:  bind message supplies 1 parameters, but prepared statement "S_1" requires 2
```

## Related

- [bind message has parameter formats but parameters](./bind-message-has-parameter-formats-but-parameters.md)
- [bind message has result formats but query has columns](./bind-message-has-result-formats-but-query-has-columns.md)
