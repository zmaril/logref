---
message: "syntax error in file \"%s\" line %u: expected stash name"
slug: syntax-error-in-file-line-expected-stash-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/contrib/pg_stash_advice/stashpersist.c:365"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:404"
reproduced: false
---

# `syntax error in file "%s" line %u: expected stash name`

## What it means

While parsing a stash-format file, the reader expected a stash name at a particular line and did not find one. The placeholders are the file name and line number. The file does not conform to the expected format.

## When it happens

It arises when the server reads a `pg_stash`-style file that is malformed at the named line — corrupted, truncated, or edited by hand.

## How to fix

Inspect the named file at the given line and restore the expected format, or regenerate the file through the feature that owns it rather than editing manually. Restore from backup if the file is corrupted on disk.

## Example

*Illustrative* — a stash file missing an expected name.

```text
ERROR:  syntax error in file "advice.stash" line 2: expected stash name
```

## Related

- [syntax error in file "%s" line %u: expected end of line](./syntax-error-in-file-line-expected-end-of-line.md)
- [advice stash does not exist](./advice-stash-does-not-exist.md)
