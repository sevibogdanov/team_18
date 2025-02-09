CREATE OR REPLACE VIEW team18.objects_other AS 
WITH schools AS (
         SELECT 'schools'::text AS object_type,
            '1'::text AS object_type_id,
            schools.school AS name,
            split_part(schools.school_coords, ' '::text, 2)::double precision AS lat,
            split_part(schools.school_coords, ' '::text, 1)::double precision AS lon
           FROM team18.schools
        ), shops AS (
         SELECT 'shops'::text AS object_type,
            '2'::text AS object_type_id,
            shops.names AS name,
            shops.latitude AS lat,
            shops.longitude AS lon
           FROM team18.shops
          WHERE shops.type = 'реализация продовольственных товаров'::text
        ), theatre AS (
         SELECT 'theatre'::text AS object_type,
            '3'::text AS object_type_id,
            theatre.name,
            theatre.latitude AS lat,
            theatre.longitude AS lon
           FROM team18.theatre
        ), fitness AS (
         SELECT 'fitness'::text AS object_type,
            '4'::text AS object_type_id,
            fitness.name,
            replace(fitness.latitude::text, ','::text, '.'::text)::double precision AS lat,
            replace(fitness.longitude::text, ','::text, '.'::text)::double precision AS lon
           FROM team18.fitness
        ), kinder AS (
         SELECT 'kindergarten'::text AS object_type,
            '5'::text AS object_type_id,
            kinder.name,
            replace(kinder.lat, ','::text, '.'::text)::double precision AS lat,
            replace(kinder.lon, ','::text, '.'::text)::double precision AS lon
           FROM team18.kinder
        ), cinemas AS (
         SELECT 'cinemas'::text AS object_type,
            '6'::text AS object_type_id,
            cinemas.name,
            cinemas.latitude AS lat,
            cinemas.longitude AS lon
           FROM team18.cinemas
        ), foods AS (
         SELECT 'foods'::text AS object_type,
            '7'::text AS object_type_id,
            foods.names AS name,
            foods.latitude AS lat,
            foods.longitude AS lon
           FROM team18.foods
        ), libraries AS (
         SELECT 'libraries'::text AS object_type,
            '8'::text AS object_type_id,
            libraries.names AS name,
            libraries.latitude AS lat,
            libraries.longitude AS lon
           FROM team18.libraries
        ), parks AS (
         SELECT 'parks'::text AS object_type,
            '9'::text AS object_type_id,
            parks.name,
            parks.latitude AS lat,
            parks.longitude AS lon
           FROM team18.parks
          WHERE parks.index > 0
        ), post_office AS (
         SELECT 'post_office'::text AS object_type,
            '10'::text AS object_type_id,
            post_office.name,
            post_office.latitude AS lat,
            post_office.longitude AS lon
           FROM team18.post_office
        )
 SELECT *
   FROM schools
UNION ALL
 SELECT *
   FROM shops
UNION ALL
 SELECT *
   FROM theatre
UNION ALL
 SELECT *
   FROM fitness
UNION ALL
 SELECT *
   FROM kinder
UNION ALL
 SELECT *
   FROM cinemas
UNION ALL
 SELECT *
   FROM foods
UNION ALL
 SELECT *
   FROM libraries
UNION ALL
 SELECT *
   FROM parks
UNION ALL
 SELECT *
   FROM post_office
--
UNION ALL
 SELECT 'climbing'::text AS object_type,'11' object_type_id,"name",latitude AS lat,longitude as lon
   FROM team18.climbing
UNION ALL
 SELECT 'fields'::text AS object_type,'12' object_type_id,"name",latitude AS lat,longitude as lon
   FROM team18.fields
UNION ALL
 SELECT 'indoor_swimming_pool'::text AS object_type,'13' object_type_id,"name",latitude AS lat,longitude as lon
   FROM team18.indoor_swimming_pool
UNION ALL
 SELECT 'malls'::text AS object_type,'14' object_type_id,"name",latitude AS lat,longitude as lon
   FROM team18.malls
UNION ALL
 SELECT 'outdoor_swimming_pool'::text AS object_type,'15' object_type_id,"name",latitude AS lat,longitude as lon
   FROM team18.outdoor_swimming_pool;