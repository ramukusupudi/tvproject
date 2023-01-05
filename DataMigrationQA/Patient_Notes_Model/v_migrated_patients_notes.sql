-- View: public.v_migrated_patients_notes

-- DROP VIEW public.v_migrated_patients_notes;

CREATE OR REPLACE VIEW public.v_migrated_patients_notes
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> '_id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    o.target_model ->> 'notes'::text AS notes,
    o.target_model ->> 'additionalProperties'::text AS additionalproperties
   FROM v_migrated_objects o
  WHERE o.model::text = 'patients_notes'::text;

ALTER TABLE public.v_migrated_patients_notes
    OWNER TO postgres;

