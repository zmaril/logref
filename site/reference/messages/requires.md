---
message: "%s: %s requires %s"
slug: requires
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:110"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:113"
reproduced: false
---

# `%s: %s requires %s`

## What it means

A generic dependency/usage message from a command-line tool. It reports that one component requires another — the placeholders are the program name, the feature, and what it needs. It signals a missing prerequisite for the requested operation.

## When it happens

It arises from utilities (such as backup/restore or build tools) when an option or mode depends on a capability, file, or another option that is not present in the current invocation or build.

## How to fix

Read the three named parts: the tool, the thing that has a requirement, and what it requires. Supply the missing prerequisite — enable the needed option, provide the required file, or use a build that includes the required feature.

## Example

*Illustrative* — a tool reporting an unmet requirement.

```text
FATAL:  pg_basebackup: WAL streaming requires a database connection
```

## Related

- [server version: %s; %s version: %s](./server-version-version.md)
- [unable to initialize LZ4 library: %s](./unable-to-initialize-lz4-library.md)
