---
message: "could not find function information for function \"%s\""
slug: could-not-find-function-information-for-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/fmgr/fmgr.c:470"
reproduced: false
---

# `could not find function information for function "%s"`

## What it means

PostgreSQL could not read the function-information block (the `PG_FUNCTION_INFO_V1` record) for a C function. The `%s` names the function. A version-1 C function must publish this block.

## When it happens

It happens when calling a C-language function whose library does not export the matching info record — usually an old-style function or a library and SQL definition that are out of sync.

## How to fix

Make sure each C function is declared with the `PG_FUNCTION_INFO_V1` macro and the installed library matches the SQL definitions. Rebuild the extension against a current PostgreSQL and reinstall so the info records are present.

## Example

*Illustrative* — a C function with no info record.

```text
ERROR:  could not find function information for function "my_c_func"
```

## Related

- [could not find function in file](./could-not-find-function-in-file.md)
- [could not find a procedure named](./could-not-find-a-procedure-named.md)
