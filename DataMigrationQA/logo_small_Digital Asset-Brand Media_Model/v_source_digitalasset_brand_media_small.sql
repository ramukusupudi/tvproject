-- View: public.v_source_digitalasset_brand_media_small

-- DROP VIEW public.v_source_digitalasset_brand_media_small;

CREATE OR REPLACE VIEW public.v_source_digitalasset_brand_media_small
 AS
 SELECT b.uid,
    b.brand_id,
    b.logo_small
   FROM brands b;

ALTER TABLE public.v_source_digitalasset_brand_media_small
    OWNER TO postgres;

