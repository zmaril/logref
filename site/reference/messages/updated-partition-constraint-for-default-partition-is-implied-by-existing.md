---
message: "updated partition constraint for default partition \"%s\" is implied by existing constraints"
slug: updated-partition-constraint-for-default-partition-is-implied-by-existing
passthrough: false
api: [ereport]
level: [DEBUG1]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20924"
  - "postgres/src/backend/partitioning/partbounds.c:3273"
  - "postgres/src/backend/partitioning/partbounds.c:3324"
reproduced: false
---

# `updated partition constraint for default partition "%s" is implied by existing constraints`

## What it means

A debug message noting that, after a partition change, the default partition's implied constraint is already covered by its existing constraints, so no new constraint scan was needed. It records an optimization the planner made during partition maintenance.

## When it happens

Attaching or detaching a partition, when the resulting constraint on the default partition is logically implied by constraints it already has, letting the server skip a validating scan. Debug logging surfaces the decision.

## Is this a problem?

No action is needed. It reports a beneficial shortcut — the default partition did not require a full scan because its existing constraints already guarantee the needed condition. It is diagnostic output about partition maintenance.

## Example

*Illustrative* — a skipped default-partition scan.

```text
DEBUG:  updated partition constraint for default partition "p_default" is implied by existing constraints
```

## Related

- [relation is not a partition of relation](./relation-is-not-a-partition-of-relation.md)
- [no partition of relation found for row](./no-partition-of-relation-found-for-row.md)
