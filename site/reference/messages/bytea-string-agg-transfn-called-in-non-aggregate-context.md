---
message: "bytea_string_agg_transfn called in non-aggregate context"
slug: bytea-string-agg-transfn-called-in-non-aggregate-context
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/bytea.c:416"
reproduced: false
---

# `bytea_string_agg_transfn called in non-aggregate context`

## What it means

The transition function behind `string_agg` for `bytea` was invoked outside an aggregate. Aggregate transition functions rely on aggregate machinery to manage their state and cannot run as ordinary function calls. It is an internal guard.

## When it happens

It is a can't-happen check that would only appear if the internal function were called directly rather than through an aggregate, not from normal `string_agg` use.

## How to fix

There is no user action for normal SQL. Use `string_agg` as an aggregate; if the error appears from an extension calling internals directly, report it to that extension's author.

## Example

*Illustrative* — the aggregate-context guard.

```text
ERROR:  bytea_string_agg_transfn called in non-aggregate context
```

## Related

- [cannot accumulate empty arrays](./cannot-accumulate-empty-arrays.md)
- [cache entry already complete](./cache-entry-already-complete.md)
