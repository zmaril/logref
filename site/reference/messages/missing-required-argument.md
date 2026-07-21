---
message: "\\%s: missing required argument"
slug: missing-required-argument
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:573"
  - "postgres/src/bin/psql/command.c:768"
  - "postgres/src/bin/psql/command.c:1907"
  - "postgres/src/bin/psql/command.c:2075"
  - "postgres/src/bin/psql/command.c:2388"
  - "postgres/src/bin/psql/command.c:2402"
  - "postgres/src/bin/psql/command.c:2434"
  - "postgres/src/bin/psql/command.c:2523"
  - "postgres/src/bin/psql/command.c:2636"
  - "postgres/src/bin/psql/command.c:2796"
  - "postgres/src/bin/psql/command.c:2944"
  - "postgres/src/bin/psql/command.c:3204"
  - "postgres/src/bin/psql/command.c:3246"
  - "postgres/src/bin/psql/command.c:3286"
reproduced: false
---

# `\%s: missing required argument`

## What it means

A `psql` meta-command (a backslash command) was invoked without an argument it requires. The placeholder is the command name. Some `\` commands need an operand — a filename, a variable name, a query — and refuse to run without it.

## When it happens

Typing a backslash command that needs an argument but leaving it off — for example `\i` (include file), `\o` (output redirect), or `\watch` without the value the command expects.

## How to fix

Supply the required argument. Run `\?` in `psql` to see each meta-command's syntax and what it expects. For example `\i filename.sql` needs a path; `\watch 5` needs an interval where required.

## Example

*Illustrative* — a psql include command with no filename.

```text
\i
```

Produces:

```text
\i: missing required argument
```

## Related

- [Try "%s --help" for more information](./try-help-for-more-information-c0987f.md)
- [invalid argument for option](./invalid-argument-for-option.md)
