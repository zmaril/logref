---
message: "cannot COPY to/from client in PL/pgSQL"
slug: cannot-copy-to-from-client-in-pl-pgsql
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4433"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:4623"
reproduced: false
---

# `cannot COPY to/from client in PL/pgSQL`

## What it means

A PL/pgSQL function ran a `COPY ... TO STDOUT` or `COPY ... FROM STDIN`, which streams data to or from the client connection. A function body has no client stream to talk to, so this form of `COPY` is not allowed inside PL/pgSQL.

## When it happens

Embedding `COPY tbl TO STDOUT` or `COPY tbl FROM STDIN` in a PL/pgSQL function or `DO` block.

## How to fix

Move client-facing `COPY` to the top-level session where a client stream exists, or use `COPY ... TO/FROM 'file'` (server-side files, requires privilege) inside the function. To move data within a function, use plain `INSERT ... SELECT` instead of `COPY`.

## Example

*Illustrative* — COPY to STDOUT inside a function.

```sql
CREATE FUNCTION f() RETURNS void AS $$ BEGIN COPY t TO STDOUT; END $$ LANGUAGE plpgsql;
-- ERROR:  cannot COPY to/from client in PL/pgSQL
```

## Related

- [cannot copy from foreign table](./cannot-copy-from-foreign-table.md)
- [COPY from stdin failed](./copy-from-stdin-failed.md)
