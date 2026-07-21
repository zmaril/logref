---
message: "could not open stop-word file \"%s\": %m"
slug: could-not-open-stop-word-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/ts_utils.c:82"
reproduced: false
---

# `could not open stop-word file "%s": %m`

## What it means

A text-search configuration tried to open a stop-word file and the operating system refused. The `%m` reason gives the cause. Stop-word files list common words a dictionary ignores.

## When it happens

It happens while creating or using a text-search dictionary that references a stop-word list, when the file is missing, misnamed, or unreadable — often a wrong name in the dictionary definition or a file not installed in `$SHAREDIR/tsearch_data`.

## How to fix

Confirm the stop-word file exists in the text-search data directory with the expected `.stop` name and is readable by the server. Correcting the name in the dictionary definition, or installing the file, resolves it.

## Example

*Illustrative* — a missing stop-word file.

```text
ERROR:  could not open stop-word file "/usr/share/postgresql/tsearch_data/english.stop": No such file or directory
```

## Related

- [could not open dictionary file](./could-not-open-dictionary-file.md)
- [could not open thesaurus file](./could-not-open-thesaurus-file.md)
