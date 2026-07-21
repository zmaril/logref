---
message: "this build does not support sync method \"%s\""
slug: this-build-does-not-support-sync-method
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/common/file_utils.c:133"
  - "postgres/src/common/file_utils.c:243"
  - "postgres/src/fe_utils/option_utils.c:99"
reproduced: false
---

# `this build does not support sync method "%s"`

## What it means

A requested file-synchronization method is not available in this build of Postgres or its tools. The set of usable sync methods depends on what the operating system and the build support, and the chosen one is not included.

## When it happens

Setting a data-flush or sync method — through a server parameter or a tool option — to a value that the running build was not compiled with support for, or that the platform does not offer.

## How to fix

Choose a sync method the build supports. Consult the documentation for the valid values on your platform, and pick one that is available. If you require a specific method, use a build and operating system that provide it.

## Example

*Illustrative* — an unsupported sync method.

```text
ERROR:  this build does not support sync method "syncfs"
```

## Related

- [invalid value for option](./invalid-value-for-option.md)
- [could not flush dirty data](./could-not-flush-dirty-data.md)
