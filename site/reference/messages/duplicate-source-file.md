---
message: "duplicate source file \"%s\""
slug: duplicate-source-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:303"
  - "postgres/src/bin/pg_rewind/filemap.c:336"
reproduced: false
---

# `duplicate source file "%s"`

## What it means

`pg_rewind` found two source files that map to the same target path while building its file map. The `%s` is the path. The map cannot hold two entries for one file.

## When it happens

The source directory listing produced a duplicate path — usually from an unexpected filesystem state or a symlink loop — during a rewind.

## How to fix

Inspect the source data directory for duplicate or looping entries (stray symlinks, overlapping mounts). Clean up the anomaly on the source cluster, then rerun `pg_rewind`.

## Example

*Illustrative* — a duplicate path in the source map.

```text
pg_rewind: error: duplicate source file "base/16384/16390"
```

## Related

- [could not open source file](./could-not-open-source-file.md)
- [file does not exist](./file-does-not-exist.md)
