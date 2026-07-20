---
message: "could not locate temporary directory: %s"
slug: could-not-locate-temporary-directory
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:4758"
reproduced: false
---

# `could not locate temporary directory: %s`

## What it means

`psql` tried to find a directory it could write temporary files into and could not. The `%s` value gives the reason. It uses a temporary directory for helpers such as the `\e` editor buffer.

## When it happens

It happens in `psql` when none of the usual temporary-directory environment variables point at a writable directory — common in stripped-down environments where `TMPDIR` (or the Windows equivalents) is unset or points somewhere unusable.

## How to fix

Set `TMPDIR` (or `TMP`/`TEMP` on Windows) to a directory that exists and is writable by your user, then retry. Creating the directory or fixing its permissions resolves it.

## Example

*Illustrative* — psql cannot find a writable temp directory.

```text
psql: error: could not locate temporary directory: no such file or directory
```

## Related

- [could not open logfile](./could-not-open-logfile.md)
- [could not print result table](./could-not-print-result-table.md)
