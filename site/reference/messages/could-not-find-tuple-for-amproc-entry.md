---
message: "could not find tuple for amproc entry %u"
slug: could-not-find-tuple-for-amproc-entry
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:3422"
  - "postgres/src/backend/catalog/objectaddress.c:5563"
reproduced: false
---

# `could not find tuple for amproc entry %u`

## What it means

Internal error. A row for a amproc entry could not be found in `pg_amproc` by OID while the system expected it to be present. The placeholder is the OID the lookup used. Reaching this point means code held an OID that no longer resolved to a live catalog row.

## When it happens

Concurrent DDL that removed the amproc entry while another command still referenced its OID, or catalog inconsistency. It does not arise from ordinary queries over user data.

## How to fix

If it coincides with concurrent DDL, retry the command. If it recurs, inspect `pg_amproc` for the OID; a missing row where one is expected points to catalog damage. Capture the steps and report a reproducible case.

## Example

*Illustrative* — the referenced object vanished mid-operation.

```text
ERROR:  could not find tuple for amproc entry 16412
```

## Related

- [could not find tuple for cast](./could-not-find-tuple-for-cast.md)
- [could not find tuple for constraint](./could-not-find-tuple-for-constraint.md)
