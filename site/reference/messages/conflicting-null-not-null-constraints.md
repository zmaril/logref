---
message: "conflicting NULL/NOT NULL constraints"
slug: conflicting-null-not-null-constraints
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:947"
  - "postgres/src/backend/commands/typecmds.c:968"
reproduced: false
---

# `conflicting NULL/NOT NULL constraints`

## What it means

A domain or column definition specified both NULL and NOT NULL for the same target. The two are contradictory — a value cannot be required to be null-allowed and null-forbidden at once — so the definition is rejected.

## When it happens

Creating a domain (`CREATE DOMAIN ... NOT NULL NULL`) or a column definition that lists both NULL and NOT NULL, usually from generated DDL that appends conflicting constraints.

## How to fix

Specify only one of NULL or NOT NULL. Decide the intended nullability and remove the contradictory keyword from the domain or column definition.

## Example

*Illustrative* — a domain declared both NULL and NOT NULL.

```sql
CREATE DOMAIN d AS int NOT NULL NULL;
-- ERROR:  conflicting NULL/NOT NULL constraints
```

## Related

- [conflicting not-null constraint names and](./conflicting-not-null-constraint-names-and.md)
- [constraint declared INITIALLY DEFERRED must be DEFERRABLE](./constraint-declared-initially-deferred-must-be-deferrable.md)
