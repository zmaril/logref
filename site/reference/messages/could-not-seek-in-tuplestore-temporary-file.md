---
message: "could not seek in tuplestore temporary file"
slug: could-not-seek-in-tuplestore-temporary-file
passthrough: false
api: [ereport]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/sort/tuplestore.c:551"
  - "postgres/src/backend/utils/sort/tuplestore.c:561"
  - "postgres/src/backend/utils/sort/tuplestore.c:920"
  - "postgres/src/backend/utils/sort/tuplestore.c:1024"
  - "postgres/src/backend/utils/sort/tuplestore.c:1088"
  - "postgres/src/backend/utils/sort/tuplestore.c:1105"
  - "postgres/src/backend/utils/sort/tuplestore.c:1351"
  - "postgres/src/backend/utils/sort/tuplestore.c:1416"
  - "postgres/src/backend/utils/sort/tuplestore.c:1425"
reproduced: false
---

# `could not seek in tuplestore temporary file`

## What it means

Internal/I-O error. Repositioning within a temporary file that backs a tuplestore (used to buffer rows for cursors, window functions, and set-returning functions that spill to disk) failed. It usually surfaces an underlying OS `lseek` failure or an inconsistency in the temp file.

## When it happens

A large tuplestore spilled to a temp file and a seek failed — often failing storage, a full disk truncating the file, or the temp file being removed out from under the server. Ordinary small operations that stay in memory do not reach it.

## How to fix

Check the temp filesystem (`temp_tablespaces` or the default `base/pgsql_tmp`) for I/O errors and free space. A full or failing disk is the common cause. Ensure nothing external is deleting files under the data directory. If storage is healthy and it recurs, capture the query and report it.

## Example

*Illustrative* — a tuplestore spill on failing temp storage.

```text
ERROR:  could not seek in tuplestore temporary file
```

## Related

- [could not write to file](./could-not-write-to-file-16a7e3.md)
- [unexpected end of tuplestore](./unexpected-end-of-tuplestore.md)
