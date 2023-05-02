-- View: public.v_migrated_brands_icon

-- DROP VIEW public.v_migrated_brands_icon;

CREATE OR REPLACE VIEW public.v_migrated_brands_icon
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    ((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) ->> 'fileName'::text AS name,
    ((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) ->> 'fileName'::text AS orginalfilename,
    split_part(((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) ->> 'fileName'::text, '.'::text, 2) AS type,
    split_part(((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) ->> 'fileName'::text, '.'::text, 2) AS subtype
   FROM v_migrated_objects o
  WHERE o.model::text = 'Brand'::text;

ALTER TABLE public.v_migrated_brands_icon
    OWNER TO postgres;

