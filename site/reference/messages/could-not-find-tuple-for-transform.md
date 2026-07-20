---
message: "could not find tuple for transform %u"
slug: could-not-find-tuple-for-transform
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:4306"
  - "postgres/src/backend/catalog/objectaddress.c:6417"
reproduced: false
---

# `could not find tuple for transform %u`

## What it means

Internal error. A row for a transform could not be found in `pg_transform` by OID while the system expected it to be present. The placeholder is the OID the lookup used. Reaching this point means code held an OID that no longer resolved to a live catalog row.

## When it happens

Concurrent DDL that removed the transform while another command still referenced its OID, or catalog inconsistency. It does not arise from ordinary queries over user data.

## How to fix

If it coincides with concurrent DDL, retry the command. If it recurs, inspect `pg_transform` for the OID; a missing row where one is expected points to catalog damage. Capture the steps and report a reproducible case.

## Example

*Illustrative* — the referenced object vanished mid-operation.

```text
ERROR:  could not find tuple for transform 16412
```

## Related

- [could not find tuple for cast](./could-not-find-tuple-for-cast.md)
- [could not find tuple for amproc entry](./could-not-find-tuple-for-amproc-entry.md)
