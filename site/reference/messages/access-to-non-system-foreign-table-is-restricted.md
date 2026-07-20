---
message: "access to non-system foreign table is restricted"
slug: access-to-non-system-foreign-table-is-restricted
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/foreign/foreign.c:366"
  - "postgres/src/backend/optimizer/plan/createplan.c:7169"
  - "postgres/src/backend/optimizer/util/plancat.c:540"
reproduced: false
---

# `access to non-system foreign table is restricted`

## What it means

Access to a user (non-system) foreign table was blocked by the `restrict_nonsystem_relation_kind` safety setting. That option, used during restore and by cautious deployments, prevents queries from touching foreign tables (and sometimes views) because they can execute arbitrary remote code as a side effect of a `SELECT`.

## When it happens

Querying a foreign table while `restrict_nonsystem_relation_kind` includes `foreign-table` — most commonly inside `pg_restore`/`pg_dump` runs, which set it to avoid triggering foreign-server access during a restore.

## How to fix

If the restriction is intentional (a restore, or a hardened session), do not query the foreign table in that context — the safety setting is doing its job. If you legitimately need access, remove `foreign-table` from `restrict_nonsystem_relation_kind` for the session (`SET restrict_nonsystem_relation_kind = ''`) with an understanding of the remote-execution implications.

## Example

*Illustrative* — a foreign table blocked by the restriction.

```text
ERROR:  access to non-system foreign table is restricted
```

## Related

- [cannot lock rows in foreign table](./cannot-lock-rows-in-foreign-table.md)
- [cannot collect transition tuples from child foreign tables](./cannot-collect-transition-tuples-from-child-foreign-tables.md)
