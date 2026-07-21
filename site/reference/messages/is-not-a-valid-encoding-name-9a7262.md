---
message: "\"%s\" is not a valid encoding name"
slug: is-not-a-valid-encoding-name-9a7262
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/extension.c:825"
  - "postgres/src/bin/scripts/createdb.c:175"
reproduced: true
---

# `"%s" is not a valid encoding name`

## What it means

A character-set encoding name was not recognized. The placeholder is the offending name. It appears where an encoding is named as text, such as in database creation or conversion definitions.

## When it happens

It arises from `CREATE DATABASE ... ENCODING`, `CREATE CONVERSION`, or functions taking an encoding name when the name is misspelled or unsupported by this build.

## How to fix

Use a supported encoding name, such as `UTF8` or `LATIN1`. List the valid names with `SELECT pg_encoding_to_char(i) FROM generate_series(0,42) i;` and match the spelling exactly.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  "%s" is not a valid encoding name
```

## Related

- [invalid client encoding specified](./invalid-client-encoding-specified.md)
- [invalid encoding number](./invalid-encoding-number.md)
