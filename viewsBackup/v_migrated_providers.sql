-- View: public.v_migrated_providers

-- DROP VIEW public.v_migrated_providers;

CREATE OR REPLACE VIEW public.v_migrated_providers
 AS
 SELECT migrated_objects.uid,
    (migrated_objects.target_model -> '_id'::text) AS provider_id,
    btrim((((((migrated_objects.target_model -> 'sources'::text) -> 1))::json -> 'instanceId'::text))::text, '"'::text) AS sourceinstanceid,
    migrated_objects.model,
    migrated_objects.sources,
    migrated_objects.target_model
   FROM migrated_objects
  WHERE (((migrated_objects.model)::text = 'employees'::text) AND (((migrated_objects.target_model -> 'providerDetails'::text) -> 'isProvider'::text) = 'true'::jsonb));

ALTER TABLE public.v_migrated_providers
    OWNER TO postgres;

