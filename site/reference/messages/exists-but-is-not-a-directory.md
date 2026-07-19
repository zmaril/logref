---
message: "\"%s\" exists but is not a directory"
slug: exists-but-is-not-a-directory
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:193"
  - "postgres/src/backend/commands/tablespace.c:650"
reproduced: false
---

# `"%s" exists but is not a directory`

## What it means

A path that must be a directory already exists as a non-directory (a plain file). The `%s` is the path. Postgres cannot use it — for example as a tablespace location.

## When it happens

Creating a tablespace or similar object whose target path is occupied by a regular file rather than a directory.

## How to fix

Point the operation at an actual directory, or remove the conflicting file and create the directory. Ensure the tablespace location is an empty directory owned by the server user.

## Example

*Illustrative* — the tablespace path is a file.

```text
ERROR:  "/mnt/space/pg" exists but is not a directory
```

## Related

- [could not stat directory](./could-not-stat-directory.md)
- [could not set permissions on directory](./could-not-set-permissions-on-directory.md)
