---
message: "could not print result table: %m"
slug: could-not-print-result-table
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/common.c:785"
reproduced: false
---

# `could not print result table: %m`

## What it means

`psql` finished a query but could not write the formatted result to its output. The `%m` reason gives the cause. This is a failure in emitting output, not in running the query.

## When it happens

It happens when `psql`'s output destination cannot accept the result — usually a closed pipe (for example piping into a program that exited), a full disk when writing to a file with `-o`, or an I/O error on the terminal.

## How to fix

Check where `psql` is sending output: if piping into another command, make sure it stays open; if writing to a file, confirm the disk has space and the path is writable. The `%m` reason names the specific problem.

## Example

*Illustrative* — output could not be written.

```text
psql: error: could not print result table: Broken pipe
```

## Related

- [could not locate temporary directory](./could-not-locate-temporary-directory.md)
- [could not re-open the output file](./could-not-re-open-the-output-file.md)
