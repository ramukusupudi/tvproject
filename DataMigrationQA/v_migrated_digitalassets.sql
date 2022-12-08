-- View: public.v_migrated_digitalassets

-- DROP VIEW public.v_migrated_digitalassets;
--select * from v_migrated_digitalassets
--select uid,patient,insurance,front from insurance_cards ic;		
		

CREATE OR REPLACE VIEW public.v_migrated_digitalassets
 AS
 SELECT 
o.source_datasetid,
    o.source_instanceid,
    --o.sources,
    --o.target_model
	o.target_model ->> '_id'::text AS _id,
	o.target_model ->> 'name'::text AS name,
	o.target_model ->> 'type'::text AS type,
	o.target_model ->> 'subType'::text AS subType,
	o.target_model ->> 'originalFileName'::text AS originalFileName
   FROM v_migrated_objects o
  WHERE o.model::text = 'digitalAssets'::text;

ALTER TABLE public.v_migrated_digitalassets
    OWNER TO postgres;
	
		select * from public.migrated_objects 
 WHERE error = '{}'::jsonb and model='digitalAssets';


