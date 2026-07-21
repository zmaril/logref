---
message: "could not open dictionary file \"%s\": %m"
slug: could-not-open-dictionary-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/spell.c:526"
reproduced: false
---

# `could not open dictionary file "%s": %m`

## What it means

A text-search dictionary tried to open its data file and the operating system refused. The `%m` reason gives the cause. Dictionaries load word lists from files under the configuration directory.

## When it happens

It happens while creating or using a text-search dictionary (for example an Ispell dictionary), when its file is missing, misnamed, or unreadable — often a wrong file name in the dictionary definition or a file not installed in `$SHAREDIR/tsearch_data`.

## How to fix

Confirm the dictionary file exists in the text-search data directory with the expected name and extension, and is readable by the server. Correcting the file name in the dictionary definition, or installing the missing file, resolves it.

## Example

*Illustrative* — a missing dictionary file.

```text
ERROR:  could not open dictionary file "/usr/share/postgresql/tsearch_data/en.dict": No such file or directory
```

## Related

- [could not open stop-word file](./could-not-open-stop-word-file.md)
- [could not open thesaurus file](./could-not-open-thesaurus-file.md)
