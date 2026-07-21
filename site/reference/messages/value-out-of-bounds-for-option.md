---
message: "value %s out of bounds for option \"%s\""
slug: value-out-of-bounds-for-option
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/access/common/reloptions.c:1745"
  - "postgres/src/backend/access/common/reloptions.c:1765"
reproduced: true
---

# `value %s out of bounds for option "%s"`

## What it means

An option was given a value outside the range that option accepts, so the setting was rejected.

## When it happens

It arises when setting an object option (for example a storage parameter, an operator-class option, or an access-method option) to a number beyond its allowed minimum or maximum.

## How to fix

Choose a value within the option's documented range. The message names the option; consult its documentation for the valid bounds and set a value inside them.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at SET (fillfactor = 5000);
```

Produces:

```text
ERROR:  value 5000 out of bounds for option "fillfactor"
```

## Related

- [weight out of range](./weight-out-of-range.md)
- [version to install must be specified](./version-to-install-must-be-specified.md)
