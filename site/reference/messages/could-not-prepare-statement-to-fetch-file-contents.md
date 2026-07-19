---
message: "could not prepare statement to fetch file contents: %s"
slug: could-not-prepare-statement-to-fetch-file-contents
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_rewind/libpq_source.c:152"
reproduced: false
---

# `could not prepare statement to fetch file contents: %s`

## What it means

`pg_rewind` running in libpq (source-server) mode tried to prepare the SQL statement it uses to read files from the source server and the server rejected it. The `%s` value gives the server's error. It reads source files over this connection.

## When it happens

It happens during a `pg_rewind` that connects to a live source server, when preparing the file-reading statement fails — usually missing privileges, or a source server lacking the required functions or configuration.

## How to fix

Connect `pg_rewind` to the source with a role that has the required privileges (superuser, or a role granted the needed replication and file-reading rights), and make sure the source server supports the file-fetch functions. The included server error names the cause.

## Example

*Illustrative* — the file-fetch statement could not be prepared.

```text
pg_rewind: fatal: could not prepare statement to fetch file contents: ERROR:  permission denied for function pg_read_binary_file
```

## Related

- [could not open target file](./could-not-open-target-file.md)
- [could not open file for truncation](./could-not-open-file-for-truncation.md)
