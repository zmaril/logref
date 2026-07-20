---
message: "could not write COPY data: %m"
slug: could-not-write-copy-data
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/copy.c:451"
  - "postgres/src/bin/psql/copy.c:461"
reproduced: false
---

# `could not write COPY data: %m`

## What it means

`psql` could not write `COPY` data during a client-side copy. The `%m` is the operating-system error. It fires while `\copy` streams data to a file or program.

## When it happens

The destination filled up, the pipe to a program broke, or an I/O error occurred while `psql` wrote `COPY` output on the client host.

## How to fix

Read the trailing error. Ensure the target file or program can accept the data (space, a live pipe), then rerun `\copy`. For a program target, confirm it did not exit early.

## Example

*Illustrative* — the copy destination ran out of space.

```text
psql: error: could not write COPY data: No space left on device
```

## Related

- [could not write bytes to log file](./could-not-write-bytes-to-log-file.md)
- [could not write to output file](./could-not-write-to-output-file.md)
