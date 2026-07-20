---
message: "could not find tuple for policy %u"
slug: could-not-find-tuple-for-policy
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4060"
  - "postgres/src/backend/catalog/objectaddress.c:6156"
  - "postgres/src/backend/commands/policy.c:370"
  - "postgres/src/backend/commands/policy.c:464"
reproduced: false
---

# `could not find tuple for policy %u`

## What it means

Internal error. Code looked up a row-security policy's catalog row (`pg_policy`) by OID and did not find it. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP POLICY` while an operation references it; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs, inspect the policies on the affected table; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped policy.

```text
ERROR:  could not find tuple for policy 16430
```

## Related

- [could not find tuple for trigger](./could-not-find-tuple-for-trigger.md)
- [could not find tuple for extension](./could-not-find-tuple-for-extension.md)
