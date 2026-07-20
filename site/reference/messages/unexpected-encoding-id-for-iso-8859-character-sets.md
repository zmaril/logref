---
message: "unexpected encoding ID %d for ISO 8859 character sets"
slug: unexpected-encoding-id-for-iso-8859-character-sets
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/utils/mb/conversion_procs/utf8_and_iso8859/utf8_and_iso8859.c:130"
  - "postgres/src/backend/utils/mb/conversion_procs/utf8_and_iso8859/utf8_and_iso8859.c:166"
reproduced: false
---

# `unexpected encoding ID %d for ISO 8859 character sets`

## What it means

Internal error. A conversion routine for ISO 8859 character sets was passed an encoding id outside the range it handles. The placeholder is the id. Each conversion function serves a fixed set of encodings.

## When it happens

It fires from built-in encoding-conversion code when an internal encoding id does not fall in the ISO 8859 group the routine expects — a programming/consistency error rather than ordinary data.

## How to fix

This is an internal guard. It should not arise from normal `SET client_encoding`; if it does, capture the encodings involved and report it. Do not attempt to work around it by forcing encodings.

## Example

*Illustrative* — a bad encoding id in an ISO 8859 conversion.

```text
ERROR:  unexpected encoding ID 99 for ISO 8859 character sets
```

## Related

- [unexpected encoding ID %d for WIN character sets](./unexpected-encoding-id-for-win-character-sets.md)
- [SetClientEncoding(%d) failed](./setclientencoding-failed.md)
