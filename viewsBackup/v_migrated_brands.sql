-- View: public.v_migrated_brands

-- DROP VIEW public.v_migrated_brands;

CREATE OR REPLACE VIEW public.v_migrated_brands
 AS
 SELECT v_migrated_objects.source_datasetid,
    v_migrated_objects.source_instanceid,
    v_migrated_objects.model,
    v_migrated_objects.sources,
    v_migrated_objects.target_model
   FROM v_migrated_objects
  WHERE ((v_migrated_objects.model)::text = 'brands'::text);

ALTER TABLE public.v_migrated_brands
    OWNER TO postgres;

