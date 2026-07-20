---
message: "could not open file \"%s\" restored from archive: %m"
slug: could-not-open-file-restored-from-archive
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/fe_utils/archive.c:77"
reproduced: false
---

# `could not open file "%s" restored from archive: %m`

## What it means

A front-end tool restored a file from the WAL archive using the configured restore command and then could not open the restored file. The `%m` reason gives the cause. The restore appeared to run, but the file is not usable.

## When it happens

It happens when a tool (for example during recovery-style restore) runs a `restore_command`, which reports success, but the resulting file cannot be opened — usually a restore command that does not actually place the file where expected.

## How to fix

Check that the restore command writes the file to the exact target path the tool asked for and exits with success only when it did. Fixing the restore command so it produces a readable file at the expected location resolves it.

## Example

*Illustrative* — a restored file that could not be opened.

```text
pg_rewind: fatal: could not open file "00000001000000000000000A" restored from archive: No such file or directory
```

## Related

- [could not open archive location](./could-not-open-archive-location.md)
- [could not read archive location](./could-not-read-archive-location.md)
