---
message: "data file \"%s\" in source is not a regular file"
slug: data-file-in-source-is-not-a-regular-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:298"
reproduced: false
---

# `data file "%s" in source is not a regular file`

## What it means

`pg_rewind` found that something it expected to be a regular data file in the source is not one — it might be a directory, a symbolic link, or a special file. The placeholder is the path.

## When it happens

It fires during `pg_rewind` while it inspects the source's files and encounters an entry in a relation's place that is not an ordinary file, which points at an unusual or damaged source layout.

## How to fix

Investigate the named path in the source. A relation file that is not a regular file suggests manual tampering, a broken symlink, or filesystem damage. Make sure the source is a clean, consistent data directory before rewinding; a source in an unexpected shape cannot be trusted.

## Example

*Illustrative* — a non-regular file in the source.

```text
pg_rewind: error: data file "base/1/1259" in source is not a regular file
```

## Related

- [could not seek in source file](./could-not-seek-in-source-file.md)
- [database cluster is not compatible](./database-cluster-is-not-compatible.md)
