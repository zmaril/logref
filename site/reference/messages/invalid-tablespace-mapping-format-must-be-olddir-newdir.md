---
message: "invalid tablespace mapping format \"%s\", must be \"OLDDIR=NEWDIR\""
slug: invalid-tablespace-mapping-format-must-be-olddir-newdir
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:348"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:491"
reproduced: false
---

# `invalid tablespace mapping format "%s", must be "OLDDIR=NEWDIR"`

## What it means

A tablespace-mapping argument was not in the required `OLDDIR=NEWDIR` form. Tools that relocate tablespaces during a base backup or restore need both an old and a new path separated by `=`.

## When it happens

It arises from `pg_basebackup --tablespace-mapping` (and similar options in `pg_combinebackup`/restore tooling) when the argument lacks the `=` separator or one of the two paths.

## How to fix

Pass the mapping as `OLDDIR=NEWDIR`, with both absolute paths present and a single `=` between them, for example `--tablespace-mapping=/data/ts1=/newdata/ts1`. Quote the argument if paths contain spaces.

## Example

*Illustrative* — a mapping missing the '=' separator.

```text
FATAL:  invalid tablespace mapping format "/old /new", must be "OLDDIR=NEWDIR"
```

## Related

- [multiple "=" signs in tablespace mapping](./multiple-signs-in-tablespace-mapping.md)
- [old directory is not an absolute path in tablespace mapping](./old-directory-is-not-an-absolute-path-in-tablespace-mapping.md)
