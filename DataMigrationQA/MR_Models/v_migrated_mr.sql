--select * from v_migrated_mr
--select * from v_migrated_objects where model = 'mr'
--DROP VIEW public.v_migrated_MR;

CREATE OR REPLACE VIEW public.v_migrated_MR
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
(o.target_model ->'patient'::text)->> '_id'::text AS patient_id,
o.target_model ->>'appointmentDate'::text AS appointmentDate,
((o.target_model -> 'data'::text)->'OD'::text)->> 'va'::text AS OD_va,
((o.target_model -> 'data'::text)->'OD'::text)->> 'axis'::text AS OD_axis,
((o.target_model -> 'data'::text)->'OD'::text)->> 'sphere'::text AS OD_sphere,
((o.target_model -> 'data'::text)->'OD'::text)->> 'cylindrical'::text AS OD_cylindrical,
((o.target_model -> 'data'::text)->'OS'::text)->> 'va'::text AS OS_va,
((o.target_model -> 'data'::text)->'OS'::text)->> 'axis'::text AS OS_axis,
((o.target_model -> 'data'::text)->'OS'::text)->> 'sphere'::text AS OS_sphere,
((o.target_model -> 'data'::text)->'OS'::text)->> 'cylindrical'::text AS OS_cylindrical,
((o.target_model -> 'data'::text)->'OU'::text)->> 'vad'::text AS OU_vad,
(o.target_model -> 'data'::text)->> 'amp'::text AS amp,
(o.target_model -> 'data'::text)->> 'bxc'::text AS bxc,
(o.target_model -> 'data'::text)->> 'nra'::text AS nra,
(o.target_model -> 'data'::text)->> 'pra'::text AS pra,
(o.target_model -> 'data'::text)->> 'notes'::text AS notes,
	
	o.target_model ->> '_created'::text AS created,
    o.target_model ->> '_updated'::text AS updated 
   FROM v_migrated_objects o
  WHERE o.model::text = 'mr'::text;

ALTER TABLE public.v_migrated_MR
    OWNER TO postgres;
	
	