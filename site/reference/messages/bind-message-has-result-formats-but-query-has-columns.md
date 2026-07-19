---
message: "bind message has %d result formats but query has %d columns"
slug: bind-message-has-result-formats-but-query-has-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROTOCOL_VIOLATION
    code: "08P01"
call_sites:
  - "postgres/src/backend/tcop/pquery.c:636"
reproduced: false
---

# `bind message has %d result formats but query has %d columns`

## What it means

A Bind message in the extended query protocol declared a number of result-column format codes that does not match the number of columns the query returns. The placeholders are the two counts.

## When it happens

It occurs when a client driver sends a result-format array whose length is not zero, one, or the query's output-column count.

## How to fix

This is a client-driver bug. Send no result format codes, a single code for all columns, or exactly one per output column. Report or update the client library that produced the message.

## Example

*Illustrative* — mismatched result-format and column counts.

```text
ERROR:  bind message has 3 result formats but query has 2 columns
```

## Related

- [bind message has parameter formats but parameters](./bind-message-has-parameter-formats-but-parameters.md)
- [bind message supplies parameters but prepared statement requires](./bind-message-supplies-parameters-but-prepared-statement-requires.md)
