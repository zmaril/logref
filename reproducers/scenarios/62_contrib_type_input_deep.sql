-- Tier 2 (deep) — contrib data-type modules: array-operand, malformed-input,
-- and range/dimension validation paths not covered by 41. Fixtures unique to
-- this file are created first; later files in the batch reuse them.
CREATE TABLE repro.ltr (id serial PRIMARY KEY, path ltree);
INSERT INTO repro.ltr (path) SELECT ('a.b.'||g)::ltree FROM generate_series(1,50) g;
CREATE TABLE repro.iarr (id serial PRIMARY KEY, a int[]);
CREATE TABLE repro.hs (id serial PRIMARY KEY, h hstore);

-- ltree: array operands must be one-dimensional and null-free (_ltree_op.c,
-- lquery_op.c, ltree_gist.c) — reached via the ltree[]/lquery[] operators.
SELECT '{{a,b}}'::ltree[] @> 'a'::ltree;
SELECT 'a'::ltree <@ ARRAY['a', NULL]::ltree[];
SELECT '{{a}}'::ltree[] <@ 'a'::ltree;
SELECT 'a.b'::ltree ? ('{{*}}'::lquery[]);
SELECT 'a.b'::ltree ? (ARRAY['*', NULL]::lquery[]);
SELECT '{{a}}'::ltree[] ?@> 'a'::ltree;
-- ltxtquery text-search query parser syntax errors (ltxtquery_io.c).
SELECT 'a & '::ltxtquery;
SELECT 'a | '::ltxtquery;
SELECT '( a'::ltxtquery;
SELECT '!'::ltxtquery;
-- ltree level-count ceiling (ltree_op.c) and gist signature-length option.
SELECT text2ltree(repeat('a.', 70000));
CREATE INDEX repro_ltr_gist ON repro.ltr USING gist (path gist_ltree_ops(siglen=3));

-- hstore: array-construction and subscripting validation (hstore_io.c,
-- hstore_subs.c) — even/2-column/subscript-count/null-key/oversize paths.
SELECT hstore(ARRAY['a', 'b', 'c']);
SELECT hstore('{{a,1,x},{b,2,y}}'::text[]);
SELECT hstore('{{{a}}}'::text[]);
SELECT hstore(ARRAY[NULL]::text[], ARRAY['1']);
SELECT hstore(ARRAY['a', NULL], ARRAY['1', '2']);
SELECT hstore(repeat('k', 70000), 'v');
SELECT hstore('a', repeat('v', 70000));
INSERT INTO repro.hs (h) VALUES ('a=>1'::hstore);
UPDATE repro.hs SET h['a']['b'] = 'x';
UPDATE repro.hs SET h[1] = 'x';
UPDATE repro.hs SET h[NULL] = 'x';

-- cube: null/oversize array construction and coordinate/enlarge bounds (cube.c).
SELECT cube(ARRAY[1, NULL]::float8[]);
SELECT cube(ARRAY[1, NULL]::float8[], ARRAY[2, 3]::float8[]);
SELECT cube(ARRAY[1, 2]::float8[], ARRAY[3]::float8[]);
SELECT cube((SELECT array_agg(g::float8) FROM generate_series(1, 120) g));
SELECT cube_coord('(1,2)'::cube, 9);
SELECT cube_coord_llur('(1,2)'::cube, 0);
SELECT cube_ur_coord('(1,2)'::cube, 0);
SELECT cube_enlarge('(1,2)'::cube, 1, 200);

-- intarray: query_int parser + gist index oversize array rejection.
SELECT '!'::query_int;
SELECT ' '::query_int;
SELECT querytree('1&2'::query_int);
CREATE INDEX repro_iarr_gist ON repro.iarr USING gist (a gist__int_ops);
INSERT INTO repro.iarr (a) VALUES ((SELECT array_agg(g) FROM generate_series(1, 120000) g));

-- isn: strong (non-weak) check-digit and cross-type cast rejection (isn.c).
SELECT '978-0-306-40615-6'::isbn13;
SELECT '0-306-40615-2'::isbn;
SELECT '1234-5679'::issn;
SELECT '9790000000000'::ean13::isbn;
SELECT '9771234567003'::ean13::isbn13;
