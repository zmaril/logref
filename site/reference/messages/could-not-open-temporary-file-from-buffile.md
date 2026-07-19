---
message: "could not open temporary file \"%s\" from BufFile \"%s\": %m"
slug: could-not-open-temporary-file-from-buffile
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/file/buffile.c:337"
reproduced: false
---

# `could not open temporary file "%s" from BufFile "%s": %m`

## What it means

The buffered-file layer tried to open one of the on-disk segments backing a temporary file and the operating system refused. The `%m` reason gives the cause. Large sorts, hashes, and similar operations spill to these temporary files.

## When it happens

It fires while a query reads back spilled temporary data, when a segment of the temporary file cannot be opened — usually a temporary file removed out from under the query, a full temporary tablespace, or an I/O error.

## How to fix

Make sure the temporary tablespace (or the default `base/pgsql_tmp`) has free space and healthy storage, and that nothing outside Postgres is deleting temporary files. Freeing space or fixing the storage lets the query complete.

## Example

*Illustrative* — a temporary-file segment could not be opened.

```text
ERROR:  could not open temporary file "0.0" from BufFile "tuplestore": No such file or directory
```

## Related

- [could not read from file set: read only of bytes](./could-not-read-from-file-set-read-only-of-bytes.md)
- [could not open file (target block)](./could-not-open-file-target-block.md)
