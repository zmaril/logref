---
message: "option \"%s\" not recognized"
slug: option-not-recognized
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:945"
  - "postgres/src/backend/commands/copy.c:778"
  - "postgres/src/backend/commands/foreigncmds.c:599"
  - "postgres/src/backend/commands/functioncmds.c:814"
  - "postgres/src/backend/commands/functioncmds.c:1425"
  - "postgres/src/backend/commands/functioncmds.c:2116"
  - "postgres/src/backend/commands/sequence.c:1366"
  - "postgres/src/backend/commands/tablecmds.c:8549"
  - "postgres/src/backend/commands/user.c:282"
  - "postgres/src/backend/commands/user.c:734"
  - "postgres/src/backend/commands/wait.c:142"
reproduced: false
---

# `option "%s" not recognized`

## What it means

A command's option list contained an option name it does not support. The placeholder is the unrecognized option. Postgres validates option names against the fixed set each command accepts and rejects anything unknown.

## When it happens

A `WITH (...)` clause, `COPY` option list, foreign-data-wrapper option, or function/collation option that names something misspelled or not valid for that command. It also appears when an option was valid in a different context but not this one.

## How to fix

Check the spelling and the command's documentation for the accepted options. Options are command- and object-specific — an option valid for `COPY` may not be valid for `CREATE FUNCTION`. Remove or correct the unrecognized option.

## Example

*Illustrative* — a misspelled COPY option.

```sql
COPY t FROM STDIN WITH (formatt csv);
```

Produces:

```text
ERROR:  option "formatt" not recognized
```

## Related

- [duplicate option](./duplicate-option.md)
- [conflicting or redundant options](./conflicting-or-redundant-options.md)
