---
message: "could not open stdout for appending: %m"
slug: could-not-open-stdout-for-appending
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_backup_archiver.c:2447"
reproduced: false
---

# `could not open stdout for appending: %m`

## What it means

`pg_dump` or `pg_restore` tried to reopen standard output in append mode and the operating system refused. The `%m` reason gives the cause. It reopens standard output when directing archive output there.

## When it happens

It happens when the tool writes to standard output, when reopening it for appending fails — usually because standard output is connected to something that cannot be reopened that way, such as a closed pipe.

## How to fix

Write the dump to a named file with `-f` instead of relying on standard output, or make sure the destination that standard output points at accepts appended writes. Redirecting to a regular file avoids the problem.

## Example

*Illustrative* — standard output could not be reopened for appending.

```text
pg_dump: fatal: could not open stdout for appending: Bad file descriptor
```

## Related

- [could not re-open the output file](./could-not-re-open-the-output-file.md)
- [could not open server file](./could-not-open-server-file.md)
