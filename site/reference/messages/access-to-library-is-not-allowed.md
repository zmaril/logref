---
message: "access to library \"%s\" is not allowed"
slug: access-to-library-is-not-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/utils/fmgr/dfmgr.c:525"
reproduced: false
---

# `access to library "%s" is not allowed`

## What it means

A request to load a shared library was refused because the library is outside the set the server is configured to permit loading.

## When it happens

It occurs when `LOAD` or a C-language function references a library that is not in an allowed location, especially when restrictions like a controlled library path or the trusted-library rules are in force.

## How to fix

Install the library in a permitted directory (typically the package's `$libdir`), and load it via a mechanism the configuration allows. Restrictions on which libraries may be loaded are a security boundary; do not weaken them casually. Confirm the extension's files are placed where the server expects.

## Example

*Illustrative* — loading a library outside the allowed set.

```sql
LOAD '/tmp/evil.so';  -- ERROR:  access to library "/tmp/evil.so" is not allowed
```

## Related

- [absolute path not allowed](./absolute-path-not-allowed.md)
- [archive modules have to define the symbol](./archive-modules-have-to-define-the-symbol.md)
