-- View: public.v_migrated_external

-- DROP VIEW public.v_migrated_external;

CREATE OR REPLACE VIEW public.v_migrated_external
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    (((o.target_model -> 'data'::text) -> 'lids'::text) -> 'lashes'::text) ->> 'notes'::text AS lids_lashes_notes,
    ((o.target_model -> 'data'::text) -> 'lacrimal'::text) ->> 'notes'::text AS lacrimal_notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'external'::text;

ALTER TABLE public.v_migrated_external
    OWNER TO postgres;

