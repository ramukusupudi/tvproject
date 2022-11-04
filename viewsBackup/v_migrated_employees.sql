-- View: public.v_migrated_employees

-- DROP VIEW public.v_migrated_employees;

CREATE OR REPLACE VIEW public.v_migrated_employees
 AS
 SELECT migrated_objects.uid,
    migrated_objects.model,
    migrated_objects.sources,
    migrated_objects.target_model
   FROM migrated_objects
  WHERE (((migrated_objects.model)::text = 'employees'::text) AND (((migrated_objects.target_model -> 'providerDetails'::text) -> 'isProvider'::text) = 'false'::jsonb));

ALTER TABLE public.v_migrated_employees
    OWNER TO postgres;

