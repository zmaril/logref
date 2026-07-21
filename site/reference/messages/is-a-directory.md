---
message: "\"%s\" is a directory"
slug: is-a-directory
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:1917"
  - "postgres/src/backend/commands/copyto.c:1220"
reproduced: false
---

# `"%s" is a directory`

## What it means

A path that was expected to name a file actually refers to a directory. The operation needs a regular file, so it stops. The placeholder is the offending path.

## When it happens

It arises from server-side file operations — `COPY ... FROM/TO 'path'`, `pg_read_file`, large-object import/export, or extension file access — when the given path is a directory rather than a file.

## How to fix

Point the operation at a regular file, not a directory. Append the file name to the path, and check the value for a trailing slash or a variable that resolved to a directory.

## Example

*Illustrative* — copying to a directory path.

```sql
COPY t TO '/var/tmp';  -- /var/tmp is a directory
```

## Related

- [is not a directory or symbolic link](./is-not-a-directory-or-symbolic-link.md)
- [is not a valid data directory](./is-not-a-valid-data-directory.md)
