---
message: "enum label \"%s\" already exists"
slug: enum-label-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_enum.c:361"
  - "postgres/src/backend/catalog/pg_enum.c:679"
reproduced: true
---

# `enum label "%s" already exists`

## What it means

An `ALTER TYPE ... ADD VALUE` tried to add an enum label that already exists in the type. The `%s` is the label. Enum labels must be unique within a type.

## When it happens

Adding a label whose name matches an existing one, for example re-running a migration that already added it, without `IF NOT EXISTS`.

## How to fix

Use `ADD VALUE IF NOT EXISTS` to make it idempotent, or choose a label name not already present. Check the current labels before adding.

## Example

*Reproduced* — captured from `reproducers/scenarios/20_network_geo_enum_ts_xml.sql`.

```sql
ALTER TYPE repro.mood ADD VALUE 'ok';
```

Produces:

```text
ERROR:  enum label "ok" already exists
```

## Related

- [enum contains no values](./enum-contains-no-values.md)
- [enum value not found in cache for enum](./enum-value-not-found-in-cache-for-enum.md)
