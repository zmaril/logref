---
message: "could not find tuple for function %u"
slug: could-not-find-tuple-for-function
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/sepgsql/proc.c:69"
  - "postgres/contrib/sepgsql/proc.c:262"
reproduced: false
---

# `could not find tuple for function %u`

## What it means

Internal error from the SELinux integration (`sepgsql`). A row for a function could not be found in `pg_proc` by OID while assigning or checking its security label. The placeholder is the OID the lookup used.

## When it happens

A concurrent `DROP FUNCTION` removing the row while `sepgsql` still referenced its OID, or catalog inconsistency. It fires only when the `sepgsql` extension is active.

## How to fix

If concurrent function DDL was running under `sepgsql`, retry. If it persists, inspect `pg_proc` for the OID; a missing row indicates catalog damage. Capture the reproduction and report it.

## Example

*Illustrative* — a function dropped while `sepgsql` labelled it.

```text
ERROR:  could not find tuple for function 16480
```

## Related

- [could not find tuple for cast](./could-not-find-tuple-for-cast.md)
- [could not find tuple for constraint](./could-not-find-tuple-for-constraint.md)
