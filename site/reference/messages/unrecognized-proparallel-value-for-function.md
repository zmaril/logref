---
message: "unrecognized proparallel value for function \"%s\""
slug: unrecognized-proparallel-value-for-function
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:13735"
  - "postgres/src/bin/pg_dump/pg_dump.c:15610"
reproduced: false
---

# `unrecognized proparallel value for function "%s"`

## What it means

Internal error, or a corrupt catalog. Code reading a function's parallel-safety marker (`proparallel`) found a value that is not safe, restricted, or unsafe.

## When it happens

It fires where a function's `proparallel` from `pg_proc` is switched on and the value is outside the known set — an inconsistent catalog row rather than user input.

## How to fix

This is a guard over catalog metadata. If it appears at startup or during planning, the affected `pg_proc` row may be inconsistent; capture the function and report it as a reproducible bug.

## Example

*Illustrative* — an unrecognized parallel marker.

```text
FATAL:  unrecognized proparallel value for function "myfn"
```

## Related

- [unexpected typLen: %d](./unexpected-typlen.md)
- [unknown attrKind %u](./unknown-attrkind.md)
