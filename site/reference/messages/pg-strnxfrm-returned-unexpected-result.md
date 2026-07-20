---
message: "pg_strnxfrm() returned unexpected result"
slug: pg-strnxfrm-returned-unexpected-result
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/hash/hashfunc.c:306"
  - "postgres/src/backend/access/hash/hashfunc.c:361"
  - "postgres/src/backend/utils/adt/varchar.c:1028"
  - "postgres/src/backend/utils/adt/varchar.c:1085"
reproduced: false
---

# `pg_strnxfrm() returned unexpected result`

## What it means

Internal error. `pg_strnxfrm()` — the wrapper that asks the collation provider (libc `strxfrm` or ICU) to produce a sort key for a string — got back a result inconsistent with what it had been told to expect (typically a length that disagrees with a prior sizing call). It is a sanity check on the provider's behavior.

## When it happens

It should not occur normally. It usually signals a collation provider bug or a mismatch between the collation definitions the database was built with and the ones the OS/ICU library now provides — for example after an OS or ICU upgrade changed collation behavior.

## How to fix

Suspect a collation/provider mismatch first: if it began after an OS or ICU upgrade, the collation version has likely changed — run `REINDEX` on affected text indexes and consider `ALTER COLLATION ... REFRESH VERSION`. If it persists on a stable environment, capture the string and collation and report it as a bug.

## Example

*Illustrative* — emitted internally during sort-key generation.

```text
ERROR:  pg_strnxfrm() returned unexpected result
```

## Related

- [collation mismatch between implicit collations and](./collation-mismatch-between-implicit-collations-and.md)
- [could not create locale](./could-not-create-locale.md)
