-- View: public.v_migrated_sle

-- DROP VIEW public.v_migrated_sle;

CREATE OR REPLACE VIEW public.v_migrated_sle
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((o.target_model -> 'lens'::text) -> 'OD'::text) ->> 'notes'::text AS lens_od_notes,
    ((o.target_model -> 'lens'::text) -> 'OS'::text) ->> 'notes'::text AS lens_os_notes,
    ((o.target_model -> 'cornea'::text) -> 'OD'::text) ->> 'notes'::text AS cornea_od_notes,
    ((o.target_model -> 'cornea'::text) -> 'OS'::text) ->> 'notes'::text AS cornea_os_notes,
    ((o.target_model -> 'irisPupil'::text) -> 'OD'::text) ->> 'notes'::text AS irispupil_od_notes,
    ((o.target_model -> 'irisPupil'::text) -> 'OS'::text) ->> 'notes'::text AS irispupil_os_notes,
    ((o.target_model -> 'antchamber'::text) -> 'OD'::text) ->> 'notes'::text AS antchamber_od_notes,
    ((o.target_model -> 'antchamber'::text) -> 'OS'::text) ->> 'notes'::text AS antchamber_os_notes,
    ((o.target_model -> 'Conjunctiva'::text) -> 'OD'::text) ->> 'notes'::text AS conjunctiva_od_notes,
    ((o.target_model -> 'Conjunctiva'::text) -> 'OS'::text) ->> 'notes'::text AS conjunctiva_os_notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'SLE'::text;

ALTER TABLE public.v_migrated_sle
    OWNER TO postgres;
