-- View: public.v_migrated_cvf

-- DROP VIEW public.v_migrated_cvf;

CREATE OR REPLACE VIEW public.v_migrated_cvf
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.model,
    o.sources,
    o.target_model,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> '_id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((((o.target_model -> 'readings'::text) -> 'items'::text) -> '0'::text) -> 'properties'::text) ->> 'notes'::text AS cvf_notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'cvf'::text;

ALTER TABLE public.v_migrated_cvf
    OWNER TO postgres;

