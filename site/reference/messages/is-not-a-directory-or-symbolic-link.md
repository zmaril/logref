---
message: "\"%s\" is not a directory or symbolic link"
slug: is-not-a-directory-or-symbolic-link
passthrough: false
api: [ereport]
level: [ERROR]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablespace.c:842"
  - "postgres/src/backend/commands/tablespace.c:927"
reproduced: false
---

# `"%s" is not a directory or symbolic link`

## What it means

A path that must be a directory (or a symbolic link to one) is neither. The placeholder is the path. Some operations require a directory entry there and refuse to proceed otherwise.

## When it happens

It arises from server-side directory operations — tablespace handling, directory listing functions, or file-management routines — when the path names a regular file or does not have the expected type.

## How to fix

Point the operation at an actual directory (or a symlink to one). Verify the path exists and is a directory on the server host, and check permissions and for a stray file at that location.

## Example

*Illustrative* — a file where a directory was expected.

```text
ERROR:  "/data/ts1" is not a directory or symbolic link
```

## Related

- [is a directory](./is-a-directory.md)
- [is not a valid data directory](./is-not-a-valid-data-directory.md)
