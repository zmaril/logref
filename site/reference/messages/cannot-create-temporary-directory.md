---
message: "cannot create temporary directory \"%s\": %m"
slug: cannot-create-temporary-directory
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:1661"
reproduced: false
---

# `cannot create temporary directory "%s": %m`

## What it means

A tool could not create a temporary working directory it needs. The placeholders are the directory path and the operating-system error. The failure comes from the filesystem — permissions, a missing parent, or no space.

## When it happens

It occurs in utilities such as backup or upgrade tools when the temporary directory they attempt to create cannot be made.

## How to fix

Check that the parent directory exists, is writable by the running user, and has free space. Correct the permissions or path, or point the tool at a usable temporary location, then retry.

## Example

*Illustrative* — a temp directory that cannot be made.

```text
error: cannot create temporary directory "/tmp/x": Permission denied
```

## Related

- [cannot create temporary subdirectory](./cannot-create-temporary-subdirectory.md)
- [cannot copy from/to a directory](./cannot-copy-from-to-a-directory.md)
