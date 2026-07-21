---
message: "end-of-copy marker is not alone on its line"
slug: end-of-copy-marker-is-not-alone-on-its-line
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_BAD_COPY_FILE_FORMAT
    code: "22P04"
call_sites:
  - "postgres/src/backend/commands/copyfromparse.c:1736"
  - "postgres/src/backend/commands/copyfromparse.c:1747"
  - "postgres/src/backend/commands/copyfromparse.c:1763"
reproduced: false
---

# `end-of-copy marker is not alone on its line`

## What it means

During a text-format `COPY FROM`, the end-of-data marker `\.` appeared on a line with other characters. The marker that terminates inline copy data must stand alone on its own line; extra content on that line means the data stream is malformed or the marker is being interpreted where it should not be.

## When it happens

`COPY ... FROM STDIN` (or from a file) in text format where a data line contains `\.` followed by other text, or the terminating `\.` was not placed on its own line — common when embedding copy data in a script or when a data value legitimately contains that sequence.

## How to fix

Ensure the `\.` terminator is on a line by itself. If a real data value needs to contain a backslash-dot, use CSV format (which does not use `\.` the same way) or escape the value properly for text format. When scripting, make sure nothing appends to the terminator line.

## Example

*Illustrative* — a copy terminator sharing its line.

```text
ERROR:  end-of-copy marker is not alone on its line
```

## Related

- [extra data after last expected column](./extra-data-after-last-expected-column.md)
- [column not referenced by COPY](./column-not-referenced-by-copy.md)
