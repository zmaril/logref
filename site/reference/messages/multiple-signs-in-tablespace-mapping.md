---
message: "multiple \"=\" signs in tablespace mapping"
slug: multiple-signs-in-tablespace-mapping
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:339"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:483"
reproduced: false
---

# `multiple "=" signs in tablespace mapping`

## What it means

A tablespace-mapping argument contained more than one `=` sign, so the tool cannot tell where the old path ends and the new path begins. The mapping must have exactly one separator.

## When it happens

It arises from `pg_basebackup --tablespace-mapping` (and similar) when a path in the mapping itself contains `=`, producing two or more separators.

## How to fix

Ensure the mapping has a single `=` between the old and new directories. If a directory name genuinely contains `=`, that is not supported by this option; relocate to a path without `=` or use a different mechanism.

## Example

*Illustrative* — two '=' in a tablespace mapping.

```text
FATAL:  multiple "=" signs in tablespace mapping
```

## Related

- [invalid tablespace mapping format must be OLDDIR=NEWDIR](./invalid-tablespace-mapping-format-must-be-olddir-newdir.md)
- [new directory is not an absolute path in tablespace mapping](./new-directory-is-not-an-absolute-path-in-tablespace-mapping.md)
