---
message: "could not execute command \"%s\": %m"
slug: could-not-execute-command
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basebackup_to_shell/basebackup_to_shell.c:270"
  - "postgres/src/backend/commands/collationcmds.c:875"
  - "postgres/src/backend/commands/copyfrom.c:1885"
  - "postgres/src/backend/commands/copyto.c:1168"
  - "postgres/src/backend/libpq/be-secure-common.c:64"
  - "postgres/src/bin/initdb/initdb.c:767"
  - "postgres/src/bin/psql/copy.c:326"
reproduced: false
---

# `could not execute command "%s": %m`

## What it means

Postgres tried to run an external command (via a shell) and the invocation failed. The first placeholder is the command, `%m` the OS error. It is used for archive commands, restore commands, SSL passphrase commands, and similar hooks that shell out.

## When it happens

`archive_command`/`restore_command`, `ssl_passphrase_command`, a `COPY ... FROM/TO PROGRAM`, or `basebackup_to_shell` where the shell could not start the command. Common `%m`: `No such file or directory` (the program is not found) or `Permission denied` (not executable).

## How to fix

Read `%m`. `No such file or directory` usually means the command's binary is not on the server's `PATH` or the path in the setting is wrong — use an absolute path. `Permission denied` means the file is not executable by the `postgres` user. Test the exact command as the `postgres` OS user to confirm it runs.

## Example

*Illustrative* — an archive command whose binary is missing.

```text
ERROR:  could not execute command "archive_tool %p": No such file or directory
```

## Related

- [query failed](./query-failed.md)
- [could not open file](./could-not-open-file-420e05.md)
