---
message: "boolean jsonpath item cannot have next item"
slug: boolean-jsonpath-item-cannot-have-next-item
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/jsonpath_exec.c:1832"
reproduced: false
---

# `boolean jsonpath item cannot have next item`

## What it means

A `jsonpath` expression placed an accessor after a boolean predicate item, but a predicate that yields true or false cannot be followed by further path steps. The boolean result is terminal.

## When it happens

It occurs when a `jsonpath` expression chains something after a predicate, such as appending an accessor to a comparison or `like_regex` result.

## How to fix

End the path at the boolean predicate, or restructure it so the predicate applies inside a filter `? (...)` rather than being followed by more steps. Predicates belong at the end or within a filter, not in the middle of an accessor chain.

## Example

*Illustrative* — a step after a boolean predicate.

```sql
SELECT jsonb_path_query('1', '($ == 1).type()');
```

## Related

- [bit width must be between 4 and 16 inclusive](./bit-width-must-be-between-4-and-16-inclusive.md)
- [bogus lower boundary types](./bogus-lower-boundary-types.md)
