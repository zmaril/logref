---
message: "encoding mismatch"
slug: encoding-mismatch
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/initdb/initdb.c:2309"
  - "postgres/src/bin/initdb/initdb.c:2333"
reproduced: false
---

# `encoding mismatch`

## What it means

`initdb` detected that the requested encoding is incompatible with the chosen locale. The message accompanies a detail explaining which encoding and locale conflict.

## When it happens

Running `initdb` with an `--encoding` that the selected `--locale` (LC_CTYPE) does not support — for example forcing `LATIN1` under a UTF-8 locale.

## How to fix

Pick an encoding the locale supports, or a locale that matches the desired encoding. Often the simplest fix is to let `initdb` derive the encoding from the locale, or to use `UTF8` with a UTF-8 locale.

## Example

*Illustrative* — an encoding that clashes with the locale.

```text
initdb: error: encoding mismatch
```

## Related

- [could not get language from locale](./could-not-get-language-from-locale.md)
- [failed to restore old locale](./failed-to-restore-old-locale-a227b9.md)
