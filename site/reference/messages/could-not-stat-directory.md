---
message: "could not stat directory \"%s\": %m"
slug: could-not-stat-directory
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablespace.c:184"
  - "postgres/src/backend/commands/tablespace.c:639"
reproduced: false
---

# `could not stat directory "%s": %m`

## What it means

A `stat` on a directory failed. The `%s` is the path and the `%m` is the operating-system error. The server could not read the directory's attributes — for example while validating a tablespace location.

## When it happens

The directory was missing, on an unmounted filesystem, or unreadable due to permissions, when the server inspected it (tablespace creation or size calculation).

## How to fix

Read the trailing error. Ensure the directory exists, is mounted, and is accessible to the server user. Correct the path or permissions and retry.

## Example

*Illustrative* — a tablespace directory could not be stat'd.

```text
ERROR:  could not stat directory "/mnt/space": No such file or directory
```

## Related

- [could not stat file or directory](./could-not-stat-file-or-directory.md)
- [exists but is not a directory](./exists-but-is-not-a-directory.md)
