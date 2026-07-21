---
message: "invalid list syntax in parameter \"%s\""
slug: invalid-list-syntax-in-parameter
passthrough: false
api: [ereport]
level: [ERROR, FATAL, LOG]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:132"
  - "postgres/src/backend/libpq/auth-oauth.c:885"
  - "postgres/src/backend/postmaster/postmaster.c:1143"
  - "postgres/src/backend/postmaster/postmaster.c:1245"
  - "postgres/src/backend/utils/init/miscinit.c:1819"
reproduced: false
---

# `invalid list syntax in parameter "%s"`

## What it means

A configuration parameter that expects a comma-separated list could not be parsed as one. The placeholder is the parameter name. GUCs like `search_path`, `listen_addresses`, or publication/subscription list options accept a specific list syntax, and malformed input is rejected.

## When it happens

Setting a list-valued parameter with bad syntax — unbalanced quotes, stray separators, or invalid identifiers — via `SET`, `postgresql.conf`, `ALTER SYSTEM`, or a per-object option that takes a column/name list.

## How to fix

Write the value as a proper comma-separated list, quoting elements that need it with double quotes and separating them with commas only. Check for a trailing comma, mismatched quotes, or embedded newlines. Reload after fixing a config-file value.

## Example

*Illustrative* — a malformed list value.

```sql
SET search_path = 'a,,b';
```

## Related

- [invalid value for parameter](./could-not-parse-value-for-parameter.md)
- [argument to option must be a list of column names](./argument-to-option-must-be-a-list-of-column-names.md)
