---
message: "duplicate JSON object key value: %s"
slug: duplicate-json-object-key-value-07bbf7
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_JSON_OBJECT_KEY_VALUE
    code: "22030"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:1094"
  - "postgres/src/backend/utils/adt/json.c:1265"
reproduced: false
---

# `duplicate JSON object key value: %s`

## What it means

A JSON value was built or parsed with a duplicate object key while duplicate keys are disallowed. The `%s` is the repeated key. This variant reports the specific key that collided.

## When it happens

Constructing JSON with `json_object`/`jsonb_object` from inputs that repeat a key, or parsing under a path that rejects duplicates, when two entries share a key.

## How to fix

Ensure object keys are unique in the input, or de-duplicate before building the JSON. Use `jsonb` (which keeps the last value per key) if last-wins semantics are acceptable.

## Example

*Illustrative* — a repeated key during JSON construction.

```text
ERROR:  duplicate JSON object key value: color
```

## Related

- [duplicate JSON object key value](./duplicate-json-object-key-value-e1e510.md)
- [duplicate JSON_TABLE column or path name](./duplicate-json-table-column-or-path-name.md)
