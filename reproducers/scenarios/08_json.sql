-- JSON / JSONB / jsonpath / SQL-JSON errors  ->  src/backend/utils/adt/json*.c, jsonpath*.c
-- Malformed documents, type errors inside json operators, and invalid jsonpath
-- programs. The SQL/JSON functions are a dense, HEAD-current cluster of sites.

SELECT '{"a": 1'::jsonb;
SELECT '{"a": 1,}'::jsonb;
SELECT '[1, 2,]'::jsonb;
SELECT '{a: 1}'::jsonb;
SELECT '"\uZZZZ"'::jsonb;
SELECT '01'::jsonb;
SELECT '{"a":1, "a":2}'::json -> 0;
SELECT '[1,2,3]'::jsonb -> 'key';
SELECT '{"a":1}'::jsonb -> 0 -> 0;
SELECT jsonb_array_elements('{"a":1}');
SELECT jsonb_array_elements_text('5');
SELECT jsonb_object_keys('[1,2]');
SELECT jsonb_each('42');
SELECT ('{"a":1}'::jsonb) - 0;
SELECT jsonb_set('5', '{a}', '1');
SELECT jsonb_insert('[1]', '{0,0}', '9');
SELECT jsonb_path_query('{}', '$.');
SELECT jsonb_path_query('{}', '$[*]xyz');
SELECT jsonb_path_query('{"a":1}', 'strict $.b');
SELECT jsonb_path_query('1', '$ + "x"');
SELECT jsonb_path_query('"str"', '$.double()');
SELECT jsonb_path_query('[1,2]', '$[10]');
SELECT jsonb_path_query('{}', '$.a ? (@ > "1")');
SELECT json_object('{a,b,c}');
SELECT json_populate_record(NULL::repro.parent, '{"id":"notint"}');
SELECT to_timestamp('{}'::text::float8::text::float8);
SELECT jsonb_build_object('key');
SELECT '123'::jsonb #> '{a,b}';
SELECT jsonb_extract_path('5', 'a');
SELECT json_typeof('nope'::json);
SELECT '{"a":1}'::jsonb @? '$.';
SELECT JSON_QUERY('1'::jsonb, '$.a' ERROR ON ERROR);
SELECT JSON_VALUE('[1,2]'::jsonb, '$' ERROR ON ERROR);
SELECT JSON('not json');
SELECT '{"n": 1e1000}'::jsonb -> 'n';
