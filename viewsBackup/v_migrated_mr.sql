-- View: public.v_migrated_mr

-- DROP VIEW public.v_migrated_mr;

CREATE OR REPLACE VIEW public.v_migrated_mr
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    (o.target_model ->> '_id'::text) AS _id,
    ((o.target_model -> 'patient'::text) ->> '_id'::text) AS patient_id,
    (o.target_model ->> 'appointmentDate'::text) AS appointmentdate,
    (((o.target_model -> 'data'::text) -> 'OD'::text) ->> 'va'::text) AS od_va,
    (((o.target_model -> 'data'::text) -> 'OD'::text) ->> 'axis'::text) AS od_axis,
    (((o.target_model -> 'data'::text) -> 'OD'::text) ->> 'sphere'::text) AS od_sphere,
    (((o.target_model -> 'data'::text) -> 'OD'::text) ->> 'cylindrical'::text) AS od_cylindrical,
    (((o.target_model -> 'data'::text) -> 'OS'::text) ->> 'va'::text) AS os_va,
    (((o.target_model -> 'data'::text) -> 'OS'::text) ->> 'axis'::text) AS os_axis,
    (((o.target_model -> 'data'::text) -> 'OS'::text) ->> 'sphere'::text) AS os_sphere,
    (((o.target_model -> 'data'::text) -> 'OS'::text) ->> 'cylindrical'::text) AS os_cylindrical,
    (((o.target_model -> 'data'::text) -> 'OU'::text) ->> 'vad'::text) AS ou_vad,
    ((o.target_model -> 'data'::text) ->> 'amp'::text) AS amp,
    ((o.target_model -> 'data'::text) ->> 'bxc'::text) AS bxc,
    ((o.target_model -> 'data'::text) ->> 'nra'::text) AS nra,
    ((o.target_model -> 'data'::text) ->> 'pra'::text) AS pra,
    ((o.target_model -> 'data'::text) ->> 'notes'::text) AS notes,
    (o.target_model ->> '_created'::text) AS created,
    (o.target_model ->> '_updated'::text) AS updated
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'mr'::text);

ALTER TABLE public.v_migrated_mr
    OWNER TO postgres;

