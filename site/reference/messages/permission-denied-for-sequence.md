---
message: "permission denied for sequence %s"
slug: permission-denied-for-sequence
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/sequence.c:653"
  - "postgres/src/backend/commands/sequence.c:879"
  - "postgres/src/backend/commands/sequence.c:921"
  - "postgres/src/backend/commands/sequence.c:962"
  - "postgres/src/backend/commands/sequence.c:1756"
reproduced: false
---

# `permission denied for sequence %s`

## What it means

The current role lacks the privilege required for a sequence operation. The placeholder is the sequence name. `nextval`/`setval` need `USAGE` or `UPDATE`; `currval` and `SELECT`-style reads need `SELECT` or `USAGE`.

## When it happens

Calling `nextval('seq')`, `setval`, or `currval`, or inserting into a table whose serial/identity column draws from a sequence the role has no privilege on.

## How to fix

Grant the needed privilege on the sequence: `GRANT USAGE ON SEQUENCE seq TO role` (covers `nextval`/`currval`) or `GRANT SELECT`/`UPDATE` as appropriate. For identity/serial columns, granting on the table's sequence lets inserts advance it. Owned-by sequences inherit some access, but explicit grants are often required.

## Example

*Illustrative* — nextval without USAGE.

```sql
SELECT nextval('orders_id_seq');
```

## Related

- [permission denied for large object](./permission-denied-for-large-object.md)
- [permission denied to create role](./permission-denied-to-create-role.md)
