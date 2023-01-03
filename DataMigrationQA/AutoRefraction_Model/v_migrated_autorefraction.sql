-- View: public.v_migrated_autorefraction

-- DROP VIEW public.v_migrated_autorefraction;

CREATE OR REPLACE VIEW public.v_migrated_autorefraction
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.model,
    o.sources,
    o.target_model,
    o.target_model ->> '_id'::text AS _id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    ((o.target_model -> 'keratometry'::text) -> 'od'::text) ->> 'power1'::text AS keratometry_od_power1,
    ((o.target_model -> 'keratometry'::text) -> 'od'::text) ->> 'power2'::text AS keratometry_od_power2,
    ((o.target_model -> 'keratometry'::text) -> 'od'::text) ->> 'vertical'::text AS keratometry_od_vertical,
    ((o.target_model -> 'keratometry'::text) -> 'od'::text) ->> 'horizontal'::text AS keratometry_od_horizontal,
    ((o.target_model -> 'keratometry'::text) -> 'os'::text) ->> 'power1'::text AS keratometry_os_power1,
    ((o.target_model -> 'keratometry'::text) -> 'os'::text) ->> 'power2'::text AS keratometry_os_power2,
    ((o.target_model -> 'keratometry'::text) -> 'os'::text) ->> 'vertical'::text AS keratometry_os_vertical,
    ((o.target_model -> 'keratometry'::text) -> 'os'::text) ->> 'horizontal'::text AS keratometry_os_horizontal,
    (o.target_model -> 'keratometry'::text) ->> 'notes'::text AS keratometry_notes,
    (o.target_model -> 'keratometry'::text) ->> 'method'::text AS keratometry_method,
    (o.target_model -> 'keratometry'::text) ->> 'mirequality'::text AS keratometry_mirequality,
    ((o.target_model -> 'retinoscopy'::text) -> 'od'::text) ->> 'va'::text AS retinoscopy_od_va,
    ((o.target_model -> 'retinoscopy'::text) -> 'od'::text) ->> 'axis'::text AS retinoscopy_od_axis,
    ((o.target_model -> 'retinoscopy'::text) -> 'od'::text) ->> 'sphere'::text AS retinoscopy_od_sphere,
    ((o.target_model -> 'retinoscopy'::text) -> 'od'::text) ->> 'cylinder'::text AS retinoscopy_od_cylinder,
    ((o.target_model -> 'retinoscopy'::text) -> 'os'::text) ->> 'va'::text AS retinoscopy_os_va,
    ((o.target_model -> 'retinoscopy'::text) -> 'os'::text) ->> 'axis'::text AS retinoscopy_os_axis,
    ((o.target_model -> 'retinoscopy'::text) -> 'os'::text) ->> 'sphere'::text AS retinoscopy_os_sphere,
    ((o.target_model -> 'retinoscopy'::text) -> 'os'::text) ->> 'cylinder'::text AS retinoscopy_os_cylinder,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'od'::text) ->> 'axis'::text AS cycloplegicar_od_axis,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'od'::text) ->> 'sphere'::text AS cycloplegicar_od_sphere,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'od'::text) ->> 'cylinder'::text AS cycloplegicar_od_cylinder,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'os'::text) ->> 'axis'::text AS cycloplegicar_os_axis,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'os'::text) ->> 'sphere'::text AS cycloplegicar_os_sphere,
    ((o.target_model -> 'cycloplegicAr'::text) -> 'os'::text) ->> 'cylinder'::text AS cycloplegicar_os_cylinder,
    (o.target_model -> 'cycloplegicAr'::text) ->> 'notes'::text AS cycloplegicar__notes,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'od'::text) ->> 'axis'::text AS cycloplegicret_od_axis,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'od'::text) ->> 'sphere'::text AS cycloplegicret_od_sphere,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'od'::text) ->> 'cylinder'::text AS cycloplegicret_od_cylinder,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'os'::text) ->> 'axis'::text AS cycloplegicret_os_axis,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'os'::text) ->> 'sphere'::text AS cycloplegicret_os_sphere,
    ((o.target_model -> 'cycloplegicRet'::text) -> 'os'::text) ->> 'cylinder'::text AS cycloplegicret_os_cylinder
   FROM v_migrated_objects o
  WHERE o.model::text = 'autorefraction'::text;

ALTER TABLE public.v_migrated_autorefraction
    OWNER TO postgres;

