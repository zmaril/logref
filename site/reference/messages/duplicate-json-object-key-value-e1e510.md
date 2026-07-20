---
message: "duplicate JSON object key value"
slug: duplicate-json-object-key-value-e1e510
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_JSON_OBJECT_KEY_VALUE
    code: "22030"
call_sites:
  - "postgres/src/backend/utils/adt/json.c:1818"
  - "postgres/src/backend/utils/adt/jsonb_util.c:2083"
reproduced: false
---

# `duplicate JSON object key value`

## What it means

A JSON operation encountered a duplicate object key where duplicates are not allowed. This variant reports the condition without naming the specific key.

## When it happens

Building or normalizing a JSON object (for example via `jsonb` uniqueness enforcement) whose input repeats a key.

## How to fix

Remove duplicate keys from the input, or accept last-wins behavior with `jsonb`. Validate the source data for repeated keys before constructing the object.

## Example

*Illustrative* — a duplicate key with no key named.

```text
ERROR:  duplicate JSON object key value
```

## Related

- [duplicate JSON object key value](./duplicate-json-object-key-value-07bbf7.md)
- [duplicate JSON_TABLE column or path name](./duplicate-json-table-column-or-path-name.md)
