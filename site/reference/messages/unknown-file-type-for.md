---
message: "unknown file type for \"%s\""
slug: unknown-file-type-for
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/filemap.c:793"
  - "postgres/src/bin/pg_rewind/filemap.c:909"
reproduced: false
---

# `unknown file type for "%s"`

## What it means

Internal error in a file-walking tool. While classifying an entry in a data directory, the tool met a filesystem object that is neither a regular file, directory, nor symlink it knows how to handle.

## When it happens

It fires in tools such as `pg_rewind` or backup utilities when a directory contains an entry of an unexpected type (a device, socket, or pipe) where only ordinary files were expected.

## How to fix

This is a guard over unexpected filesystem contents. Remove stray non-data files from the data directory, ensure no foreign objects were placed there, and re-run the tool.

## Example

*Illustrative* — an unexpected filesystem entry.

```text
FATAL:  unknown file type for "base/16384/pipe"
```

## Related

- [unexpected state while parsing tar archive](./unexpected-state-while-parsing-tar-archive.md)
- [unrecognized transfer mode](./unrecognized-transfer-mode.md)
