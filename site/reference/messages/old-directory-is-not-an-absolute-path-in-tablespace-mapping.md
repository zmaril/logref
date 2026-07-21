---
message: "old directory is not an absolute path in tablespace mapping: %s"
slug: old-directory-is-not-an-absolute-path-in-tablespace-mapping
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:367"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:502"
reproduced: false
---

# `old directory is not an absolute path in tablespace mapping: %s`

## What it means

The old-directory side of a tablespace mapping was a relative path. Tablespace mappings require absolute paths on both sides. The placeholder is the offending path.

## When it happens

It arises from `pg_basebackup --tablespace-mapping OLD=NEW` (and similar) when the `OLD` directory is not absolute.

## How to fix

Give the old directory as an absolute path that matches the source cluster's tablespace location. Rewrite the mapping so both sides are absolute, for example `/data/ts1=/mnt/newdata/ts1`.

## Example

*Illustrative* — a relative old directory in a mapping.

```text
FATAL:  old directory is not an absolute path in tablespace mapping: data/ts1
```

## Related

- [new directory is not an absolute path in tablespace mapping](./new-directory-is-not-an-absolute-path-in-tablespace-mapping.md)
- [invalid tablespace mapping format must be OLDDIR=NEWDIR](./invalid-tablespace-mapping-format-must-be-olddir-newdir.md)
