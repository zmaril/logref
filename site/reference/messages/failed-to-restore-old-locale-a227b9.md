---
message: "failed to restore old locale \"%s\""
slug: failed-to-restore-old-locale-a227b9
passthrough: false
api: [elog, pg_fatal]
level: [FATAL, WARNING]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:309"
  - "postgres/src/bin/initdb/initdb.c:397"
reproduced: false
---

# `failed to restore old locale "%s"`

## What it means

Code temporarily switched the process locale and could not restore the previous one afterward. The `%s` is the locale it tried to restore. On the server this is FATAL; in `initdb` it is a warning.

## When it happens

It fires after a locale-sensitive operation when the saved locale could not be reinstated — a rare platform or C-library condition.

## How to fix

This points at a locale/library problem on the host. Verify the locale is installed and valid. On the server it aborts the backend to stay safe; if it recurs, capture the locale and platform and report it.

## Example

*Illustrative* — the previous locale could not be restored.

```text
FATAL:  failed to restore old locale "en_US.UTF-8"
```

## Related

- [could not get language from locale](./could-not-get-language-from-locale.md)
- [encoding mismatch](./encoding-mismatch.md)
