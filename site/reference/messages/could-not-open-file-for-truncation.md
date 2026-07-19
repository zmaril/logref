---
message: "could not open file \"%s\" for truncation: %m"
slug: could-not-open-file-for-truncation
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:227"
reproduced: false
---

# `could not open file "%s" for truncation: %m`

## What it means

`pg_rewind` tried to open a file in the target data directory so it could truncate it and the operating system refused. The `%m` reason gives the cause. Rewind truncates some target files to match the source.

## When it happens

It happens while `pg_rewind` rewrites the target cluster, when a file it needs to truncate cannot be opened — usually a permissions problem or an I/O error on the target storage.

## How to fix

Check the target directory's permissions and storage health. A `pg_rewind` run that failed part-way leaves the target unusable — resolve the storage or permission problem and rerun the rewind from a known-good state.

## Example

*Illustrative* — a target file could not be opened for truncation.

```text
pg_rewind: fatal: could not open file "base/16384/1259" for truncation: Permission denied
```

## Related

- [could not open target file](./could-not-open-target-file.md)
- [could not prepare statement to fetch file contents](./could-not-prepare-statement-to-fetch-file-contents.md)
