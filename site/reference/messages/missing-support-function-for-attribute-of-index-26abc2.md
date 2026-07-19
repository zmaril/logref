---
message: "missing support function %d for attribute %d of index \"%s\""
slug: missing-support-function-for-attribute-of-index-26abc2
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gist/gistscan.c:310"
  - "postgres/src/backend/access/index/indexam.c:924"
  - "postgres/src/backend/utils/adt/selfuncs.c:8500"
reproduced: false
---

# `missing support function %d for attribute %d of index "%s"`

## What it means

Internal error. An index scan needed a numbered support function for one of the indexed columns, and the column's operator class did not provide it. The access method depends on that support function to interpret the column, and its absence stops the scan.

## When it happens

It should not occur for indexes built with complete, valid operator classes. Reaching it points to an incomplete or damaged operator class — often from a custom or extension-provided one — rather than to your query.

## How to fix

Check the operator class for the indexed column's type. If it comes from an extension, update or reinstall the extension so the class is complete; if it is custom, add the missing support function with `ALTER OPERATOR FAMILY`. Rebuilding the index after fixing the class clears stale plans.

## Example

*Illustrative* — a missing support function during an index scan.

```text
ERROR:  missing support function 3 for attribute 1 of index "my_idx"
```

## Related

- [missing support function for attribute of index](./missing-support-function-for-attribute-of-index-34bf15.md)
- [operator class of access method is missing support function](./operator-class-of-access-method-is-missing-support-function.md)
