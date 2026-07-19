---
message: "unrecognized %s option \"%s\""
slug: unrecognized-option-8eb055
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/explain_state.c:168"
  - "postgres/src/backend/commands/indexcmds.c:2997"
  - "postgres/src/backend/commands/repack.c:279"
  - "postgres/src/backend/commands/vacuum.c:234"
  - "postgres/src/backend/commands/vacuum.c:297"
  - "postgres/src/backend/postmaster/checkpointer.c:1024"
reproduced: false
---

# `unrecognized %s option "%s"`

## What it means

A command was given an option name it does not accept. The first placeholder is the command or context (for example `EXPLAIN`), the second the unknown option. The option parser lists a fixed set of names and rejects anything else.

## When it happens

Passing a misspelled or unsupported option in a parenthesized option list — for example `EXPLAIN (ANALYZ)` or an option that exists in a newer server version than the one you are running.

## How to fix

Check the spelling and the server version's documentation for the command's option list. Correct the option name. If the option is valid in a later release, upgrade or drop it.

## Example

*Illustrative* — a misspelled EXPLAIN option.

```sql
EXPLAIN (ANALYZ) SELECT 1;
```

## Related

- [unrecognized value for option](./unrecognized-value-for-option-0dbab1.md)
- [invalid option](./invalid-option.md)
