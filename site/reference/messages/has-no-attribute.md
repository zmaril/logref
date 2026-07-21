---
message: "\"%s\" has no attribute \"%s\""
slug: has-no-attribute
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_TRIGGERED_ACTION_EXCEPTION
    code: "09000"
call_sites:
  - "postgres/contrib/spi/autoinc.c:81"
  - "postgres/contrib/spi/insert_username.c:74"
  - "postgres/contrib/spi/moddatetime.c:95"
reproduced: false
---

# `"%s" has no attribute "%s"`

## What it means

A trigger function (here the `autoinc` `spi` example) referenced a column by name on the row that the table does not have. The placeholders are the relation/row and the attribute name. The trigger was configured with a column argument that does not match a real column of the table it is attached to.

## When it happens

Attaching a generic trigger function that takes column-name arguments (like `autoinc`, `insert_username`, or similar `contrib/spi` triggers) to a table, and passing a column name that is misspelled or absent.

## How to fix

Pass the trigger the name of a column that exists on the table, matching spelling and case. Check the `CREATE TRIGGER ... EXECUTE FUNCTION fn('colname')` arguments against the table's actual columns (`\d table`).

## Example

*Illustrative* — a trigger argument naming a missing column.

```text
ERROR:  "t" has no attribute "missing_col"
```

## Related

- [column named in key does not exist](./column-named-in-key-does-not-exist.md)
- [unrecognized OP tg_event](./unrecognized-op-tg-event.md)
