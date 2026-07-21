-- contrib extension input / validation / API error paths.
-- ltree
SELECT 'a..b'::ltree;
SELECT ('a.b'::ltree || '.'::text)::ltree;
SELECT nlevel('a.b'::ltree) FROM (SELECT repeat('a.', 100000)::ltree) t;
SELECT 'a.b.c'::ltree ~ 'a.*{999999999}';
SELECT '1 & '::lquery;
SELECT '*{-1}'::lquery;
SELECT 'a%b'::ltxtquery;
SELECT lca('{}'::ltree[]);
SELECT subltree('a.b.c'::ltree, 5, 1);
SELECT subpath('a.b'::ltree, 10);
SELECT text2ltree(repeat('x', 100000));
-- hstore
SELECT 'a=>'::hstore;
SELECT 'a=>1, =>2'::hstore;
SELECT hstore(ARRAY['a'], ARRAY['1','2']);
SELECT hstore(ARRAY['a','b'], ARRAY['1']);
SELECT ('a=>1'::hstore)->NULL / 0;
SELECT populate_record(NULL::repro.parent, 'id=>x'::hstore);
SELECT each('a=>1'::hstore) IS NOT NULL;
SELECT 'a=>1'::hstore #= NULL;
-- cube
SELECT '(1,2,3'::cube;
SELECT cube_subset('(1,2)'::cube, ARRAY[5]);
SELECT '(1,2,3),(4,5)'::cube;
SELECT cube(ARRAY[1.0,2.0], ARRAY[3.0]);
SELECT cube_ll_coord('(1,2)'::cube, 0);
SELECT cube('nan'::text::cube);
SELECT cube_enlarge('(1)'::cube, 1, -5);
SELECT '(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101)'::cube;
-- seg
SELECT 'abc'::seg;
SELECT '1 .. z'::seg;
SELECT seg_size('5 .. 3'::seg);
-- intarray
SELECT '1 & '::query_int;
SELECT '{1,2}'::int[] # '{3}'::int[] - 5;
SELECT intset(NULL) IS NULL;
SELECT '{1,NULL,2}'::int[] + 1 <@ '{1}';
SELECT sort('{2,1}'::int[], 'nonsense');
SELECT idx('{1,2}'::int[], 3) / 0;
SELECT subarray('{1,2,3}'::int[], 10, 5);
-- isn
SELECT '978-0-306-40615-X'::isbn;
SELECT '123'::isbn13;
SELECT 'notanisbn'::issn;
SELECT '9780306406157'::ean13::isbn13;
SELECT isn_weak(true) IS NOT NULL;
-- citext
SELECT 'A'::citext = 1;
SELECT split_part('a,b'::citext::text, ','::citext::text, 0);
-- pg_trgm
SELECT show_limit();
SELECT set_limit(2.0);
SELECT set_limit(-1);
SELECT similarity('a', 'b') / 0;
-- fuzzystrmatch
SELECT levenshtein('a', 'b', -1, 0, 0);
SELECT levenshtein_less_equal('a','b',-1);
SELECT soundex(repeat('x', 100000)) IS NOT NULL;
SELECT metaphone('abc', -1);
SELECT metaphone('abc', 0);
SELECT dmetaphone(NULL) IS NULL;
-- unaccent / dict_int
SELECT unaccent('nonexistent_dict', 'x');
SELECT ts_lexize('nonexistent_dict_xyz', 'x');
-- earthdistance / cube
SELECT ll_to_earth(999, 999);
SELECT latitude('(1,2,3)'::earth);
SELECT earth_box(ll_to_earth(0,0), -1);
