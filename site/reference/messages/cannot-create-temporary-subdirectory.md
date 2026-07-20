---
message: "cannot create temporary subdirectory \"%s\": %m"
slug: cannot-create-temporary-subdirectory
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/fd.c:1668"
reproduced: false
---

# `cannot create temporary subdirectory "%s": %m`

## What it means

A tool could not create a subdirectory inside its temporary working area. The placeholders are the subdirectory path and the operating-system error. As with the parent case, the failure comes from the filesystem.

## When it happens

It occurs in utilities that build a nested temporary structure when a subdirectory cannot be created — usually permissions or space.

## How to fix

Ensure the temporary area is writable and has free space, then retry. Fix the permissions or free disk space on the volume holding the temporary directory.

## Example

*Illustrative* — a temp subdirectory that cannot be made.

```text
error: cannot create temporary subdirectory "/tmp/x/y": No space left on device
```

## Related

- [cannot create temporary directory](./cannot-create-temporary-directory.md)
- [cannot copy from/to a directory](./cannot-copy-from-to-a-directory.md)
