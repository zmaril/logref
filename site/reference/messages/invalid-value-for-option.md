---
message: "invalid value \"%s\" for option %s"
slug: invalid-value-for-option
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1073"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1176"
  - "postgres/src/fe_utils/option_utils.c:69"
reproduced: true
---

# `invalid value "%s" for option %s`

## What it means

An option accepted a value that is not valid for it. The command-line tool or SQL command that reads the option checks the value's form or range, and the supplied value failed that check.

## When it happens

Passing a malformed or out-of-range value to a program option or a command option — for example a non-numeric value where a number is required, or a keyword outside the option's accepted set. The message names the option and the rejected value.

## How to fix

Consult the option's documentation for its accepted values and supply one that fits. Check for typos, wrong units, or a value that came from an unvalidated variable. The message quotes the value it rejected, which usually points straight at the mistake.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__66_dump`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  invalid value "%s" for option %s
```

## Related

- [requires an integer value](./requires-an-integer-value.md)
- [requires a value](./requires-a-value.md)
