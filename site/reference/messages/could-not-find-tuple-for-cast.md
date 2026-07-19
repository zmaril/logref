---
message: "could not find tuple for cast %u"
slug: could-not-find-tuple-for-cast
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3095"
  - "postgres/src/backend/catalog/objectaddress.c:5218"
reproduced: false
---

# `could not find tuple for cast %u`

## What it means

Internal error. A row for a cast could not be found in `pg_cast` by OID while the system expected it to be present. The placeholder is the OID the lookup used. Reaching this point means code held an OID that no longer resolved to a live catalog row.

## When it happens

Concurrent DDL that removed the cast while another command still referenced its OID, or catalog inconsistency. It does not arise from ordinary queries over user data.

## How to fix

If it coincides with concurrent DDL, retry the command. If it recurs, inspect `pg_cast` for the OID; a missing row where one is expected points to catalog damage. Capture the steps and report a reproducible case.

## Example

*Illustrative* — the referenced object vanished mid-operation.

```text
ERROR:  could not find tuple for cast 16412
```

## Related

- [could not find tuple for amproc entry](./could-not-find-tuple-for-amproc-entry.md)
- [could not find tuple for transform](./could-not-find-tuple-for-transform.md)
