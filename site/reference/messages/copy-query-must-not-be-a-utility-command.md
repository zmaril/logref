---
message: "COPY query must not be a utility command"
slug: copy-query-must-not-be-a-utility-command
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/copyto.c:967"
reproduced: false
---

# `COPY query must not be a utility command`

## What it means

A `COPY (query) TO ...` wrapped a utility command (such as a DDL or `EXPLAIN` statement) rather than a `SELECT` or data-modifying statement with `RETURNING`. `COPY` can only copy the output of a data-producing query.

## When it happens

It happens on `COPY (utility-statement) TO ...`, for example `COPY (VACUUM) TO ...` or `COPY (SHOW ...) TO ...`.

## How to fix

Use a `SELECT` (or a data-modifying statement with `RETURNING`) in the `COPY` query. Utility commands cannot be a `COPY` source.

## Example

*Illustrative* — COPY over a utility command.

```sql
COPY (SHOW work_mem) TO STDOUT;
-- ERROR:  COPY query must not be a utility command
```

## Related

- [COPY query must have a RETURNING clause](./copy-query-must-have-a-returning-clause.md)
- [COPY (SELECT INTO) is not supported](./copy-select-into-is-not-supported.md)
