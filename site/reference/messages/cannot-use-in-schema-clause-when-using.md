---
message: "cannot use IN SCHEMA clause when using %s"
slug: cannot-use-in-schema-clause-when-using
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_GRANT_OPERATION
    code: "0LP01"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1212"
  - "postgres/src/backend/catalog/aclchk.c:1223"
reproduced: true
---

# `cannot use IN SCHEMA clause when using %s`

## What it means

A `GRANT`/`REVOKE ... IN SCHEMA` combined the `IN SCHEMA` clause with another form that already scopes the objects differently. The placeholder names the conflicting form. The two ways of choosing target objects cannot be used together.

## When it happens

Writing an `ALTER DEFAULT PRIVILEGES` or `GRANT` that specifies `IN SCHEMA` alongside a construct — such as granting on all objects of a kind or on specific named objects — that does not combine with a schema scope.

## How to fix

Choose one scoping mechanism: either use `IN SCHEMA` alone, or the other form alone. Split the command into separate statements if you need both scopes, each valid on its own.

## Example

*Reproduced* — captured from `reproducers/scenarios/49_rls_policies_defaclr.sql`.

```sql
ALTER DEFAULT PRIVILEGES IN SCHEMA acl49 GRANT USAGE ON SCHEMAS TO acl_low;
```

Produces:

```text
ERROR:  cannot use IN SCHEMA clause when using GRANT/REVOKE ON SCHEMAS
```

## Related

- [cannot be specified multiple times](./cannot-be-specified-multiple-times.md)
- [cannot add schema to publication](./cannot-add-schema-to-publication-d50742.md)
