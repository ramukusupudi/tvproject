-- View: public.v_migrated_brands

-- DROP VIEW public.v_migrated_brands;

CREATE OR REPLACE VIEW public.v_migrated_brands
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    o.target_model ->> 'name'::text AS name,
    o.target_model -> 'code'::text AS code,
    o.target_model -> 'isAvailable'::text AS isavailable,
    o.target_model ->> 'notes'::text AS notes,
    o.target_model -> 'website'::text AS website,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoSmall'::text) -> '_id'::text) ->> 'dalogosmlid'::text AS dalogosmlid,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoSmall'::text) -> 'version'::text) ->> 'dalogosmlversion'::text AS dalogosmlversion,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoSmall'::text) -> 'fileName'::text) ->> 'dalogosmlfileName'::text AS dalogosmlfilename,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoLarge'::text) -> '_id'::text) ->> 'dalogolarglid'::text AS dalogolarglid,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoLarge'::text) -> 'version'::text) ->> 'dalogolargversion'::text AS dalogolargversion,
    (((o.target_model -> 'digitalAssets'::text) -> 'logoLarge'::text) -> 'fileName'::text) ->> 'dalogolargfileName'::text AS dalogolargfilename,
    (((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) -> '_id'::text) ->> 'daiconid'::text AS daiconid,
    (((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) -> 'version'::text) ->> 'daiconversion'::text AS daiconversion,
    (((o.target_model -> 'digitalAssets'::text) -> 'icon'::text) -> 'fileName'::text) ->> 'daiconfileName'::text AS daiconfilename
   FROM v_migrated_objects o
  WHERE o.model::text = 'Brand'::text;

ALTER TABLE public.v_migrated_brands
    OWNER TO postgres;

