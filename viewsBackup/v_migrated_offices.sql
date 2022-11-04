-- View: public.v_migrated_offices

-- DROP VIEW public.v_migrated_offices;

CREATE OR REPLACE VIEW public.v_migrated_offices
 AS
 SELECT (o.target_model ->> '_id'::text) AS _id,
    o.source_datasetid,
    o.source_instanceid,
    o.model,
    o.sources,
    o.target_model
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'offices'::text);

ALTER TABLE public.v_migrated_offices
    OWNER TO postgres;

