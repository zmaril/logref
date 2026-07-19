---
message: "cannot assign new OID to existing shell type"
slug: cannot-assign-new-oid-to-existing-shell-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_type.c:442"
reproduced: false
---

# `cannot assign new OID to existing shell type`

## What it means

An internal guard in the type catalog: code tried to assign a fresh OID to a shell type that already exists. A shell type is a placeholder created before its full definition; once it has an OID, it keeps it, so reassigning is a consistency error.

## When it happens

It is a can't-happen check in `pg_type.c` reached while defining a base type in two steps. It would only appear from a bug in type-definition code.

## How to fix

There is no user-level fix. If it appears while creating a type, capture the `CREATE TYPE` sequence and any extension involved and report it as a possible bug.

## Example

*Illustrative* — the internal shell-type guard.

```text
ERROR:  cannot assign new OID to existing shell type
```

## Related

- [cannot apply resourceowner to non-saved cached plan](./cannot-apply-resourceowner-to-non-saved-cached-plan.md)
- [cannot change schema of composite type](./cannot-change-schema-of-composite-type.md)
