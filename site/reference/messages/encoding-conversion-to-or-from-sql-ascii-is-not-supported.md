---
message: "encoding conversion to or from \"SQL_ASCII\" is not supported"
slug: encoding-conversion-to-or-from-sql-ascii-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/conversioncmds.c:81"
reproduced: false
---

# `encoding conversion to or from "SQL_ASCII" is not supported`

## What it means

`CREATE CONVERSION` tried to define a conversion where one side is `SQL_ASCII`. `SQL_ASCII` means "no encoding" — bytes are stored as-is — so conversions to or from it are not defined.

## When it happens

It fires from `CREATE CONVERSION` when either the source or destination encoding is `SQL_ASCII`.

## How to fix

Do not define conversions involving `SQL_ASCII`. If you need real encoding handling, use a specific encoding on both sides. `SQL_ASCII` deliberately performs no conversion, which is also why it can store mixed or invalid byte sequences.

## Example

*Illustrative* — a conversion involving SQL_ASCII.

```sql
CREATE CONVERSION c FOR 'SQL_ASCII' TO 'UTF8' FROM f;
-- encoding conversion to or from "SQL_ASCII" is not supported
```

## Related

- [encoding conversion from to ASCII not supported](./encoding-conversion-from-to-ascii-not-supported.md)
- [Encoding is not allowed as a server-side encoding](./encoding-is-not-allowed-as-a-server-side-encoding.md)
