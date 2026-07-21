---
message: "option %s requires option %s"
slug: option-requires-option
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:864"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:426"
  - "postgres/src/bin/pg_dump/pg_restore.c:460"
reproduced: true
---

# `option %s requires option %s`

## What it means

A command-line tool was given one option that only makes sense together with another, and that other option was absent. The two options are linked, and supplying one without the other is not a valid combination.

## When it happens

Running a tool such as pg_dump or pg_dumpall with an option that depends on a companion option — for example an option that qualifies a mode without the option that selects that mode.

## How to fix

Add the required companion option, or drop the dependent one. The message names both options; consult the tool's help (`--help`) for how the pair is meant to be used together.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__66_dump`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  option %s requires option %s
```

## Related

- [invalid restrict key](./invalid-restrict-key.md)
- [requires a value](./requires-a-value.md)
