---
message: "options %s and %s cannot be used together"
slug: options-and-cannot-be-used-together-8b5f2b
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2434"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:411"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:419"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:431"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:436"
  - "postgres/src/bin/pg_dump/pg_restore.c:355"
  - "postgres/src/bin/pg_dump/pg_restore.c:362"
  - "postgres/src/bin/pg_dump/pg_restore.c:382"
  - "postgres/src/bin/pg_dump/pg_restore.c:385"
  - "postgres/src/bin/pg_dump/pg_restore.c:388"
  - "postgres/src/bin/pg_dump/pg_restore.c:393"
  - "postgres/src/bin/pg_dump/pg_restore.c:396"
  - "postgres/src/bin/pg_dump/pg_restore.c:399"
  - "postgres/src/bin/pg_dump/pg_restore.c:404"
  - "postgres/src/bin/pg_dump/pg_restore.c:409"
  - "postgres/src/bin/pg_dump/pg_restore.c:412"
  - "postgres/src/bin/pg_dump/pg_restore.c:416"
  - "postgres/src/bin/pg_dump/pg_restore.c:420"
  - "postgres/src/bin/pg_dump/pg_restore.c:428"
  - "postgres/src/fe_utils/option_utils.c:139"
reproduced: true
---

# `options %s and %s cannot be used together`

## What it means

A command-line tool or command was given two options that are mutually exclusive. Both placeholders name the conflicting options. The tool refuses to guess which one you meant.

## When it happens

Utilities like `pg_dump`, `pg_restore`, `pg_dumpall`, `pg_createsubscriber`, and `reindexdb` where certain flags cannot coexist — for example a whole-database option combined with an object-specific one, or two output-format flags.

## How to fix

Keep only one of the two named options. Read the tool's `--help` or manual to understand why they conflict and which one fits your intent. Often one option implies a mode the other contradicts (for example "all objects" versus "just this table").

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__66_dump`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  options %s and %s cannot be used together
```

## Related

- [conflicting or redundant options](./conflicting-or-redundant-options.md)
- [invalid argument for option](./invalid-argument-for-option.md)
