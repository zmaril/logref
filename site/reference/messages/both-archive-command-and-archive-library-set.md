---
message: "both \"archive_command\" and \"archive_library\" set"
slug: both-archive-command-and-archive-library-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/postmaster/pgarch.c:882"
  - "postgres/src/backend/postmaster/pgarch.c:921"
reproduced: false
---

# `both "archive_command" and "archive_library" set`

## What it means

The server was configured with both an archive command and an archive library at once. WAL archiving can be driven by one mechanism or the other, not both, so setting both is ambiguous and rejected.

## When it happens

Configuring `archive_command` and `archive_library` both to non-empty values, then reloading or starting the server with archiving active.

## How to fix

Choose one archiving mechanism. Clear `archive_command` if you want a library-based archiver, or clear `archive_library` if you want a shell command, then reload the configuration. Only one of the two may be set at a time.

## Example

*Illustrative* — both archiving methods configured.

```text
ERROR:  both "archive_command" and "archive_library" set
```

## Related

- [archive command was terminated by signal](./archive-command-was-terminated-by-signal.md)
- [invalid value for option](./invalid-value-for-option.md)
