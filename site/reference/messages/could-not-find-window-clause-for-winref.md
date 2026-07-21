---
message: "could not find window clause for winref %u"
slug: could-not-find-window-clause-for-winref
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ruleutils.c:11707"
  - "postgres/src/backend/utils/adt/ruleutils.c:11732"
reproduced: false
---

# `could not find window clause for winref %u`

## What it means

Internal error raised while deparsing a plan or rule back to SQL text. A window-function reference (`winref`) pointed at a window clause that the deparser could not locate in the query. The placeholder is the window index.

## When it happens

It fires inside `pg_get_ruledef`, `EXPLAIN`, or view-definition reconstruction over a plan whose window bookkeeping is inconsistent. Ordinary query execution does not raise it.

## How to fix

This is a can't-happen consistency check, not a user-fixable condition. If you hit it, note the query or view being described and report it as a bug with a reproducible case.

## Example

*Illustrative* — deparsing a window query with an unresolved reference.

```text
ERROR:  could not find window clause for winref 2
```

## Related

- [could not find tuple for constraint](./could-not-find-tuple-for-constraint.md)
- [failed to find relation in joinlist](./failed-to-find-relation-in-joinlist.md)
