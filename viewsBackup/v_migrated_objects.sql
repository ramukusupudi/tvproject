-- View: public.v_migrated_objects

-- DROP VIEW public.v_migrated_objects;

CREATE OR REPLACE VIEW public.v_migrated_objects
 AS
 SELECT ((o.sources -> 0) ->> 'datasetId'::text) AS source_datasetid,
    ((o.sources -> 0) ->> 'instanceId'::text) AS source_instanceid,
    o.model,
    o.sources,
    o.target_model
   FROM migrated_objects o
  WHERE (o.error = '{}'::jsonb);

ALTER TABLE public.v_migrated_objects
    OWNER TO postgres;

