---
message: "end-of-copy marker does not match previous newline style"
slug: end-of-copy-marker-does-not-match-previous-newline-style
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:1732"
  - "postgres/src/backend/commands/copyfromparse.c:1754"
reproduced: false
---

# `end-of-copy marker does not match previous newline style`

## What it means

During `COPY ... FROM` in text mode, the end-of-data marker (`\.`) used a different newline convention than the rest of the input. Postgres requires a consistent newline style across the copied stream.

## When it happens

Copying text data whose body uses one line ending (for example LF) while the terminating `\.` line uses another (for example CRLF), often from mixed-encoding or edited input files.

## How to fix

Normalize the input to a single newline style throughout, including the terminating `\.` line. Convert line endings before copying, or regenerate the file consistently.

## Example

*Illustrative* — a mismatched newline on the end marker.

```text
ERROR:  end-of-copy marker does not match previous newline style
```

## Related

- [CSV quote character must not appear in the specification](./csv-quote-character-must-not-appear-in-the-specification.md)
- [could not write COPY data](./could-not-write-copy-data.md)
