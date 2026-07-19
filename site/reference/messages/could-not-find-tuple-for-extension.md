---
message: "could not find tuple for extension %u"
slug: could-not-find-tuple-for-extension
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:2925"
  - "postgres/src/backend/commands/extension.c:3122"
  - "postgres/src/backend/commands/extension.c:3317"
  - "postgres/src/backend/commands/extension.c:3669"
reproduced: false
---

# `could not find tuple for extension %u`

## What it means

Internal error. Code looked up an extension's catalog row (`pg_extension`) by OID and did not find it. The placeholder is the OID. A missing row for an OID in active use usually means the extension was dropped concurrently or the catalog is inconsistent.

## When it happens

Typically a concurrent `DROP EXTENSION` while an operation references it (for example during `ALTER EXTENSION`); otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs without concurrent drops, inspect the extension and its member objects; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped extension.

```text
ERROR:  could not find tuple for extension 16420
```

## Related

- [could not find tuple for policy](./could-not-find-tuple-for-policy.md)
- [extconfig and extcondition arrays do not match](./extconfig-and-extcondition-arrays-do-not-match.md)
