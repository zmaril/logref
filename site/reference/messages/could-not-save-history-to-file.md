---
message: "could not save history to file \"%s\": %m"
slug: could-not-save-history-to-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/input.c:476"
  - "postgres/src/bin/psql/input.c:514"
reproduced: false
---

# `could not save history to file "%s": %m`

## What it means

`psql` could not write its command history to the history file. The `%s` is the path and the `%m` is the operating-system error. The session's history was not persisted.

## When it happens

The history file's directory was not writable, the disk was full, or permissions blocked the write when `psql` exited or flushed history.

## How to fix

Point `HISTFILE` (or `\set HISTFILE`) at a writable path, or fix permissions on the default `~/.psql_history`. This does not affect query results — only saved history.

## Example

*Illustrative* — the history file was not writable.

```text
psql: error: could not save history to file "/root/.psql_history": Permission denied
```

## Related

- [could not launch shell command](./could-not-launch-shell-command.md)
- [could not write to output file](./could-not-write-to-output-file.md)
