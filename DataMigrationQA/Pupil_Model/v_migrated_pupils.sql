-- View: public.v_migrated_pupils

-- DROP VIEW public.v_migrated_pupils;

CREATE OR REPLACE VIEW public.v_migrated_pupils
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    (((o.target_model -> 'data'::text) -> 'pupil'::text) -> 'OD'::text) ->> 'pupil.OD.notes'::text AS pupil.OD.notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'pupil'::text;

ALTER TABLE public.v_migrated_pupils
    OWNER TO postgres;

