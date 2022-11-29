-- View: public.v_migrated_glrx

-- DROP VIEW public.v_migrated_glrx;

CREATE OR REPLACE VIEW public.v_migrated_glrx
 AS
 SELECT btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'systemCode'::text))::text, '"'::text) AS systemcode,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'datasetType'::text))::text, '"'::text) AS datasettype,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'datasetId'::text))::text, '"'::text) AS datasetid,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'instanceId'::text))::text, '"'::text) AS instanceid,
    to_date(btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'startDate'::text))::text, '"'::text), 'MM DD YYYY'::text) AS appointmentdate,
    btrim((((((((o.target_model -> 'patient'::text) -> 'M'::text) -> 'source'::text) -> 'M'::text) -> 'instanceId'::text) -> 'S'::text))::text, '"'::text) AS patientid,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) -> 'add'::text))::text, '"'::text) AS odadd,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) -> 'axis'::text))::text, '"'::text) AS odaxis,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) -> 'add'::text))::text, '"'::text) AS osadd,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) -> 'axis'::text))::text, '"'::text) AS osaxis,
    btrim(((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'od'::text) -> 'p1'::text))::text, '"'::text) AS odprism1,
    btrim(((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'od'::text) -> 'p2'::text))::text, '"'::text) AS odprism2,
    btrim(((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'prism'::text) -> 'os'::text) -> 'p1'::text))::text, '"'::text) AS osprism1,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) -> 'bal'::text))::text, '"'::text) AS odbal,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) -> 'bal'::text))::text, '"'::text) AS osbal,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) -> 'sphere'::text))::text, '"'::text) AS odsph,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'od'::text) -> 'cylinder'::text))::text, '"'::text) AS odcyl,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) -> 'sphere'::text))::text, '"'::text) AS ossph,
    btrim((((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'os'::text) -> 'cylinder'::text))::text, '"'::text) AS oscyl,
    btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'type'::text))::text, '"'::text) AS type,
    btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'notes'::text))::text, '"'::text) AS notes,
    to_date(btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'startDate'::text))::text, '"'::text), 'MM DD YYYY'::text) AS startdate,
    btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'changeReason'::text))::text, '"'::text) AS changereason,
    to_date(btrim(((((o.target_model -> 'data'::text) -> 'glrx'::text) -> 'expirationDate'::text))::text, '"'::text), 'MM DD YYYY'::text) AS expirationdate,
    btrim((((o.target_model -> 'examSheet'::text) -> '_id'::text))::text, '"'::text) AS examsheetid
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'glrx'::text);

ALTER TABLE public.v_migrated_glrx
    OWNER TO postgres;

