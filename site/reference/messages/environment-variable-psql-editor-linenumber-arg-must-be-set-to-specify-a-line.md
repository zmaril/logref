---
message: "environment variable PSQL_EDITOR_LINENUMBER_ARG must be set to specify a line number"
slug: environment-variable-psql-editor-linenumber-arg-must-be-set-to-specify-a-line
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:4676"
reproduced: false
---

# `environment variable PSQL_EDITOR_LINENUMBER_ARG must be set to specify a line number`

## What it means

A psql command tried to open an editor at a specific line, but the `PSQL_EDITOR_LINENUMBER_ARG` environment variable is not set. psql needs it to know how to pass a line number to your editor.

## When it happens

It fires from `\e`, `\ef`, or `\ev` with a line-number argument when `PSQL_EDITOR_LINENUMBER_ARG` is unset.

## How to fix

Set `PSQL_EDITOR_LINENUMBER_ARG` to the option your editor uses to jump to a line — commonly `+` (so psql appends `+N`), for example `export PSQL_EDITOR_LINENUMBER_ARG='+'`. Some editors use `--line ` instead.

## Example

*Illustrative* — editing at a line without the setting.

```text
\ef myfunc 10
-- environment variable PSQL_EDITOR_LINENUMBER_ARG must be set to specify a line number
```

## Related

- [environment variable name must not contain "="](./environment-variable-name-must-not-contain.md)
- [Do not give user, host, or port separately when using a connection string](./do-not-give-user-host-or-port-separately-when-using-a-connection-string.md)
