---
message: "could not find tuple for trigger %u"
slug: could-not-find-tuple-for-trigger
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3532"
  - "postgres/src/backend/catalog/objectaddress.c:5645"
  - "postgres/src/backend/commands/trigger.c:1260"
  - "postgres/src/backend/commands/trigger.c:1329"
reproduced: false
---

# `could not find tuple for trigger %u`

## What it means

Internal error. Code looked up a trigger's catalog row (`pg_trigger`) by OID and did not find it. The placeholder is the OID. A missing row for an OID in active use points to a concurrent drop or catalog inconsistency.

## When it happens

Typically a concurrent `DROP TRIGGER` (or dropping the table/function it depends on) while an operation references it; otherwise catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL, retry. If it recurs, inspect the triggers on the affected table; a persistently missing row indicates corruption warranting investigation.

## Example

*Illustrative* — a concurrently dropped trigger.

```text
ERROR:  could not find tuple for trigger 16440
```

## Related

- [could not find tuple for policy](./could-not-find-tuple-for-policy.md)
- [could not find tuple for extension](./could-not-find-tuple-for-extension.md)
