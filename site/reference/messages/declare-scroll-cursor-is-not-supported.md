---
message: "DECLARE SCROLL CURSOR ... %s is not supported"
slug: declare-scroll-cursor-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3421"
reproduced: false
---

# `DECLARE SCROLL CURSOR ... %s is not supported`

## What it means

A `DECLARE SCROLL CURSOR` used a query construct that cannot be fetched backward. The placeholder names the construct. `SCROLL` requires the executor to reposition a cursor in either direction, which some plans cannot do.

## When it happens

It fires while analyzing a `DECLARE SCROLL` whose query contains something non-reversible, such as a `FOR UPDATE`/`FOR SHARE` locking clause on a plan that does not support backward scan.

## How to fix

Remove `SCROLL` so the cursor is forward-only, or rewrite the query so its plan supports backward fetching (for example, drop the offending clause). If you must scroll, materialize the result first — for instance with `WITH HOLD` or by selecting into a temporary table.

## Example

*Illustrative* — a scrollable cursor over an unsupported construct.

```sql
DECLARE c SCROLL CURSOR FOR SELECT * FROM t FOR UPDATE;
```

## Related

- [DECLARE SCROLL CURSOR ... FOR UPDATE/SHARE is not supported](./declare-scroll-cursor-for-update-share-is-not-supported.md)
- [DECLARE INSENSITIVE CURSOR ... is not valid](./declare-insensitive-cursor-is-not-valid.md)
