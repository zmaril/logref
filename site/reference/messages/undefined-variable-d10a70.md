---
message: "%s: undefined variable \"%s\""
slug: undefined-variable-d10a70
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2945"
  - "postgres/src/bin/pgbench/pgbench.c:3442"
reproduced: false
---

# `%s: undefined variable "%s"`

## What it means

A client tool (such as psql or pgbench) referenced a variable that has not been defined. The placeholders are the program name and the variable name. The tool cannot substitute a value for an unset variable in this context.

## When it happens

It arises when a script uses a variable (for example a `:var` reference or a scripting variable) that was never set with the tool's `\set`/`-D`/`-v` mechanism, or whose name is misspelled.

## How to fix

Define the variable before using it (`\set name value` in psql, `-v name=value` on the command line, or `-D` for pgbench), or correct the reference to a variable that exists. Check for typos in the variable name.

## Example

*Illustrative* — referencing an undefined script variable.

```text
pgbench: undefined variable "scale"
```

## Related

- [\pset: unknown option: %s](./pset-unknown-option.md)
- [query ignored; use \endif or Ctrl-C to exit current \if block](./query-ignored-use-endif-or-ctrl-c-to-exit-current-if-block.md)
