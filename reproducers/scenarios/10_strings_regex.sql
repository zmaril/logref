-- String, regex, encoding & formatting errors  ->  src/backend/utils/adt/{regexp,varlena,formatting,encode}.c
-- Invalid regular expressions, bad format() specifiers, encoding/escape faults,
-- and out-of-range substring/position arguments.

SELECT 'abc' ~ '(';
SELECT 'abc' ~ '[';
SELECT 'abc' ~ '\';
SELECT 'abc' ~ '*';
SELECT 'abc' ~ '(?P<n>a';
SELECT 'abc' ~ 'a{2,1}';
SELECT regexp_replace('abc', '(', 'x');
SELECT regexp_matches('abc', '[');
SELECT regexp_split_to_array('abc', ')');
SELECT substring('abc' FROM '(');
SELECT regexp_match('x', 'a', 'Z');
SELECT format('%');
SELECT format('%z', 1);
SELECT format('%2$s');
SELECT format('%*s', 'x');
SELECT format('%1$');
SELECT to_char(1, 'invalid pattern %%%');
SELECT to_number('abc', '999');
SELECT convert_from('\xff'::bytea, 'UTF8');
SELECT convert_to('abc', 'NONEXISTENT_ENCODING');
SELECT convert('abc'::bytea, 'UTF8', 'NONEXISTENT');
SELECT decode('zzz', 'hex');
SELECT decode('abc', 'base64x');
SELECT encode('abc'::bytea, 'nonexistent');
SELECT chr(0);
SELECT ascii('');
SELECT left('abc', -100) || right('abc', -100);
SELECT substr('abc', 1, -1);
SELECT lpad('x', -1);
SELECT overlay('abc' PLACING 'y' FROM 0);
SELECT split_part('a,b', ',', 0);
SELECT 'abc' LIKE '\';
SELECT 'abc' SIMILAR TO '(';
SELECT translate('abc', 'a', '');
SELECT normalize('abc', NFKC) IS NOT NULL AND 'x' = 1;
SELECT unistr('\uZZZZ');
SELECT parse_ident('1.2.3.');
SELECT quote_ident(repeat('x', 2000000000));
