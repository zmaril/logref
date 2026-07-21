---
message: "attempt to redefine parameter \"%s\""
slug: attempt-to-redefine-parameter
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/utils/misc/guc.c:4868"
reproduced: false
---

# `attempt to redefine parameter "%s"`

## What it means

Configuration parsing found the same parameter defined more than once in a way that is not allowed, so it cannot decide which definition should apply.

## When it happens

It is raised as an internal error when a parameter is redefined in a context that forbids redefinition — for example duplicate registration of a custom GUC by an extension.

## How to fix

If this comes from an extension registering a parameter twice, that is a bug in the extension — update or report it. For hand-written configuration, remove the duplicate definition so the parameter is set only once.

## Example

*Illustrative* — a parameter defined twice where it may not be.

```text
ERROR:  attempt to redefine parameter "my_ext.setting"
```

## Related

- [unrecognized configuration parameter](./unrecognized-configuration-parameter.md)
- [attempt to write bogus relation mapping](./attempt-to-write-bogus-relation-mapping.md)
