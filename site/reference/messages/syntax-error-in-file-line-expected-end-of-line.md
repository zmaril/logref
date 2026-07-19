---
message: "syntax error in file \"%s\" line %u: expected end of line"
slug: syntax-error-in-file-line-expected-end-of-line
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATA_CORRUPTED
    code: "XX001"
call_sites:
  - "postgres/contrib/pg_stash_advice/stashpersist.c:372"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:427"
reproduced: false
---

# `syntax error in file "%s" line %u: expected end of line`

## What it means

While parsing a structured server-side file, the reader expected the line to end but found extra content. The placeholders are the file name and line number. The file's format is violated at that line.

## When it happens

It arises when the server reads an internal or extension-managed file (for example a stash/control-style file) that is malformed — hand-edited, truncated, or corrupted — so a line carries unexpected trailing tokens.

## How to fix

Inspect the named file at the given line and restore its correct format. If it is a generated/managed file, regenerate it rather than editing by hand; if corrupted on disk, restore from backup. Do not manually edit files the server maintains.

## Example

*Illustrative* — a malformed managed file line.

```text
ERROR:  syntax error in file "advice.stash" line 4: expected end of line
```

## Related

- [syntax error in file "%s" line %u: expected stash name](./syntax-error-in-file-line-expected-stash-name.md)
- [undefined file type for "%s"](./undefined-file-type-for.md)
