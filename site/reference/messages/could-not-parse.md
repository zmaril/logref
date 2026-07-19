---
message: "%s: could not parse %s"
slug: could-not-parse
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_combinebackup/backup_label.c:66"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:85"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:95"
reproduced: false
---

# `%s: could not parse %s`

## What it means

A tool could not parse a value or file it was given. The placeholders name the program context and the item that failed to parse. This is a generic parse failure — the input's format did not match what the tool expected (a backup label, a manifest field, a numeric argument).

## When it happens

Feeding a tool a malformed or unexpected value — a corrupted or hand-edited control/label file, a wrong argument format, or a file from an incompatible version.

## How to fix

Read the surrounding context to see what was being parsed, and provide it in the expected format. If a metadata file is involved (backup label, manifest), confirm it was produced by a compatible version and is not truncated or edited. Re-generate or restore the input from a known-good source.

## Example

*Illustrative* — a value a tool could not parse.

```text
pg_combinebackup: could not parse backup_label
```

## Related

- [could not parse](./could-not-parse.md)
- [file contains which is not compatible with this program's version](./file-contains-which-is-not-compatible-with-this-program-s-version.md)
