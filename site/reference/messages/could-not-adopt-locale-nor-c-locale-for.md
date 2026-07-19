---
message: "could not adopt \"%s\" locale nor C locale for %s"
slug: could-not-adopt-locale-nor-c-locale-for
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/main/main.c:373"
reproduced: false
---

# `could not adopt "%s" locale nor C locale for %s`

## What it means

At startup the server could not set the requested locale for a category, and also could not fall back to the C locale. Without a working locale it cannot proceed, so it exits fatally. This is a low-level environment problem.

## When it happens

It happens very early in startup when the operating system rejects both the configured locale and the C locale for a locale category, usually due to a broken locale environment.

## How to fix

Fix the server's locale environment. Ensure the required locales are installed on the OS, and that `LC_*`/`LANG` and the cluster's locale settings name locales the system supports. Even the C locale failing indicates a badly broken environment to repair.

## Example

*Illustrative* — no usable locale at startup.

```text
FATAL:  could not adopt "en_US.UTF-8" locale nor C locale for LC_CTYPE
```

## Related

- [configuration file contains errors](./configuration-file-contains-errors.md)
- [could not allocate memory for shared memory name](./could-not-allocate-memory-for-shared-memory-name.md)
