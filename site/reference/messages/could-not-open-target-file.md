---
message: "could not open target file \"%s\": %m"
slug: could-not-open-target-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:70"
reproduced: false
---

# `could not open target file "%s": %m`

## What it means

`pg_rewind` tried to open a file in the target data directory to read or write it and the operating system refused. The `%m` reason gives the cause. Rewind reads and rewrites target files to align them with the source.

## When it happens

It happens while `pg_rewind` processes the target cluster, when a target file cannot be opened — usually a permissions problem, a missing file, or an I/O error on the target storage.

## How to fix

Check the target directory's permissions and storage health. A `pg_rewind` run that failed part-way leaves the target unusable — fix the underlying problem and rerun from a known-good state.

## Example

*Illustrative* — a target file could not be opened.

```text
pg_rewind: fatal: could not open target file "global/pg_control": Permission denied
```

## Related

- [could not open file for truncation](./could-not-open-file-for-truncation.md)
- [could not prepare statement to fetch file contents](./could-not-prepare-statement-to-fetch-file-contents.md)
