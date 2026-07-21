---
message: "unrecognized value for %s option \"%s\": \"%s\""
slug: unrecognized-value-for-option-0dbab1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/explain_state.c:134"
  - "postgres/src/backend/commands/explain_state.c:159"
  - "postgres/src/backend/commands/wait.c:85"
  - "postgres/src/backend/postmaster/checkpointer.c:1015"
  - "postgres/src/backend/replication/walsender.c:1213"
reproduced: true
---

# `unrecognized value for %s option "%s": "%s"`

## What it means

An option was given a value it does not accept. The placeholders are the option context, the option name, and the offending value. This comes from option parsers (like `EXPLAIN`'s) that accept only specific values for an option — for example a format that must be one of a fixed list.

## When it happens

Passing an out-of-set value to an option — for example `EXPLAIN (FORMAT xml_or_json)` with an unrecognized format, or a boolean option given a non-boolean word.

## How to fix

Use one of the option's accepted values. Consult the command's documentation for the valid set (for `FORMAT`: `text`, `xml`, `json`, `yaml`), and correct the value. Boolean options accept `on`/`off`/`true`/`false`/`1`/`0`.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
EXPLAIN (FORMAT nonsense) SELECT 1;
```

Produces:

```text
ERROR:  unrecognized value for EXPLAIN option "format": "nonsense"
```

## Related

- [unrecognized option](./unrecognized-option-8eb055.md)
- [explain option requires analyze](./explain-option-requires-analyze.md)
