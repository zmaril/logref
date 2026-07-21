---
message: "%s is not allowed with UNION/INTERSECT/EXCEPT"
slug: is-not-allowed-with-union-intersect-except
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:1778"
  - "postgres/src/backend/parser/analyze.c:2184"
  - "postgres/src/backend/parser/analyze.c:2443"
  - "postgres/src/backend/parser/analyze.c:3747"
reproduced: true
---

# `%s is not allowed with UNION/INTERSECT/EXCEPT`

## What it means

A clause was used together with a set operation (`UNION`/`INTERSECT`/`EXCEPT`) where it is not permitted. The placeholder names the offending clause. Certain clauses (like `SELECT INTO`, `FOR UPDATE`, or others depending on context) cannot be attached directly to a set-operation query.

## When it happens

Writing a set-operation query with a clause that must apply to a single query — for example a locking clause (`FOR UPDATE`) or `INTO` on a `UNION`.

## How to fix

Move the clause to a place where it is allowed: wrap the set operation in a subquery and apply the clause outside it, or restructure so the clause attaches to a plain `SELECT`. For locking, apply `FOR UPDATE` to the underlying tables via a subquery rather than the whole union.

## Example

*Reproduced* — captured from `reproducers/scenarios/38_planner_executor_runtime.sql`.

```sql
SELECT id FROM repro.parent UNION SELECT id FROM repro.child FOR UPDATE;
```

Produces:

```text
ERROR:  FOR UPDATE is not allowed with UNION/INTERSECT/EXCEPT
```

## Related

- [conditional UNION/INTERSECT/EXCEPT statements are not implemented](./conditional-union-intersect-except-statements-are-not-implemented.md)
- [foreign key constraints are not supported on foreign tables](./foreign-key-constraints-are-not-supported-on-foreign-tables.md)
