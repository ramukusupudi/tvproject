-- View: public.v_migrated_binocular_vision_eval

-- DROP VIEW public.v_migrated_binocular_vision_eval;

CREATE OR REPLACE VIEW public.v_migrated_binocular_vision_eval
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((o.target_model -> 'generalBinocularVision'::text) -> 'redgreenNearPointofConvergence'::text) ->> 'notes'::text AS notes
   FROM v_migrated_objects o
  WHERE o.model::text = 'binocular_vision_eval'::text;

ALTER TABLE public.v_migrated_binocular_vision_eval
    OWNER TO postgres;

