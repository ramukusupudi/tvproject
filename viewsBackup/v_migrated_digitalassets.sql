-- View: public.v_migrated_digitalassets

-- DROP VIEW public.v_migrated_digitalassets;

CREATE OR REPLACE VIEW public.v_migrated_digitalassets
 AS
 SELECT migrated_objects.uid,
    migrated_objects.model,
    migrated_objects.sources,
    migrated_objects.target_model
   FROM migrated_objects
  WHERE ((migrated_objects.model)::text = 'digitalAssets'::text);

ALTER TABLE public.v_migrated_digitalassets
    OWNER TO postgres;

