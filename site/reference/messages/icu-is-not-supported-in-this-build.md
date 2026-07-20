---
message: "ICU is not supported in this build"
slug: icu-is-not-supported-in-this-build
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1778"
  - "postgres/src/backend/utils/adt/pg_locale.c:1853"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:413"
  - "postgres/src/bin/initdb/initdb.c:2391"
  - "postgres/src/bin/initdb/initdb.c:2443"
  - "postgres/src/bin/initdb/initdb.c:2537"
reproduced: false
---

# `ICU is not supported in this build`

## What it means

An ICU-based collation or locale feature was requested, but this Postgres build was compiled without ICU support (`--with-icu`). ICU provides rich, version-stable collations; without it, only libc locales are available.

## When it happens

`initdb --locale-provider=icu`, creating an ICU collation, or a database/column that specifies an ICU locale on a build lacking ICU. Common on minimal packages or custom builds that omitted `--with-icu`.

## How to fix

Use a libc-based locale/collation instead, or install/use a Postgres build compiled with ICU (`--with-icu`). Distribution packages usually include ICU; a custom build may not. Check `SELECT icu_version()` or `pg_config` to confirm whether ICU is available. If you need ICU collations, you must run an ICU-enabled build.

## Example

*Illustrative* — requesting an ICU locale on a non-ICU build.

```sh
initdb --locale-provider=icu --icu-locale=en-US -D /data/pg
```

Produces:

```text
initdb: error: ICU is not supported in this build
```

## Related

- [collations are not supported by type %s](./collations-are-not-supported-by-type.md)
- [this build does not support compression with %s](./this-build-does-not-support-compression-with.md)
