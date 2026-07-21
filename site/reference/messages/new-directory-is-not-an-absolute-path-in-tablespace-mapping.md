---
message: "new directory is not an absolute path in tablespace mapping: %s"
slug: new-directory-is-not-an-absolute-path-in-tablespace-mapping
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:371"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:506"
reproduced: false
---

# `new directory is not an absolute path in tablespace mapping: %s`

## What it means

The new-directory side of a tablespace mapping was a relative path. Tablespace mappings require absolute paths so the relocated tablespace has an unambiguous location. The placeholder is the offending path.

## When it happens

It arises from `pg_basebackup --tablespace-mapping OLD=NEW` (and similar tooling) when the `NEW` directory is not an absolute path.

## How to fix

Give the new directory as an absolute path beginning with `/` (or a drive-qualified path on Windows). Rewrite the mapping so both sides are absolute, for example `/data/ts1=/mnt/newdata/ts1`.

## Example

*Illustrative* — a relative new directory in a mapping.

```text
FATAL:  new directory is not an absolute path in tablespace mapping: newdata/ts1
```

## Related

- [old directory is not an absolute path in tablespace mapping](./old-directory-is-not-an-absolute-path-in-tablespace-mapping.md)
- [invalid tablespace mapping format must be OLDDIR=NEWDIR](./invalid-tablespace-mapping-format-must-be-olddir-newdir.md)
