---
message: "could not start editor \"%s\""
slug: could-not-start-editor
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:4706"
reproduced: false
---

# `could not start editor "%s"`

## What it means

`psql` could not start the external editor. The placeholder is the editor command. Meta-commands such as `\e` open the query buffer in an editor before running it.

## When it happens

It fires when you use `\e`, `\ef`, or a similar command and `psql` cannot launch the configured editor — the program is missing, not on the path, or not executable.

## How to fix

Check the editor `psql` is trying to use. It comes from the `PSQL_EDITOR`, `EDITOR`, or `VISUAL` environment variable. Set one of these to an editor that exists and is executable, for example `export EDITOR=vi`, and try again.

## Example

*Illustrative* — the configured editor was not found.

```text
could not start editor "nano"
```

## Related

- [could not start /bin/sh](./could-not-start-bin-sh.md)
- [could not run shell command](./could-not-run-shell-command.md)
