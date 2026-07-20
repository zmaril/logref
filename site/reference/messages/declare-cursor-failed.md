---
message: "DECLARE CURSOR failed: %s"
slug: declare-cursor-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/vacuumlo/vacuumlo.c:290"
reproduced: false
---

# `DECLARE CURSOR failed: %s`

## What it means

The `vacuumlo` utility could not declare the cursor it uses to scan for large objects. The trailing text is the server's error. `vacuumlo` opens a cursor to find and remove orphaned large objects.

## When it happens

It fires while `vacuumlo` runs and its `DECLARE CURSOR` is rejected by the server — for example a permission problem, or a connection issue mid-run.

## How to fix

Read the trailing server error for the real cause. Make sure the role `vacuumlo` connects as can read the target tables and the large-object catalog, and that the connection is stable. Fix the reported problem and rerun.

## Example

*Illustrative* — vacuumlo could not declare its cursor.

```text
vacuumlo: error: DECLARE CURSOR failed: ERROR:  permission denied for table pg_largeobject
```

## Related

- [cursor already exists](./cursor-already-exists.md)
- [DECLARE CURSOR must not contain data-modifying statements in WITH](./declare-cursor-must-not-contain-data-modifying-statements-in-with.md)
