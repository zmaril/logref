---
message: "COPY %s is not supported for %s"
slug: copy-is-not-supported-for
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/copy.c:994"
reproduced: false
---

# `COPY %s is not supported for %s`

## What it means

A `COPY` was attempted against an object kind or in a direction that is not supported. The message names what was tried; `COPY` only works with tables and, for `TO`, queries.

## When it happens

It happens on `COPY` against something that cannot be copied that way, such as certain object kinds or an unsupported direction for the target.

## How to fix

Copy from or to a supported object. For output, use `COPY (query) TO ...`; for tables, ensure the direction is valid for that table kind. Redesign the operation around a plain table or query.

## Example

*Illustrative* — COPY against an unsupported target.

```text
ERROR:  COPY TO is not supported for foreign tables
```

## Related

- [COPY (SELECT INTO) is not supported](./copy-select-into-is-not-supported.md)
- [COPY query must not be a utility command](./copy-query-must-not-be-a-utility-command.md)
