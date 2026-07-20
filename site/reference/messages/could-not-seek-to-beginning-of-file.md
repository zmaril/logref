---
message: "could not seek to beginning of file \"%s\": %m"
slug: could-not-seek-to-beginning-of-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/walsender.c:660"
reproduced: false
---

# `could not seek to beginning of file "%s": %m`

## What it means

A walsender could not seek back to the start of a file it is streaming. The placeholder is the file and the trailing text is the operating-system error. Walsenders read files to send them to standbys and backup clients.

## When it happens

It fires while a walsender streams a file (for example during a base backup over the replication protocol) and cannot reposition it to the beginning.

## How to fix

Read the OS error. An I/O failure points at the storage the file lives on — check the disk and kernel log. This is a server-side infrastructure problem; the client's backup or replication stream will fail as a result. Fix the storage condition and retry the operation.

## Example

*Illustrative* — a rewind of a streamed file failed.

```text
ERROR:  could not seek to beginning of file "base/16384/2619": Input/output error
```

## Related

- [could not seek in file to offset](./could-not-seek-in-file-to-offset.md)
- [could not start reading blocks in file](./could-not-start-reading-blocks-in-file.md)
