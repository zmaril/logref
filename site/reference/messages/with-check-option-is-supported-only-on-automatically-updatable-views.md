---
message: "WITH CHECK OPTION is supported only on automatically updatable views"
slug: with-check-option-is-supported-only-on-automatically-updatable-views
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:17453"
  - "postgres/src/backend/commands/view.c:438"
reproduced: true
---

# `WITH CHECK OPTION is supported only on automatically updatable views`

## What it means

A `WITH CHECK OPTION` was requested on a view that is not automatically updatable, so the check cannot be enforced.

## When it happens

It arises from `CREATE VIEW ... WITH CHECK OPTION` when the view's definition is too complex to be automatically updatable — it uses joins, aggregates, `DISTINCT`, or other constructs that block automatic updatability.

## How to fix

Simplify the view so it qualifies as automatically updatable (a single base relation, no aggregation or set operations), or make it updatable through `INSTEAD OF` triggers and enforce the check within them. Remove `WITH CHECK OPTION` if enforcement is not required.

## Example

*Reproduced* — captured from `reproducers/scenarios/35_ddl_object_lifecycle.sql`.

```sql
CREATE VIEW s35.nonupd_v WITH (check_option = cascaded) AS
    SELECT count(*) AS n FROM s35.base;
```

Produces:

```text
ERROR:  WITH CHECK OPTION is supported only on automatically updatable views
```

## Related

- [WHERE CURRENT OF on a view is not implemented](./where-current-of-on-a-view-is-not-implemented.md)
- [updated partition constraint for default partition "%s" would be violated by some row](./updated-partition-constraint-for-default-partition-would-be-violated-by-some-row.md)
