---
message: "could not restore file \"%s\" from archive"
slug: could-not-restore-file-from-archive-87edff
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/fe_utils/archive.c:105"
reproduced: false
---

# `could not restore file "%s" from archive`

## What it means

A tool that fetches archived WAL could not restore a segment from the archive. This backs the shared `restore_command` runner used by front-end tools, and the command it ran did not produce the file.

## When it happens

It fires when `restore_command` is invoked to bring back a WAL segment and the command fails or the expected file does not appear — a wrong command, a missing segment in the archive, or a permission problem.

## How to fix

Test your `restore_command` by hand for the segment it names. It must copy the archived file into place and exit zero. Confirm the segment exists in the archive and that the command has the paths and credentials it needs. A non-zero exit or a missing output file triggers this.

## Example

*Illustrative* — the restore command did not produce the file.

```text
pg_rewind: error: could not restore file "000000010000000000000005" from archive
```

## Related

- [could not read restore_command from target cluster](./could-not-read-restore-command-from-target-cluster.md)
- [could not read from WAL segment](./could-not-read-from-wal-segment-offset.md)
