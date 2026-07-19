---
message: "bind message has %d parameter formats but %d parameters"
slug: bind-message-has-parameter-formats-but-parameters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/postgres.c:1768"
reproduced: false
---

# `bind message has %d parameter formats but %d parameters`

## What it means

In the extended query protocol, a Bind message declared a number of parameter format codes that does not match the number of parameters it supplies. The placeholders are the two counts. The protocol requires the format-code count to be zero, one, or exactly the number of parameters.

## When it happens

It occurs when a client driver constructs a malformed Bind message, sending a format-code array whose length disagrees with the parameter list.

## How to fix

This is a client-driver bug. Send either no format codes, a single format code applied to all parameters, or one format code per parameter. Update or file a bug against the client library that built the message.

## Example

*Illustrative* — mismatched format and parameter counts.

```text
ERROR:  bind message has 2 parameter formats but 3 parameters
```

## Related

- [bind message has result formats but query has columns](./bind-message-has-result-formats-but-query-has-columns.md)
- [bind message supplies parameters but prepared statement requires](./bind-message-supplies-parameters-but-prepared-statement-requires.md)
