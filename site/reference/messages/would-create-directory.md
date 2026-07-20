---
message: "would create directory \"%s\""
slug: would-create-directory
passthrough: false
api: [pg_log_debug]
level: [DEBUG]
call_sites:
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:411"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:746"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:944"
reproduced: false
---

# `would create directory "%s"`

## What it means

A debug trace line from pg_combinebackup running in a dry-run or check mode, reporting a directory it would create if it were making changes. It describes a planned action that is not being carried out.

## When it happens

Running pg_combinebackup in a mode that reports its plan without acting, with debug tracing enabled, as it walks the output structure it would build.

## Is this a problem?

No action is needed. It is dry-run trace output. Run the tool in its acting mode when you want the directories created for real.

## Example

*Illustrative* — a dry-run directory-creation trace.

```text
DEBUG:  would create directory "out/base/16384"
```

## Related

- [creating directory](./creating-directory.md)
- [the target directory will not be modified](./the-target-directory-will-not-be-modified.md)
