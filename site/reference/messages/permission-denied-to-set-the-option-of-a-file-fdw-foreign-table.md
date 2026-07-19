---
message: "permission denied to set the \"%s\" option of a file_fdw foreign table"
slug: permission-denied-to-set-the-option-of-a-file-fdw-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/contrib/file_fdw/file_fdw.c:289"
  - "postgres/contrib/file_fdw/file_fdw.c:298"
reproduced: false
---

# `permission denied to set the "%s" option of a file_fdw foreign table`

## What it means

A non-superuser tried to set a `file_fdw` foreign-table option that only superusers (or roles with the right privilege) may set. The placeholder is the option name. Options such as the file path let a table read arbitrary server files, so they are restricted.

## When it happens

It arises from `CREATE`/`ALTER FOREIGN TABLE` on a `file_fdw` table by a role lacking the privilege to set the sensitive option — historically the `filename`/`program` options.

## How to fix

Set the restricted option as a superuser, or grant the appropriate privilege on the foreign-data wrapper. In modern versions, membership in `pg_read_server_files` (or the relevant privilege) can permit some file-access options; use that rather than broad superuser where possible.

## Example

*Illustrative* — setting a restricted file_fdw option as a non-superuser.

```text
ERROR:  permission denied to set the "filename" option of a file_fdw foreign table
```

## Related

- [permission denied to change owner of foreign-data wrapper "%s"](./permission-denied-to-change-owner-of-foreign-data-wrapper.md)
- [option "%s" not found](./option-not-found.md)
