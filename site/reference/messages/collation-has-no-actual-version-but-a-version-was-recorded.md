---
message: "collation \"%s\" has no actual version, but a version was recorded"
slug: collation-has-no-actual-version-but-a-version-was-recorded
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/pg_locale.c:1103"
reproduced: false
---

# `collation "%s" has no actual version, but a version was recorded`

## What it means

A collation's catalog entry records a version string, but the collation provider now reports no version for it. The mismatch means the recorded version cannot be checked against the provider, which the server flags.

## When it happens

It is reached during collation version checks, for example after an operating-system or ICU change altered how a collation reports its version.

## How to fix

Refresh the recorded version with `ALTER COLLATION ... REFRESH VERSION` once you confirm indexes using the collation are consistent. Investigate the provider change that removed the version, and reindex affected objects if collation behavior changed.

## Example

*Illustrative* — a recorded version with none reported.

```text
ERROR:  collation "mycoll" has no actual version, but a version was recorded
```

## Related

- [collation with OID does not exist](./collation-with-oid-does-not-exist.md)
- [collations with different collate and ctype values are not supported on this](./collations-with-different-collate-and-ctype-values-are-not-supported-on-this.md)
