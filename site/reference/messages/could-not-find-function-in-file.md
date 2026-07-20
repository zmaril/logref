---
message: "could not find function \"%s\" in file \"%s\""
slug: could-not-find-function-in-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/utils/fmgr/dfmgr.c:131"
reproduced: false
---

# `could not find function "%s" in file "%s"`

## What it means

The dynamic-function loader could not find a named C function symbol inside a loaded shared library file. The `%s` values name the function and the file.

## When it happens

It happens the first time a C-language function is called, when its `AS 'library', 'symbol'` symbol is not present in the shared library — a mismatch between the SQL declaration and the compiled library.

## How to fix

Check that the C function's declared symbol name matches an exported symbol in the library, and that the installed library matches the SQL function definitions. Rebuild or reinstall the extension so the library and its function declarations agree.

## Example

*Illustrative* — a symbol missing from the shared library.

```text
ERROR:  could not find function "my_c_func" in file "/usr/lib/postgresql/myext.so"
```

## Related

- [could not find function information for function](./could-not-find-function-information-for-function.md)
- [could not find library for injection point](./could-not-find-library-for-injection-point.md)
