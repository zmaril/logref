---
message: "COPY (SELECT INTO) is not supported"
slug: copy-select-into-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:961"
reproduced: false
---

# `COPY (SELECT INTO) is not supported`

## What it means

A `COPY (SELECT ... INTO ...) TO ...` was attempted. `SELECT INTO` creates a table as a side effect, which `COPY` cannot wrap, so it is not supported as a copy source.

## When it happens

It happens on `COPY (SELECT ... INTO newtab ...) TO ...`.

## How to fix

Remove the `INTO` clause from the query so it is a plain `SELECT`, and create the table separately if you need one. `COPY` copies query output, not table-creating statements.

## Example

*Illustrative* — COPY over SELECT INTO.

```sql
COPY (SELECT a INTO tmp FROM t) TO STDOUT;
-- ERROR:  COPY (SELECT INTO) is not supported
```

## Related

- [COPY query must not be a utility command](./copy-query-must-not-be-a-utility-command.md)
- [COPY is not supported for](./copy-is-not-supported-for.md)
