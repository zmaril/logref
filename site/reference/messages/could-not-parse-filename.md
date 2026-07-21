---
message: "could not parse filename \"%s\""
slug: could-not-parse-filename
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/heap/rewriteheap.c:1207"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5506"
reproduced: false
---

# `could not parse filename "%s"`

## What it means

Internal error. Code parsing a Postgres-generated filename (a WAL-rewrite mapping file or a logical-decoding spill file) could not extract the expected fields from the name. The `%s` is the filename.

## When it happens

A file in the relevant directory did not match the naming convention the code assembles and expects — usually a stray or truncated file. Ordinary operation does not produce it.

## How to fix

This is an internal consistency check. Check for foreign or partial files in the `pg_logical` or rewrite-mapping areas. Do not hand-edit those directories; capture the filename and report a reproducible case.

## Example

*Illustrative* — an unexpected file name in a managed directory.

```text
ERROR:  could not parse filename "map-0badf00d"
```

## Related

- [could not parse end position](./could-not-parse-end-position.md)
- [could not read from reorderbuffer spill file](./could-not-read-from-reorderbuffer-spill-file.md)
