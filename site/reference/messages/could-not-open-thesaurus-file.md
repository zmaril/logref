---
message: "could not open thesaurus file \"%s\": %m"
slug: could-not-open-thesaurus-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CONFIG_FILE_ERROR
    code: "F0000"
call_sites:
  - "postgres/src/backend/tsearch/dict_thesaurus.c:177"
reproduced: false
---

# `could not open thesaurus file "%s": %m`

## What it means

The thesaurus text-search dictionary tried to open its definition file and the operating system refused. The `%m` reason gives the cause. The thesaurus file maps phrases to their preferred terms.

## When it happens

It happens while creating or using a thesaurus dictionary, when its file is missing, misnamed, or unreadable — often a wrong name in the dictionary definition or a file not installed in `$SHAREDIR/tsearch_data`.

## How to fix

Confirm the thesaurus file exists in the text-search data directory with the expected name and is readable by the server. Correcting the name in the dictionary definition, or installing the file, resolves it.

## Example

*Illustrative* — a missing thesaurus file.

```text
ERROR:  could not open thesaurus file "/usr/share/postgresql/tsearch_data/thesaurus.ths": No such file or directory
```

## Related

- [could not open dictionary file](./could-not-open-dictionary-file.md)
- [could not open unaccent file](./could-not-open-unaccent-file.md)
