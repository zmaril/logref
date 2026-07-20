---
message: "invalid option \"%s\""
slug: invalid-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FDW_INVALID_OPTION_NAME
    code: "HV00D"
  - symbol: ERRCODE_FDW_OPTION_NAME_NOT_FOUND
    code: "HV00J"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/contrib/dblink/dblink.c:1990"
  - "postgres/contrib/file_fdw/file_fdw.c:247"
  - "postgres/contrib/postgres_fdw/option.c:105"
  - "postgres/contrib/postgres_fdw/postgres_fdw.c:6368"
  - "postgres/src/backend/foreign/foreign.c:690"
reproduced: false
---

# `invalid option "%s"`

## What it means

An option name given to a command or foreign-data object is not one it accepts. The placeholder is the option. Foreign-data wrappers, `dblink`, and various commands validate option names against a fixed list and reject unknown ones (with FDW-specific SQLSTATEs where applicable).

## When it happens

Passing a misspelled or unsupported option in `CREATE/ALTER SERVER`, `USER MAPPING`, `FOREIGN TABLE`, a `dblink` connection string, or a similar options list — or an option valid for a different wrapper than the one in use.

## How to fix

Check the accepted option names for the specific wrapper or command and correct the spelling. Each FDW documents its own option set (for example `postgres_fdw` versus `file_fdw`); an option valid for one is rejected by another.

## Example

*Illustrative* — an unknown FDW option.

```sql
CREATE SERVER s FOREIGN DATA WRAPPER postgres_fdw OPTIONS (hostname 'db');  -- option is host
```

## Related

- [unrecognized option](./unrecognized-option-8eb055.md)
- [invalid list syntax in parameter](./invalid-list-syntax-in-parameter.md)
