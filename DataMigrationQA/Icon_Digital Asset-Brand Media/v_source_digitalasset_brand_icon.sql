-- View: public.v_source_digitalasset_brand_icon

-- DROP VIEW public.v_source_digitalasset_brand_icon;

CREATE OR REPLACE VIEW public.v_source_digitalasset_brand_icon
 AS
 SELECT b.uid,
    b.brand_id,
    b.icon
   FROM brands b;

ALTER TABLE public.v_source_digitalasset_brand_icon
    OWNER TO postgres;

