---
message: "%s requires a numeric value"
slug: requires-a-numeric-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/copy.c:519"
  - "postgres/src/backend/commands/define.c:70"
  - "postgres/src/backend/commands/define.c:81"
  - "postgres/src/backend/commands/define.c:175"
  - "postgres/src/backend/commands/define.c:193"
  - "postgres/src/backend/commands/define.c:208"
  - "postgres/src/backend/commands/define.c:226"
reproduced: false
---

# `%s requires a numeric value`

## What it means

An option that expects a number was given a non-numeric value. The placeholder is the option name. Options like `COPY`'s size-related settings or `DEFINE`-style parameters require a numeric argument, and a non-number (or malformed number) is rejected.

## When it happens

A `WITH (...)` or command option set to a string where a number is required — for example a buffer/size option given a word, or a numeric parameter with stray characters.

## How to fix

Supply a plain numeric value for the named option. Remove quotes or units if they are not accepted, and check the option's documentation for the expected form (integer vs float, allowed range). Correct the value and rerun.

## Example

*Illustrative* — a non-numeric value for a numeric option.

```sql
COPY t TO STDOUT WITH (something 'lots');
```

Produces:

```text
ERROR:  something requires a numeric value
```

## Related

- [invalid value for parameter](./invalid-value-for-parameter-821f2c.md)
- [option not recognized](./option-not-recognized.md)
