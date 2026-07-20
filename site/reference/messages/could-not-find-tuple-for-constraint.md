---
message: "could not find tuple for constraint %u"
slug: could-not-find-tuple-for-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/index.c:1701"
  - "postgres/src/backend/utils/adt/ruleutils.c:2592"
reproduced: false
---

# `could not find tuple for constraint %u`

## What it means

Internal error. A row for a constraint could not be found in `pg_constraint` by OID while the system expected it to be present. The placeholder is the OID the lookup used. Reaching this point means code held an OID that no longer resolved to a live catalog row.

## When it happens

Concurrent DDL that removed the constraint while another command still referenced its OID, or catalog inconsistency. It does not arise from ordinary queries over user data.

## How to fix

If it coincides with concurrent DDL, retry the command. If it recurs, inspect `pg_constraint` for the OID; a missing row where one is expected points to catalog damage. Capture the steps and report a reproducible case.

## Example

*Illustrative* — the referenced object vanished mid-operation.

```text
ERROR:  could not find tuple for constraint 16412
```

## Related

- [could not find tuple for cast](./could-not-find-tuple-for-cast.md)
- [could not find tuple for function](./could-not-find-tuple-for-function.md)
