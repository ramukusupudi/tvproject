-- View: public.v_migrated_external

-- DROP VIEW public.v_migrated_external;

CREATE OR REPLACE VIEW public.v_migrated_eyemovements
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((o.target_model -> 'eom'::text) -> 'covertest'::text) ->> 'notes'::text AS eom_covertest_notes,
    (o.target_model -> 'eom'::text) ->> 'notes'::text AS eom_notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'Eyemovements'::text;

ALTER TABLE public.v_migrated_external
    OWNER TO postgres;

