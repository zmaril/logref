---
message: "could not seek in target file \"%s\": %m"
slug: could-not-seek-in-target-file
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/file_ops.c:104"
reproduced: false
---

# `could not seek in target file "%s": %m`

## What it means

`pg_rewind` could not seek within a file in the target — the data directory it is rewinding. The placeholder is the file and the trailing text is the operating-system error.

## When it happens

It fires while `pg_rewind` applies changes to the target and cannot reposition within a file it is writing.

## How to fix

Read the OS error. A permission problem means the user running `pg_rewind` cannot write the target data directory — fix ownership. An I/O error points at the target storage. Ensure the target server is shut down cleanly and the directory is intact, then rerun.

## Example

*Illustrative* — a seek in a target file failed.

```text
pg_rewind: error: could not seek in target file "base/1/1259": Permission denied
```

## Related

- [could not seek in source file](./could-not-seek-in-source-file.md)
- [could not truncate file to (pg_rewind)](./could-not-truncate-file-to-244e28.md)
