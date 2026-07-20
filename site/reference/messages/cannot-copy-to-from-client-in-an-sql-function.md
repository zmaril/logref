---
message: "cannot COPY to/from client in an SQL function"
slug: cannot-copy-to-from-client-in-an-sql-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/executor/functions.c:736"
reproduced: false
---

# `cannot COPY to/from client in an SQL function`

## What it means

A `COPY ... TO STDOUT` or `COPY ... FROM STDIN` was issued inside an SQL-language function. Client-facing `COPY` streams data over the frontend connection, which a function body cannot do. Only server-side `COPY` (to or from a file or program) is possible there.

## When it happens

It occurs when an SQL function contains a `COPY` that targets the client rather than a file.

## How to fix

Move the client `COPY` to the top level of the session where it can stream to the client, or use a server-side `COPY TO/FROM` file inside the function. Functions cannot exchange `COPY` data with the client.

## Example

*Illustrative* — client COPY in a function.

```text
ERROR:  cannot COPY to/from client in an SQL function
```

## Related

- [cannot copy to view](./cannot-copy-to-view.md)
- [cannot be executed from a function or procedure](./cannot-be-executed-from-a-function-or-procedure.md)
