---
message: "could not find tuple for element label %u"
slug: could-not-find-tuple-for-element-label
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4128"
  - "postgres/src/backend/catalog/objectaddress.c:6257"
reproduced: false
---

# `could not find tuple for element label %u`

## What it means

Internal error. A row for a element label could not be found in `pg_enum` by OID while the system expected it to be present. The placeholder is the OID the lookup used. Reaching this point means code held an OID that no longer resolved to a live catalog row.

## When it happens

Concurrent DDL that removed the element label while another command still referenced its OID, or catalog inconsistency. It does not arise from ordinary queries over user data.

## How to fix

If it coincides with concurrent DDL, retry the command. If it recurs, inspect `pg_enum` for the OID; a missing row where one is expected points to catalog damage. Capture the steps and report a reproducible case.

## Example

*Illustrative* — the referenced object vanished mid-operation.

```text
ERROR:  could not find tuple for element label 16412
```

## Related

- [could not find tuple for label property](./could-not-find-tuple-for-label-property.md)
- [could not find tuple for transform](./could-not-find-tuple-for-transform.md)
