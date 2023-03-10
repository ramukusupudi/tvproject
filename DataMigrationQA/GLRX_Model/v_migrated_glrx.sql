-- View: public.v_migrated_glrx

-- DROP VIEW public.v_migrated_glrx;

CREATE OR REPLACE VIEW public.v_migrated_glrx
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    (((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) ->> 'add'::text AS glrx_od_add,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) ->> 'sphere'::text AS glrx_od_sphere,
    (((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) ->> 'axis'::text AS glrx_od_axis,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) ->> 'cylinder'::text AS glrx_od_cylinder,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) ->> 'add'::text AS glrx_os_add,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) ->> 'sphere'::text AS glrx_os_sphere,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) ->> 'axis'::text AS glrx_os_axis,
	(((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) ->> 'cylinder'::text AS glrx_os_cylinder,
	((o.target_model -> 'data'::text) -> 'glrx'::text) ->> 'type'::text AS glrx_type,
	((o.target_model -> 'data'::text) -> 'glrx'::text) ->> 'startDate'::text AS glrx_startDate,
	((o.target_model -> 'data'::text) -> 'glrx'::text) ->> 'changeReason'::text AS glrx_changeReason,
	((o.target_model -> 'data'::text) -> 'glrx'::text) ->> 'expirationDate'::text AS glrx_expirationDate,
	((o.target_model -> 'data'::text) -> 'glrx'::text) ->> 'notes'::text AS glrx_notes,
	((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'od'::text) ->>'p1'::text AS glrx_prism_od_p1,
    ((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'od'::text) ->>'p2'::text AS glrx_prism_od_p2,
	((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'os'::text) ->>'p1'::text AS glrx_prism_os_p1
   FROM v_migrated_objects o
  WHERE o.model::text = 'glrx'::text;

ALTER TABLE public.v_migrated_glrx
    OWNER TO postgres;

