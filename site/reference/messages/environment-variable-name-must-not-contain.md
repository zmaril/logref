---
message: "\\%s: environment variable name must not contain \"=\""
slug: environment-variable-name-must-not-contain
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2949"
reproduced: false
---

# `\%s: environment variable name must not contain "="`

## What it means

A psql `\setenv` command used an environment-variable name containing an `=` character. Variable names cannot include `=`, which separates the name from the value.

## When it happens

It fires from psql's `\setenv` when the first argument (the variable name) contains an equals sign.

## How to fix

Use `\setenv NAME value` with a clean variable name that has no `=`. If you meant to set a value that contains `=`, put it in the second argument, quoting if needed.

## Example

*Illustrative* — an `=` in an env-var name.

```text
\setenv FOO=BAR baz
-- \setenv: environment variable name must not contain "="
```

## Related

- [environment variable PSQL_EDITOR_LINENUMBER_ARG must be set to specify a line number](./environment-variable-psql-editor-linenumber-arg-must-be-set-to-specify-a-line.md)
- [Do not give user, host, or port separately when using a connection string](./do-not-give-user-host-or-port-separately-when-using-a-connection-string.md)
