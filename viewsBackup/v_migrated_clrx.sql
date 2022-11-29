-- View: public.v_migrated_clrx

-- DROP VIEW public.v_migrated_clrx;

CREATE OR REPLACE VIEW public.v_migrated_clrx
 AS
 SELECT btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'systemCode'::text))::text, '"'::text) AS systemcode,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'datasetType'::text))::text, '"'::text) AS datasettype,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'datasetId'::text))::text, '"'::text) AS datasetid,
    btrim(((((o.target_model -> 'sources'::text) -> 0) -> 'instanceId'::text))::text, '"'::text) AS instanceid,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 't'::text))::text, '"'::text) AS odt,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'bc'::text))::text, '"'::text) AS odbc,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'add'::text))::text, '"'::text) AS odadd,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'bc2'::text))::text, '"'::text) AS odbc2,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'axis'::text))::text, '"'::text) AS odaxis,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'diam'::text))::text, '"'::text) AS oddiam,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'lens'::text) -> 'sku'::text))::text, '"'::text) AS odlsku,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'lens'::text) -> 'name'::text))::text, '"'::text) AS odlname,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'lens'::text) -> 'style'::text))::text, '"'::text) AS odlstyle,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'lens'::text) -> 'manufacturer'::text))::text, '"'::text) AS odlmfg,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'color'::text))::text, '"'::text) AS odcol,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'segHt'::text))::text, '"'::text) AS odseght,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'addOns'::text))::text, '"'::text) AS odaddons,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'power1'::text))::text, '"'::text) AS odpower1,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'power2'::text))::text, '"'::text) AS odpower2,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'cylinder'::text))::text, '"'::text) AS odcylinder,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'material'::text))::text, '"'::text) AS odmaterial,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'opticZone'::text))::text, '"'::text) AS odopticzone,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'thickness'::text))::text, '"'::text) AS odthickness,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'intermCurve'::text))::text, '"'::text) AS odintermcurve,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'od'::text) -> 'periphCurve'::text))::text, '"'::text) AS odperiphcurve,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 't'::text))::text, '"'::text) AS ost,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'bc'::text))::text, '"'::text) AS osbc,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'add'::text))::text, '"'::text) AS osadd,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'bc2'::text))::text, '"'::text) AS osbc2,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'axis'::text))::text, '"'::text) AS osaxis,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'diam'::text))::text, '"'::text) AS osdiam,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'lens'::text) -> 'sku'::text))::text, '"'::text) AS oslsku,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'lens'::text) -> 'name'::text))::text, '"'::text) AS oslname,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'lens'::text) -> 'style'::text))::text, '"'::text) AS oslstyle,
    btrim((((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'lens'::text) -> 'manufacturer'::text))::text, '"'::text) AS oslmfg,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'color'::text))::text, '"'::text) AS oscol,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'segHt'::text))::text, '"'::text) AS osseght,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'addOns'::text))::text, '"'::text) AS osaddons,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'power1'::text))::text, '"'::text) AS ospower1,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'power2'::text))::text, '"'::text) AS ospower2,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'cylinder'::text))::text, '"'::text) AS oscylinder,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'material'::text))::text, '"'::text) AS osmaterial,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'opticZone'::text))::text, '"'::text) AS osopticzone,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'thickness'::text))::text, '"'::text) AS osthickness,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'intermCurve'::text))::text, '"'::text) AS osintermcurve,
    btrim(((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'os'::text) -> 'periphCurve'::text))::text, '"'::text) AS osperiphcurve,
    btrim((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'notes'::text))::text, '"'::text) AS notes,
    to_date(btrim((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'startDate'::text))::text, '"'::text), 'MM DD YYYY'::text) AS startdate,
    to_date(btrim((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'expirationDate'::text))::text, '"'::text), 'MM DD YYYY'::text) AS expirationdate,
    btrim((((((o.target_model -> 'data'::text) -> 'data'::text) -> 'clrx'::text) -> 'expiryChangeReason'::text))::text, '"'::text) AS expirychangereason
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'clrx'::text);

ALTER TABLE public.v_migrated_clrx
    OWNER TO postgres;

