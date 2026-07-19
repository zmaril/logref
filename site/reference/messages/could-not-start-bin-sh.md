---
message: "could not start /bin/sh"
slug: could-not-start-bin-sh
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:4708"
reproduced: false
---

# `could not start /bin/sh`

## What it means

`psql` could not start the shell to run a command. This backs meta-commands that shell out, such as `\!`, which run a command through `/bin/sh`.

## When it happens

It fires when a `psql` shell escape tries to launch the shell and the operating system cannot spawn it — an unusual environment where `/bin/sh` is missing or not executable.

## How to fix

Confirm that a shell is available to `psql` in the environment where it runs. On unix hosts this is `/bin/sh`; if it is absent or the environment is heavily restricted, shell escapes will not work. Run `psql` in a normal environment, or avoid shell meta-commands there.

## Example

*Illustrative* — the shell could not be started.

```text
could not start /bin/sh
```

## Related

- [could not start editor](./could-not-start-editor.md)
- [could not run shell command](./could-not-run-shell-command.md)
