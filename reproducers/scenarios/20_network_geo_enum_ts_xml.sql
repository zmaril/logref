-- Network, geometric, enum, domain, tsvector/tsquery, xml, bit ops.
-- network
SELECT '256.0.0.1'::inet;
SELECT '1.2.3.4/33'::inet;
SELECT '::gggg'::inet;
SELECT '1.2.3.4/24'::cidr;
SELECT '10.0.0.0/8'::cidr - 999999999999;
SELECT set_masklen('1.2.3.4'::inet, 99);
SELECT set_masklen('::1'::inet, 200);
SELECT inet_merge('1.2.3.4'::inet, '::1'::inet);
SELECT '1.2.3.4'::inet & '::1'::inet;
SELECT '1.2.3.4'::inet + 1e20::bigint;
SELECT macaddr8_set7bit('01:02:03:04:05:06'::macaddr);
SELECT 'zz:zz:zz'::macaddr;
SELECT '01-02-03-04-05-06-07'::macaddr8;
-- geometric
SELECT '(1,2'::point;
SELECT '((1,2),(3,4))'::point;
SELECT '[(1,2),(3,4),(5,6)]'::lseg;
SELECT '<(1,2),-1>'::circle;
SELECT '((0,0),(1,1))'::polygon @> '(0.5,0.5)'::point AND lseg('[(0,0),(0,0)]'::lseg) IS NOT NULL;
SELECT '(0,0),(0,0)'::lseg <-> '(1,1)'::point;
SELECT ('(0,0),(1,0)'::line # '(0,1),(1,1)'::line);
SELECT center('<(0,0),0>'::circle) / 0;
SELECT ('(1,2)'::point <-> '((0,0),(0,0))'::box) / 0;
SELECT diameter('<(0,0),-5>'::circle);
SELECT area('((0,0),(0,0),(0,0))'::polygon) / 0;
SELECT '1,2,3'::line;
SELECT '{0,0,0}'::line;
-- enum / domain
CREATE TYPE repro.mood AS ENUM ('sad','ok','happy');
SELECT 'ecstatic'::repro.mood;
SELECT enum_range('sad'::repro.mood, 'happy'::text::repro.mood, NULL);
ALTER TYPE repro.mood ADD VALUE 'ok';
ALTER TYPE repro.mood RENAME VALUE 'nope' TO 'x';
CREATE DOMAIN repro.posint AS int CHECK (VALUE > 0);
SELECT (-5)::repro.posint;
SELECT NULL::repro.posint::int + 1;
CREATE DOMAIN repro.notnull AS int NOT NULL;
SELECT NULL::repro.notnull;
ALTER DOMAIN repro.posint ADD CONSTRAINT c2 CHECK (VALUE < 0);
-- tsvector / tsquery / text search
SELECT '''unterminated'::tsvector;
SELECT 'a:'::tsvector;
SELECT 'a &'::tsquery;
SELECT 'a <-> '::tsquery;
SELECT '! & a'::tsquery;
SELECT to_tsquery('nonsense_config', 'a');
SELECT to_tsvector('nonsense_config', 'a');
SELECT setweight('a'::tsvector, 'Z');
SELECT ts_rank(ARRAY[1.0], 'a'::tsvector, 'a'::tsquery);
SELECT tsquery_phrase('a'::tsquery, 'b'::tsquery, -1);
SELECT ts_headline('nonsense_config', 'a', 'a'::tsquery);
-- xml
SELECT xmlparse(document 'not xml');
SELECT xmlparse(content '<a>');
SELECT '<a></b>'::xml;
SELECT xpath('///', '<a/>'::xml);
SELECT xmlelement(name "bad name");
SELECT xmlpi(name xml);
SELECT xmlroot('<a/>'::xml, version '1.0', standalone bad);
SELECT xml_is_well_formed_document('<a>');
