---
message: "could not write to file \"%s/%s\": %m"
slug: could-not-write-to-file-d92fb3
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_waldump/archive_waldump.c:651"
reproduced: false
---

# `could not write to file "%s/%s": %m`

## What it means

`pg_waldump` could not write to an output file while saving records. The placeholder is the directory and file, and the trailing text is the operating-system error.

## When it happens

It fires when `pg_waldump` writes extracted output to a file and the write fails — a full disk, a permission problem, or an I/O error on the destination.

## How to fix

Read the OS error and check the output location. Make sure the directory exists and is writable and that the filesystem has room. Fix the reported condition and rerun.

## Example

*Illustrative* — a pg_waldump output write failed.

```text
pg_waldump: error: could not write to file "out/records.txt": No space left on device
```

## Related

- [could not write to file, wrote N of M](./could-not-write-to-file-wrote-of.md)
- [custom resource manager does not exist](./custom-resource-manager-does-not-exist.md)
