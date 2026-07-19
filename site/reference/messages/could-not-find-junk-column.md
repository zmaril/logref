---
message: "could not find junk %s column"
slug: could-not-find-junk-column
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/execMain.c:2660"
  - "postgres/src/backend/executor/execMain.c:2669"
  - "postgres/src/backend/executor/execMain.c:2679"
reproduced: false
---

# `could not find junk %s column`

## What it means

Internal error. The executor could not find a required junk column — a hidden column (like `ctid` or a row identifier) the planner adds to a plan so an `UPDATE`/`DELETE`/`FOR UPDATE` can locate the underlying row. The placeholder names the junk column. Its absence is a plan/executor consistency check.

## When it happens

It does not arise from ordinary SQL. It points to a planner/executor mismatch, or a foreign data wrapper or custom scan that did not emit the expected junk column, rather than to the query text.

## How to fix

Treat it as an internal bug. If a foreign data wrapper or custom scan provider is involved, suspect that it did not project the required row-identity column. Capture the statement and plan and report it.

## Example

*Illustrative* — a missing row-identity junk column.

```text
ERROR:  could not find junk ctid column
```

## Related

- [failed to fetch tuple being updated](./failed-to-fetch-tuple-being-updated.md)
- [ctid is NULL](./ctid-is-null.md)
