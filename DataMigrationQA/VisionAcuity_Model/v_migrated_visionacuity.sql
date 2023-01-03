--select * from v_migrated_objects where model='VA'
--Drop view v_migrated_visionacuity
CREATE OR REPLACE VIEW public.v_migrated_visionacuity
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
(o.target_model ->'patient'::text) ->>'_id'::text AS patient_id,
o.target_model ->>'appointmentDate'::text AS appointmentDate,
((o.target_model ->'near'::text) -> 'OD'::text)->>'value1'::text AS near_OD_value1,
((o.target_model ->'near'::text) -> 'OS'::text)->>'value1'::text AS near_OS_value1,
((o.target_model ->'near'::text) -> 'OU'::text)->>'value1'::text AS near_OU_value1,
--(o.target_model ->'near'::text) ->::text AS near_value,
((o.target_model ->'distance'::text) -> 'OD'::text)->>'value1'::text AS distance_OD_value1,
((o.target_model ->'distance'::text) -> 'OS'::text)->>'value1'::text AS distance_OS_value1,
((o.target_model ->'distance'::text) -> 'OU'::text)->>'value1'::text AS distance_OU_value1,
(o.target_model ->'distance'::text) ->>'value'::text AS distance_value,
(o.target_model ->'superPinhole'::text) ->>'OD'::text AS superPinhole_OD,
(o.target_model ->'superPinhole'::text) ->>'OS'::text AS superPinhole_OS
	
	FROM v_migrated_objects o
  WHERE o.model::text = 'VA'::text;

ALTER TABLE public.v_migrated_visionacuity
    OWNER TO postgres;
	
	--Select Distinct model from v_migrated_objects