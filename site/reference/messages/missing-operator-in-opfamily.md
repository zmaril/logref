---
message: "missing operator %d(%u,%u) in opfamily %u"
slug: missing-operator-in-opfamily
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/postgres_fdw/deparse.c:4035"
  - "postgres/src/backend/access/brin/brin_inclusion.c:647"
  - "postgres/src/backend/access/brin/brin_minmax.c:300"
  - "postgres/src/backend/access/brin/brin_minmax_multi.c:2935"
  - "postgres/src/backend/access/nbtree/nbtpreprocesskeys.c:2605"
  - "postgres/src/backend/catalog/index.c:2721"
  - "postgres/src/backend/commands/repack.c:3127"
  - "postgres/src/backend/commands/tablecmds.c:10527"
  - "postgres/src/backend/executor/execReplication.c:103"
  - "postgres/src/backend/optimizer/path/indxpath.c:3653"
  - "postgres/src/backend/optimizer/path/pathkeys.c:227"
  - "postgres/src/backend/optimizer/plan/createplan.c:2988"
  - "postgres/src/backend/optimizer/plan/createplan.c:6330"
  - "postgres/src/backend/optimizer/plan/createplan.c:6804"
  - "postgres/src/backend/optimizer/plan/initsplan.c:1056"
reproduced: false
---

# `missing operator %d(%u,%u) in opfamily %u`

## What it means

Internal error. An index access method needed a specific support operator from an operator family and did not find it. The placeholders identify the strategy number, the left/right type OIDs, and the operator family OID. The opfamily is incomplete for the operation the planner or index build tried to perform.

## When it happens

A custom or contrib operator family that is missing an operator it should provide, or a mismatch between an index/opclass and the operators available. It surfaces during index build, planning, or scans that rely on the missing operator.

## How to fix

Suspect the operator family definition — usually a custom or third-party one that is incomplete. Compare its `CREATE OPERATOR CLASS`/`ALTER OPERATOR FAMILY` definitions against what the access method requires (every declared strategy needs a corresponding operator). If it appeared after an extension upgrade, the SQL and binary may be out of sync. Report reproducible cases against a specific opfamily.

## Example

*Illustrative* — an incomplete operator family used by an index.

```text
ERROR:  missing operator 1(23,23) in opfamily 16670
```

## Related

- [cache lookup failed for operator class](./cache-lookup-failed-for-operator-class.md)
- [unrecognized strategy number](./unrecognized-strategy-number.md)
