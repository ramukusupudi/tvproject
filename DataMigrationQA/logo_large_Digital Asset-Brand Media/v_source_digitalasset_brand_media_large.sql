-- View: public.v_source_digitalasset_brand_media_large

-- DROP VIEW public.v_source_digitalasset_brand_media_large;

CREATE OR REPLACE VIEW public.v_source_digitalasset_brand_media_large
 AS
 SELECT b.uid,
    b.brand_id,
    b.logo_large
   FROM brands b;

ALTER TABLE public.v_source_digitalasset_brand_media_large
    OWNER TO postgres;

