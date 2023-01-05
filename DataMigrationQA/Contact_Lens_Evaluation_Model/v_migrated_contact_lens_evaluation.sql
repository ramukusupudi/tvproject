-- View: public.v_migrated_contact_lens_evaluation

-- DROP VIEW public.v_migrated_contact_lens_evaluation;

CREATE OR REPLACE VIEW public.v_migrated_contact_lens_evaluation
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> '_id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((o.target_model -> 'clrx'::text) -> 'drawing'::text) ->> 'notes'::text AS drawingnotes,
    ((o.target_model -> 'clrx'::text) -> 'clEvaluation'::text) ->> 'goodCentrationMOvement'::text AS goodcentrationmovement,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'add'::text AS od_add,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'dva'::text AS od_dva,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'nva'::text AS od_nva,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'axis'::text AS od_axis,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'notes'::text AS od_notes,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'sphere'::text AS od_sphere,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'od'::text) ->> 'cylinder'::text AS od_cylinder,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'add'::text AS os_add,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'dva'::text AS os_dva,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'nva'::text AS os_nva,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'axis'::text AS os_axis,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'sphere'::text AS os_sphere,
    (((o.target_model -> 'clrx'::text) -> 'overRefraction'::text) -> 'os'::text) ->> 'cylinder'::text AS os_cylinder
   FROM v_migrated_objects o
  WHERE o.model::text = 'contact_lens_evaluation'::text;

ALTER TABLE public.v_migrated_contact_lens_evaluation
    OWNER TO postgres;

