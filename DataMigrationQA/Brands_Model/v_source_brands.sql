-- View: public.v_source_brand

-- DROP VIEW public.v_source_brand;

CREATE OR REPLACE VIEW public.v_source_brand
 AS
 SELECT b.uid,
    b.name,
    b.brand_id,
    b.available,
    b.notes,
    b.website,
    b.logo_small,
    b.logo_large,
    b.icon
   FROM brands b;

ALTER TABLE public.v_source_brand
    OWNER TO postgres;

