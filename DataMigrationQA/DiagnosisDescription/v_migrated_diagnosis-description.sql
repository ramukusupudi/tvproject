-- View: public.v_migrated_diagnosisdescription

-- DROP VIEW public.v_migrated_diagnosisdescription;

CREATE OR REPLACE VIEW public.v_migrated_diagnosisdescription
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    (((o.target_model -> 'data') -> 'diagnosis') -> 0) ->> 'plan'::text AS diagnosis_plan1,
    (((o.target_model -> 'data') -> 'diagnosis') -> 1) ->> 'plan'::text AS diagnosis_plan2,
    (((o.target_model -> 'data') -> 'diagnosis') -> 2) ->> 'plan'::text AS diagnosis_plan3,
    (((o.target_model -> 'data') -> 'diagnosis') -> 3) ->> 'plan'::text AS diagnosis_plan4,
    (((o.target_model -> 'data') -> 'diagnosis') -> 4) ->> 'plan'::text AS diagnosis_plan5,
    (((o.target_model -> 'data') -> 'diagnosis') -> 5) ->> 'plan'::text AS diagnosis_plan6,
    (((o.target_model -> 'data') -> 'diagnosis') -> 6) ->> 'plan'::text AS diagnosis_plan7,
    ((o.target_model -> 'data') -> 'eom'::text) ->> 'notes'::text AS eom_notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'diagnosisDescription'::text;

ALTER TABLE public.v_migrated_diagnosisdescription
    OWNER TO postgres;

