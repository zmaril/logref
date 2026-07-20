---
message: "could not determine row type for result of %s"
slug: could-not-determine-row-type-for-result-of
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/jsonfuncs.c:3670"
reproduced: false
---

# `could not determine row type for result of %s`

## What it means

A JSON-to-record function could not determine the row type to shape its result into. The `%s` names the operation. Without a known target row type it cannot build the output rows.

## When it happens

It happens with functions like `json_populate_record`/`json_to_recordset` when the target record type cannot be determined — for example a bare `record` result with no column definition list.

## How to fix

Supply the target row type: pass a concrete composite type or add a column definition list. These functions need to know the exact columns and types they are populating.

## Example

*Illustrative* — a JSON record function with no target row type.

```sql
SELECT * FROM json_to_recordset('[{"a":1}]');
-- ERROR:  could not determine row type for result of json_to_recordset
```

## Related

- [could not determine row description for function returning record](./could-not-determine-row-description-for-function-returning-record.md)
- [could not determine actual result type for function declared to return type](./could-not-determine-actual-result-type-for-function-declared-to-return-type.md)
