---
message: "aggregate function cannot register a callback in this context"
slug: aggregate-function-cannot-register-a-callback-in-this-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:4765"
reproduced: false
---

# `aggregate function cannot register a callback in this context`

## What it means

An aggregate's support code tried to register an expression-context callback at a point where the executor does not allow it, which indicates the aggregate is being used in a way its implementation does not support — an internal guard.

## When it happens

It is raised when a custom or built-in aggregate attempts to register a cleanup callback outside the aggregation context that permits it, typically reachable only through an aggregate implemented incorrectly.

## How to fix

This is an internal invariant, most relevant to authors of C-language aggregates. If a specific extension's aggregate triggers it, report it to that extension; there is no SQL-level workaround. Avoid using the offending aggregate in the context that provokes it until fixed.

## Example

*Illustrative* — an aggregate registering a callback where it may not.

```text
ERROR:  aggregate function cannot register a callback in this context
```

## Related

- [array_agg_transfn called in non-aggregate context](./array-agg-transfn-called-in-non-aggregate-context.md)
- [AfterTriggerSaveEvent() called outside of query](./aftertriggersaveevent-called-outside-of-query.md)
