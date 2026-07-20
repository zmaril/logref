---
message: "could not determine current directory"
slug: could-not-determine-current-directory
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2464"
  - "postgres/src/bin/pg_upgrade/option.c:294"
  - "postgres/src/bin/pg_upgrade/option.c:400"
reproduced: false
---

# `could not determine current directory`

## What it means

A tool could not determine its current working directory. The message reflects a failed `getcwd()`-style call — the process cannot resolve the path it is running in, usually because the directory was removed or is inaccessible.

## When it happens

The working directory was deleted or renamed after the process started, permissions on a path component were removed, or the process is running in a directory it cannot read.

## How to fix

Run the tool from a directory that exists and is accessible. `cd` to a valid path (for example the data directory or the user's home) before launching, and ensure no external process is removing the working directory out from under it. Check permissions on the full path.

## Example

*Illustrative* — a removed working directory.

```text
error: could not determine current directory
```

## Related

- [cannot be executed by root](./cannot-be-executed-by-root.md)
- [no data directory specified](./no-data-directory-specified.md)
