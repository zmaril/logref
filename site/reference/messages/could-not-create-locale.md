---
message: "could not create locale \"%s\": %m"
slug: could-not-create-locale
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:1184"
reproduced: true
---

# `could not create locale "%s": %m`

## What it means

PostgreSQL could not build a locale object for the requested locale name under the libc provider. The `%m` reason gives the OS error. The named locale could not be initialized.

## When it happens

It happens when a collation or database references a libc locale that is not installed or is invalid on this host — for example a locale used at initdb time that was later removed.

## How to fix

Install the missing locale on the host (`locale -a` lists what is available; on Debian-family systems `locale-gen` adds one) or point the affected object at a locale that exists. Restart is not needed once the locale is present.

## Example

*Reproduced* — captured from `reproducers/scenarios/21_ddl_objects.sql`.

```sql
CREATE COLLATION repro.badcoll (LOCALE = 'nonexistent_xyz');
```

Produces:

```text
ERROR:  could not create locale "nonexistent_xyz": No such file or directory
```

## Related

- [could not compare Unicode strings](./could-not-compare-unicode-strings.md)
- [could not determine which collation to use for regular expression](./could-not-determine-which-collation-to-use-for-regular-expression.md)
