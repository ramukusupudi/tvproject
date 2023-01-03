-- View: public.v_migrated_clrx

-- DROP VIEW public.v_migrated_clrx;

CREATE OR REPLACE VIEW public.v_migrated_clrx
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> '_id'::text AS patient_id,
     (o.target_model -> 'data'->'clrx'->'od'->>'t') AS od_t,
(o.target_model -> 'data'->'clrx'->'od'->>'bc') AS od_bc,
(o.target_model -> 'data'->'clrx'->'od'->>'add') AS od_add,
(o.target_model -> 'data'->'clrx'->'od'->>'bc2') AS od_bc2,
(o.target_model -> 'data'->'clrx'->'od'->>'axis') AS od_axis,
(o.target_model -> 'data'->'clrx'->'od'->>'diam') AS od_diam,
(o.target_model -> 'data'->'clrx'->'od'->'lens'->>'sku') AS od_lens_sku,
(o.target_model -> 'data'->'clrx'->'od'->'lens'->>'name') AS od_lens_name,
(o.target_model -> 'data'->'clrx'->'od'->'lens'->>'style') AS od_lens_style,
(o.target_model -> 'data'->'clrx'->'od'->'lens'->>'manufacturer') AS od_lens_manufacturer,
(o.target_model -> 'data'->'clrx'->'od'->>'color') AS od_color,
(o.target_model -> 'data'->'clrx'->'od'->>'segHt') AS od_segHt,
(o.target_model -> 'data'->'clrx'->'od'->>'addOns') AS od_addOns,
(o.target_model -> 'data'->'clrx'->'od'->>'power1') AS od_power1,
(o.target_model -> 'data'->'clrx'->'od'->>'power2') AS od_power2,
(o.target_model -> 'data'->'clrx'->'od'->>'cylinder') AS od_cylinder,
(o.target_model -> 'data'->'clrx'->'od'->>'material') AS od_material,
(o.target_model -> 'data'->'clrx'->'od'->>'opticZone') AS od_opticZone,
(o.target_model -> 'data'->'clrx'->'od'->>'thickness') AS od_thickness,
(o.target_model -> 'data'->'clrx'->'od'->>'intermCurve') AS od_intermCurve,
(o.target_model -> 'data'->'clrx'->'od'->>'periphCurve') AS od_periphCurve,
(o.target_model -> 'data'->'clrx'->'os'->>'bc') AS os_bc,
(o.target_model -> 'data'->'clrx'->'os'->>'add') AS os_add,
(o.target_model -> 'data'->'clrx'->'os'->>'bc2') AS os_bc2,
(o.target_model -> 'data'->'clrx'->'os'->>'axis') AS os_axis,
(o.target_model -> 'data'->'clrx'->'os'->>'diam') AS os_diam,
(o.target_model -> 'data'->'clrx'->'os'->'lens'->>'sku') AS os_lens_sku,
(o.target_model -> 'data'->'clrx'->'os'->'lens'->>'name') AS os_lens_name,
(o.target_model -> 'data'->'clrx'->'os'->'lens'->>'style') AS os_lens_style,
(o.target_model -> 'data'->'clrx'->'os'->'lens'->>'manufacturer') AS os_lens_manufacturer,
(o.target_model -> 'data'->'clrx'->'os'->>'color') AS os_color,
(o.target_model -> 'data'->'clrx'->'os'->>'segHt') AS os_segHt,
(o.target_model -> 'data'->'clrx'->'os'->>'addOns') AS os_addOns,
(o.target_model -> 'data'->'clrx'->'os'->>'power1') AS os_power1,
(o.target_model -> 'data'->'clrx'->'os'->>'power2') AS os_power2,
(o.target_model -> 'data'->'clrx'->'os'->>'opticZone') AS os_opticZone,
(o.target_model -> 'data'->'clrx'->'os'->>'thickness') AS os_thickness,
(o.target_model -> 'data'->'clrx'->'os'->>'intermCurve') AS os_intermCurve,
(o.target_model -> 'data'->'clrx'->'os'->>'periphCurve') AS os_periphCurve,
(o.target_model -> 'data'->'clrx'->>'notes') AS clrx_notes,
(o.target_model -> 'data'->'clrx'->>'startDate') AS clrx_startDate,
(o.target_model -> 'data'->'clrx'->>'expirationDate') AS clrx_expirationDate,
(o.target_model -> 'data'->'clrx'->>'expiryChangeReason') AS clrx_expiryChangeReason
   FROM v_migrated_objects o
  WHERE o.model::text = 'CLRx'::text;

ALTER TABLE public.v_migrated_clrx
    OWNER TO postgres;

