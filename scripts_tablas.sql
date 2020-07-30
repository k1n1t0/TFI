-- ************************************************************************
-- * Script de creación de la base de datos del proyecto y carga de datos *
-- ************************************************************************

-- 1) En PostgreSQL, crear la base de datos del proyecto (TFI)

-- CREATE DATABASE "TFI" WITH OWNER = postgres ENCODING = 'UTF8' CONNECTION LIMIT = -1;


-- 2) Creo la extensión para PostGIS

CREATE EXTENSION postgis;


-- 3) Ejecuto scripts de creacion de tablas de los POIs en PostgreSQL (se adjuntan en un .ZIP)

------ "boliches-clubes-cines-polideportivos"
------ "educacion"
------ "transporte"
------ "resto-salud-shoppings"

-- 4) Ejecuto el script "puntos".

---- 5) En QGIS, genero puntos regulares sobre la extensión de la capa "barrios".

---- 6) Mediante la función "Seleccionar por localización", me quedo con los puntos que se encuentran dentro de CABA.
----    Cargo los puntos resultantes en PostgreSQL en una tabla con el nombre "puntos"

---- 7) Con la funcion "Unir atributos por localización" genero una capa que relacione los puntos con los barrios de CABA. Genero el script "pto_comuna_barrio".

-- 5) Indexo las tablas de POIs y puntos.

CREATE INDEX idx_boliches ON public.boliches USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_cines ON public.cines USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_clubes ON public.clubes USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_educacion ON public.educacion USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_metrobus ON public.metrobus USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_polideportivos ON public.polideportivos USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_puntos ON public.puntos USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_restaurantes ON public.restaurantes USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_salud ON public.salud USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_shoppings ON public.shoppings USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_subtes ON public.subtes USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_trenes ON public.trenes USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_universidades ON public.universidades USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_robos ON public.robos USING gist(geom) TABLESPACE pg_default;
CREATE INDEX idx_homicidios ON public.homicidios USING gist(geom) TABLESPACE pg_default;


-- 6) Actualizo la tabla puntos con la cantidad de POIs que se encuentran a menos de 1000 mts.	

UPDATE puntos SET metrobus = (SELECT COUNT (*) FROM metrobus WHERE ST_Distance(puntos.geom::geography, metrobus.geom::geography) < 1000);
UPDATE puntos SET subtes = (SELECT COUNT (*) FROM subtes WHERE ST_Distance(puntos.geom::geography, subtes.geom::geography) < 1000);
UPDATE puntos SET trenes = (SELECT COUNT (*) FROM trenes WHERE ST_Distance(puntos.geom::geography, trenes.geom::geography) < 1000);
UPDATE puntos SET educacion = (SELECT COUNT (*) FROM educacion WHERE ST_Distance(puntos.geom::geography, educacion.geom::geography) < 1000);
UPDATE puntos SET universidades = (SELECT COUNT (*) FROM universidades WHERE ST_Distance(puntos.geom::geography, universidades.geom::geography) < 1000);
UPDATE puntos SET centros_salud = (SELECT COUNT (*) FROM salud WHERE ST_Distance(puntos.geom::geography, salud.geom::geography) < 1000);
UPDATE puntos SET boliches = (SELECT COUNT (*) FROM boliches WHERE ST_Distance(puntos.geom::geography, boliches.geom::geography) < 1000);
UPDATE puntos SET cines = (SELECT COUNT (*) FROM cines WHERE ST_Distance(puntos.geom::geography, cines.geom::geography) < 1000);
UPDATE puntos SET shoppings = (SELECT COUNT (*) FROM shoppings WHERE ST_Distance(puntos.geom::geography, shoppings.geom::geography) < 1000);
UPDATE puntos SET restaurantes = (SELECT COUNT (*) FROM restaurantes WHERE ST_Distance(puntos.geom::geography, restaurantes.geom::geography) < 1000);
UPDATE puntos SET clubes = (SELECT COUNT (*) FROM clubes WHERE ST_Distance(puntos.geom::geography, clubes.geom::geography) < 1000);
UPDATE puntos SET polideportivos = (SELECT COUNT (*) FROM polideportivos WHERE ST_Distance(puntos.geom::geography, polideportivos.geom::geography) < 1000);
UPDATE puntos SET homicidios = (SELECT COUNT (*) FROM homicidios WHERE ST_Distance(puntos.geom::geography, homicidios.geom::geography) < 1000);
UPDATE puntos SET robos = (SELECT COUNT (*) FROM robos WHERE ST_Distance(puntos.geom::geography, robos.geom::geography) < 1000);


-- 7) Ejecuto el script "perfiles" que actualiza la tabla "puntos" con el total de POIs que pertenecen a cada perfil.
