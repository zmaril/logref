---
message: "unexpected encoding ID %d for WIN character sets"
slug: unexpected-encoding-id-for-win-character-sets
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/utils/mb/conversion_procs/utf8_and_win/utf8_and_win.c:111"
  - "postgres/src/backend/utils/mb/conversion_procs/utf8_and_win/utf8_and_win.c:147"
reproduced: false
---

# `unexpected encoding ID %d for WIN character sets`

## What it means

Internal error. A conversion routine for Windows (WIN) character sets was passed an encoding id outside the range it handles. The placeholder is the id. Each conversion function serves a fixed set of encodings.

## When it happens

It fires from built-in encoding-conversion code when an internal encoding id does not fall in the WIN group the routine expects — a consistency error rather than ordinary data.

## How to fix

This is an internal guard. It should not arise from normal encoding settings; if it does, capture the encodings involved and report it rather than forcing encodings around it.

## Example

*Illustrative* — a bad encoding id in a WIN conversion.

```text
ERROR:  unexpected encoding ID 99 for WIN character sets
```

## Related

- [unexpected encoding ID %d for ISO 8859 character sets](./unexpected-encoding-id-for-iso-8859-character-sets.md)
- [SetClientEncoding(%d) failed](./setclientencoding-failed.md)
