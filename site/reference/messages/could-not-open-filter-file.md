---
message: "could not open filter file \"%s\": %m"
slug: could-not-open-filter-file
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_dump/filter.c:48"
reproduced: false
---

# `could not open filter file "%s": %m`

## What it means

`pg_dump` (or a related tool) tried to open the object-filter file named with `--filter` and the operating system refused. The `%m` reason gives the cause. The filter file lists objects to include or exclude.

## When it happens

It happens when the path passed to `--filter` does not exist or is not readable by the user running the tool — usually a wrong path or a permissions problem.

## How to fix

Confirm the filter file path is correct and readable by the invoking user, then rerun. The `%m` reason names the specific problem.

## Example

*Illustrative* — the filter file could not be opened.

```text
pg_dump: error: could not open filter file "objects.txt": No such file or directory
```

## Related

- [could not open version file](./could-not-open-version-file.md)
- [could not open TOC file](./could-not-open-toc-file.md)
