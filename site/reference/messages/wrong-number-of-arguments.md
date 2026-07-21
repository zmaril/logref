---
message: "wrong number of arguments"
slug: wrong-number-of-arguments
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/dblink/dblink.c:699"
  - "postgres/contrib/dblink/dblink.c:766"
  - "postgres/contrib/dblink/dblink.c:786"
  - "postgres/contrib/dblink/dblink.c:1440"
reproduced: false
---

# `wrong number of arguments`

## What it means

Internal error. A C-level function (here in `dblink`) was called with a different number of arguments than it expects. The message is a defensive check: the SQL-level function signatures should already enforce the arity, so reaching the C check indicates a mismatch between the SQL declarations and the C code.

## When it happens

It should not occur when an extension's SQL objects match its shared library. It usually means the extension's SQL definitions and its `.so` are out of sync — a partial upgrade, a stale `CREATE EXTENSION` version, or a hand-declared function whose signature does not match the C function.

## How to fix

Make the extension's SQL and library versions agree: run `ALTER EXTENSION ... UPDATE`, or reinstall the extension so its SQL definitions match the installed shared object. Do not hand-declare C functions with signatures that differ from the library. Report it if versions genuinely match.

## Example

*Illustrative* — emitted internally by a C function arity check.

```text
ERROR:  wrong number of arguments
```

## Related

- [could not send query](./could-not-send-query.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
