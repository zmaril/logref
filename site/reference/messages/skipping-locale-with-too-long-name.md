---
message: "skipping locale with too-long name: \"%s\""
slug: skipping-locale-with-too-long-name
passthrough: false
api: [elog]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/commands/collationcmds.c:794"
  - "postgres/src/backend/commands/collationcmds.c:890"
reproduced: false
---

# `skipping locale with too-long name: "%s"`

## What it means

While scanning the operating system's available locales to populate collations, the server found one whose name is longer than the maximum it can store, so it ignored that locale.

## When it happens

It is logged at DEBUG1 during `initdb` or `pg_import_system_collations` when the platform reports a locale name that exceeds the internal length limit for collation names.

## Is this a problem?

This is harmless bookkeeping — the over-long locale is simply not imported as a collation. No action is needed unless you specifically need that locale, in which case use ICU collations, which do not have the same name constraint.

## Example

*Illustrative* — a locale whose name is too long to import.

```text
DEBUG:  skipping locale with too-long name: "en_US_POSIX_with_a_very_long_suffix"
```

## Related

- [skipping special file](./skipping-special-file.md)
- [argument to option must be a valid encoding name](./argument-to-option-must-be-a-valid-encoding-name.md)
