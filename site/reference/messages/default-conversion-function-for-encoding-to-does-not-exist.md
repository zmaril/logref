---
message: "default conversion function for encoding \"%s\" to \"%s\" does not exist"
slug: default-conversion-function-for-encoding-to-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/commands/copyfrom.c:1728"
reproduced: false
---

# `default conversion function for encoding "%s" to "%s" does not exist`

## What it means

`COPY` needed to convert data between the client encoding and the server encoding, and no default conversion is registered for that pair. The placeholders are the two encoding names.

## When it happens

It fires during `COPY FROM`/`COPY TO` when the client and server encodings differ and PostgreSQL has no built-in or user-defined default conversion to translate between them.

## How to fix

Set a client encoding that has a conversion path to the server encoding (`SET client_encoding`), or register a default conversion for the pair with `CREATE DEFAULT CONVERSION`. Most standard encodings ship with conversions; an unusual pair may simply be unsupported.

## Example

*Illustrative* — copying between encodings with no conversion.

```text
ERROR:  default conversion function for encoding "UTF8" to "MULE_INTERNAL" does not exist
```

## Related

- [default conversion for to already exists](./default-conversion-for-to-already-exists.md)
- [encoding conversion from to ASCII not supported](./encoding-conversion-from-to-ascii-not-supported.md)
