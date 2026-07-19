---
message: "foreign-data wrapper \"%s\" has no handler"
slug: foreign-data-wrapper-has-no-handler
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:1611"
  - "postgres/src/backend/foreign/foreign.c:434"
reproduced: false
---

# `foreign-data wrapper "%s" has no handler`

## What it means

An operation needed the handler function of a foreign-data wrapper, and the wrapper was created without one. The `%s` is the wrapper name. A wrapper with no `HANDLER` cannot access foreign tables.

## When it happens

Querying a foreign table whose foreign server uses a wrapper defined `NO HANDLER` (or created without a handler), such as a placeholder wrapper.

## How to fix

Recreate or alter the foreign-data wrapper with a valid `HANDLER` function (for example the one supplied by the FDW extension). Install the FDW extension that provides the handler if it is missing.

## Example

*Illustrative* — a wrapper without a handler.

```text
ERROR:  foreign-data wrapper "dummy" has no handler
```

## Related

- [either filename or program is required for file_fdw foreign tables](./either-filename-or-program-is-required-for-file-fdw-foreign-tables.md)
- [foreign table does not exist](./foreign-table-does-not-exist.md)
