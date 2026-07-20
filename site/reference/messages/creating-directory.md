---
message: "creating directory \"%s\""
slug: creating-directory
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:414"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:749"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:947"
reproduced: false
---

# `creating directory "%s"`

## What it means

A debug trace line from pg_combinebackup, reporting that it is creating a directory in the output tree as it reconstructs a backup. It is diagnostic progress output, not a condition to act on.

## When it happens

Running pg_combinebackup with debug tracing enabled, as it walks the backup structure and creates each output directory it needs.

## Is this a problem?

No action is needed. It is expected progress tracing. If the output is too verbose, lower the tool's debug level.

## Example

*Illustrative* — a directory-creation trace line.

```text
DEBUG:  creating directory "out/base/16384"
```

## Related

- [would create directory](./would-create-directory.md)
- [the target directory will not be modified](./the-target-directory-will-not-be-modified.md)
