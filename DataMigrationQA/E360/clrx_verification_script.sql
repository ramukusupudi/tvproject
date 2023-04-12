--CLRx Script
DELETE FROM source_target_match WHERE  source_datasetId = 'CLRx';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'CLRx' as source_datasetId,
  CONCAT(source.examsuid,'_',source.cpuid,'_clrx') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_clrx as source
FULL JOIN v_migrated_CLRx as target ON CONCAT(source.examsuid,'_',source.cpuid,'_clrx')  = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('trial',source.trial::text,source.trial::text,'os_t',target.os_t,null),
('r_bc2',source.r_bc2::text,CASE 
 	WHEN source.r_bc2::text is null THEN ''
 	else source.r_bc2::text
 	end,'od_bc2',target.od_bc2,null),					
('r_axis',source.r_axis::text,CASE 
 	WHEN source.r_axis::text is null OR source.r_axis::text = '/null/' THEN ''
 	else source.r_axis::text
 	end,'clrx_od_axis',target.clrx_od_axis,null),
('r_diameter',source.r_diameter::text,CASE 
 	WHEN source.r_diameter::text is null OR source.r_diameter::text = '/null/' THEN ''
 	else source.r_diameter::text
 	end,'od_diam',target.od_diam,null),
('od_sku',source.sku::text,CASE 
 	WHEN source.sku::text is null OR source.sku::text = '/null/' THEN ''
 	else source.sku::text
 	end,'od_lens_sku',target.od_sku,null),
('od_name',source.name,CASE 
 	WHEN source.name::text is null OR source.name::text = '/null/' THEN ''
 	else source.name::text
 	end,'od_lens_name',target.od_name,null),
('od_cl_stylename',source.cl_stylename,CASE 
 	WHEN source.cl_stylename::text is null OR source.cl_stylename::text = '/null/' THEN ''
 	else source.cl_stylename::text
 	end,'od_lens_style',target.od_style,null),
('od_mfg',source.mfg,CASE 
 	WHEN source.mfg::text is null OR source.mfg::text = '/null/' THEN ''
 	else source.mfg::text
 	end,'od_lens_manufacturer',target.od_manufacturer,null),
('od_cl_typename',source.cl_typename,CASE
 	WHEN source.eye ='1' OR source.eye = '3' THEN source.cl_typename::text
 	else ''
 	end,'od_type',target.od_type,null),					
('r_color',source.r_color,CASE 
 	WHEN source.r_color::text is null OR source.r_color::text = '/null/' THEN ''
 	else source.r_color::text
 	end,'od_color',target.od_color,null),
('od_notes',source.eye::text,CASE 
 	WHEN (source.eye::text ='1' OR source.eye::text = '3') AND source.notes::text IS NOT NULL THEN source.notes::text
 	WHEN source.notes::text is null OR source.notes::text = '/null/' THEN ''
 	else ''
 	end,'clrx_od_notes',target.clrx_od_notes,null),					
('r_seg',source.r_seg,CASE 
 	WHEN source.r_seg::text is null OR source.r_seg::text = '/null/' THEN ''
 	else source.r_seg::text
 	end,'od_segHt',target.od_segHt,null),
('r_sc',source.r_sc,CASE 
 	WHEN source.r_sc::text is null OR source.r_sc::text = '/null/' THEN ''
 	else source.r_sc::text
 	end,'od_skirt',target.od_skirt,null),					
('r_addon',source.r_addon,CASE 
 	WHEN source.r_addon::text is null OR source.r_addon::text = '/null/' THEN ''
 	else source.r_addon::text
 	end,'od_addOns',target.od_addOns,null),
('r_power',source.r_power,CASE 
 	WHEN source.r_power::text is null OR source.r_power::text = '/null/' THEN ''
 	else source.r_power::text
 	end,'od_power1',target.od_power1,null),
('r_power2',source.r_power2,CASE 
 	WHEN source.r_power2::text is null OR source.r_power2::text = '/null/' THEN ''
 	else source.r_power2::text
 	end,'od_power2',target.od_power2,null),
('r_cyl',source.r_cyl,CASE 
 	WHEN source.r_cyl::text is null OR source.r_cyl::text = '/null/' THEN ''
 	else source.r_cyl::text
 	end,'clrx_od_cylinder',target.clrx_od_cylinder,null),
('r_material',source.r_material,CASE 
 	WHEN source.r_material::text is null OR source.r_material::text = '/null/' THEN ''
 	else source.r_material::text
 	end,'od_material',target.od_material,null),
('r_oz',source.r_oz,CASE 
 	WHEN source.r_oz::text is null OR source.r_oz::text = '/null/' THEN ''
 	else source.r_oz::text
 	end,'od_opticZone',target.od_opticZone,null),
('r_thickness',source.r_thickness,CASE 
 	WHEN source.r_thickness::text is null OR source.r_thickness::text = '/null/' THEN ''
 	else source.r_thickness::text
 	end,'od_thickness',target.od_thickness,null),
('r_intermediate',source.r_intermediate,CASE 
 	WHEN source.r_intermediate::text is null OR source.r_intermediate::text = '/null/' THEN ''
 	else source.r_intermediate::text
 	end,'od_intermCurve',target.od_intermCurve,null),
('r_periph',source.r_periph,CASE 
 	WHEN source.r_periph::text is null OR source.r_periph::text = '/null/' THEN ''
 	else source.r_periph::text
 	end,'od_periphCurve',target.od_periphCurve,null),
('l_bc',source.l_bc,CASE 
 	WHEN source.l_bc::text is null OR source.l_bc::text = '/null/' THEN ''
 	else source.l_bc::text
 	end,'os_bc',target.os_bc,null),
('l_add',source.l_add,CASE 
 	WHEN source.l_add::text is null OR source.l_add::text = '/null/' THEN ''
 	else source.l_add::text
 	end,'clrx_os_add',target.clrx_os_add,null),
('l_bc2',source.l_bc2,CASE 
 	WHEN source.l_bc2::text is null OR source.l_bc2::text = '/null/' THEN ''
 	else source.l_bc2::text
 	end,'os_bc2',target.os_bc2,null),
('l_axis',source.l_axis,CASE 
 	WHEN source.l_axis::text is null OR source.l_axis::text = '/null/' THEN ''
 	else source.l_axis::text
 	end,'clrx_os_axis',target.clrx_os_axis,null),
('l_diameter',source.l_diameter::text,CASE 
 	WHEN source.l_diameter::text is null OR source.l_diameter::text = '/null/' THEN ''
 	else source.l_diameter::text
 	end,'os_diam',target.os_diam,null),
('os_sku',source.sku::text,CASE 
 	WHEN source.sku::text is null OR source.sku::text = '/null/' THEN ''
 	else source.sku::text
 	end,'os_sku',target.os_sku,null),
('os_name',source.name,CASE 
 	WHEN source.name::text is null OR source.name::text = '/null/' THEN ''
 	else source.name::text
 	end,'os_name',target.os_name,null),
('os_cl_stylename',source.cl_stylename,CASE 
 	WHEN source.cl_stylename::text is null OR source.cl_stylename::text = '/null/' THEN ''
 	else source.cl_stylename::text
 	end,'os_style',target.os_style,null),
('os_mfg',source.mfg,CASE 
 	WHEN source.mfg::text is null OR source.mfg::text = '/null/' THEN ''
 	else source.mfg::text
 	end,'os_manufacturer',target.os_manufacturer,null),
('os_cl_typename',source.mfg,CASE
 	WHEN source.eye ='2' OR source.eye = '3' THEN source.cl_typename::text
 	--WHEN source.cl_typename::text is null OR source.cl_typename::text = '/null/' THEN ''
 	else ''
 	end,'os_type',target.os_type,null),					
('l_color',source.l_color,CASE 
 	WHEN source.l_color::text is null OR source.l_color::text = '/null/' THEN ''
 	else source.l_color::text
 	end,'os_color',target.os_color,null),
('os_notes',source.notes,CASE 
 	WHEN (source.eye ='2' OR source.eye = '3') AND source.notes::text IS NOT NULL THEN source.notes::text
 	WHEN source.notes::text is null OR source.notes::text = '/null/' THEN ''
 	else ''
 	end,'clrx_os_notes',target.clrx_os_notes,null),
('l_seg',source.l_seg,CASE 
 	WHEN source.l_seg::text is null OR source.l_seg::text = '/null/' THEN ''
 	else source.l_seg::text
 	end,'os_segHt',target.os_segHt,null),
('l_addon',source.l_addon,CASE 
 	WHEN source.l_addon::text is null OR source.l_addon::text = '/null/' THEN ''
 	else source.l_addon::text
 	end,'os_addOns',target.os_addOns,null),
('l_power',source.l_power,CASE 
 	WHEN source.l_power::text is null OR source.r_axis::text = '/null/' THEN ''
 	else source.l_power::text
 	end,'os_power1',target.os_power1,null),
('l_power2',source.l_power2,CASE 
 	WHEN source.l_power2::text is null OR source.l_power::text = '/null/' THEN ''
 	else source.l_power2::text
 	end,'os_power2',target.os_power2,null),
('l_oz',source.l_oz,CASE 
 	WHEN source.l_oz::text is null OR source.l_oz::text = '/null/' THEN ''
 	else source.l_oz::text
 	end,'os_opticZone',target.os_opticZone,null),
('l_thickness',source.l_thickness,CASE 
 	WHEN source.l_thickness::text is null OR source.l_thickness::text = '/null/' THEN ''
 	else source.l_thickness::text
 	end,'os_thickness',target.os_thickness,null),
('l_intermediate',source.l_intermediate,CASE 
 	WHEN source.l_intermediate::text is null OR source.l_intermediate::text = '/null/' THEN ''
 	else source.l_intermediate::text
 	end,'os_intermCurve',target.os_intermCurve,null),
('l_periph',source.l_periph,CASE 
 	WHEN source.l_periph::text is null OR source.l_periph::text = '/null/' THEN ''
 	else source.l_periph::text
 	end,'os_periphCurve',target.os_periphCurve,null),
('eye_dominance',source.eye_dominance,CASE
 	WHEN source.eye_dominance::text = 'R' THEN '"OD"'
 	WHEN source.eye_dominance::text = 'L' THEN '"OS"'
 	WHEN source.eye_dominance::text is null OR source.eye_dominance::text = '/null/' THEN null
 	end,'clrx_eyeDom',target.clrx_eyeDom::text,null),					
('notes',source.notes,CASE 
 	WHEN source.notes::text is null OR source.notes::text = '/null/' THEN ''
 	else source.notes::text
 	end,'data_notes',target.data_notes,null),
('candm_detail',source.candm_detail,CASE 
 	WHEN source.candm_detail::text is null OR source.candm_detail::text = '/null/' THEN ''
 	else source.candm_detail::text
 	end,'drawing_notes',REPLACE(target.drawing_notes,'\n','\\n'),null),
('cpdate',to_char(source.cpdate, 'MM/DD/YYYY'),CASE 
 	WHEN source.cpdate is null OR source.cpdate::text = '/null/' THEN null
 	else to_char(source.cpdate, 'MM/DD/YYYY')
 	end,'data_startDate',target.data_startDate,null),
('candm',source.candm,CASE
 	WHEN source.candm::text is null then null
 	WHEN source.candm::text = 'FALSE' then 'false'
 	WHEN source.candm::text = 'TRUE' then 'true'
 	end,'clEvaluation_goodCentrationMovement',target.clEvaluation_goodCentrationMovement,null),	
('expiration_date',to_char(source.expiration_date, 'MM/DD/YYYY'),CASE 
 	WHEN source.expiration_date is null OR source.expiration_date::text = '/null/' THEN ''
 	else to_char(source.expiration_date, 'MM/DD/YYYY')
 	end::text,'data_expirationDate',target.data_expirationDate::text,null),
('contact_add_od',source.contact_add_od::text,CASE 
 	WHEN source.contact_add_od::text is null OR source.contact_add_od::text = '/null/' THEN ''
 	else source.contact_add_od::text
 	end::text,'od_add',target.od_add::text,null),					
('contact_acuity_d_od',source.contact_acuity_d_od::text,CASE 
 	WHEN source.contact_acuity_d_od::text is null  OR source.contact_acuity_d_od::text = '/null/' THEN ''
 	else source.contact_acuity_d_od::text
 	end::text,'od_dva',target.od_dva::text,null),	
('contact_j_acuity_od',source.contact_j_acuity_od::text,CASE 
 	WHEN source.contact_j_acuity_od::text is null OR source.contact_j_acuity_od::text = '/null/' THEN ''
 	else source.contact_j_acuity_od::text
 	end::text,'od_nva',target.od_nva::text,null),	
('contact_axis_od',source.contact_axis_od::text,CASE 
 	WHEN source.contact_axis_od::text is null OR source.contact_axis_od::text = '/null/' THEN ''
 	else source.contact_axis_od::text
 	end::text,'od_axis',target.od_axis::text,null),	
('od_contact_notes',source.contact_notes::text,CASE
 	WHEN source.contact_sph_od is not null AND source.contact_sph_od != '/null/' AND source.contact_notes::text != '/null/'  THEN source.contact_notes::text
 	WHEN source.contact_sph_od = '/null/' THEN ''
 	else ''
 	end,'od_notes',target.od_notes::text,null),	
('contact_sph_od',source.contact_sph_od::text,CASE 
 	WHEN source.contact_sph_od::text is null OR source.contact_sph_od::text = '/null/' THEN ''
 	else source.contact_sph_od::text
 	end::text,'od_sphere',target.od_sphere::text,null),	
('contact_cyl_od',source.contact_cyl_od::text,CASE 
 	WHEN source.contact_cyl_od::text is null OR source.contact_cyl_od::text = '/null/' THEN ''
 	else source.contact_cyl_od::text
 	end::text,'od_cylinder',target.od_cylinder::text,null),						
('contact_add_os',source.contact_add_os::text,CASE 
 	WHEN source.contact_add_os::text is null OR source.contact_add_os::text = '/null/' THEN ''
 	else source.contact_add_os::text
 	end::text,'os_add',target.os_add::text,null),					
('contact_acuity_d_os',source.contact_acuity_d_os::text,CASE 
 	WHEN source.contact_acuity_d_os::text is null OR source.contact_acuity_d_os::text = '/null/' THEN ''
 	else source.contact_acuity_d_os::text
 	end::text,'os_dva',target.os_dva::text,null),	
('contact_j_acuity_os',source.contact_j_acuity_os::text,CASE 
 	WHEN source.contact_j_acuity_os::text is null OR source.contact_j_acuity_os::text = '/null/' THEN ''
 	else source.contact_j_acuity_os::text
 	end::text,'os_nva',target.os_nva::text,null),	
('contact_axis_os',source.contact_axis_os::text,CASE 
 	WHEN source.contact_axis_os::text is null OR source.contact_axis_os::text = '/null/' THEN ''
 	else source.contact_axis_os::text
 	end::text,'os_axis',target.os_axis::text,null),	
('os_contact_notes',source.contact_notes::text,CASE
 	WHEN source.contact_sph_os::text is not null AND source.contact_sph_os::text != '/null/' AND source.contact_notes::text !='/null/' THEN source.contact_notes::text
 	WHEN source.contact_sph_os::text = '/null/' THEN ''
 	else ''
 	end::text,'os_notes',target.os_notes::text,null),	
('contact_sph_os',source.contact_sph_os::text,CASE 
 	WHEN source.contact_sph_os::text is null OR source.contact_sph_os::text = '/null/' THEN ''
 	else source.contact_sph_os::text
 	end::text,'os_sphere',target.os_sphere::text,null),	
('contact_cyl_os',source.contact_cyl_os::text,CASE 
 	WHEN source.contact_cyl_os::text is null OR source.contact_cyl_os::text = '/null/' THEN ''
 	else source.contact_cyl_os::text
 	end::text,'os_cylinder',target.os_cylinder::text,null),							
('expiration_reason',source.expiration_reason,CASE 
 	WHEN source.expiration_reason is null OR source.expiration_reason::text = '/null/' THEN ''
 	else source.expiration_reason::text
 	end,'data_expiryChangeReason',target.data_expiryChangeReason,null),
('r_edge_lift',source.r_edge_lift,CASE 
 	WHEN source.r_edge_lift is null OR source.r_edge_lift::text = '/null/' THEN ''
 	else source.r_edge_lift::text
 	end,'od_edgeLift',target.od_edgeLift,null),
('l_edge_lift',source.l_edge_lift,CASE 
 	WHEN source.l_edge_lift is null OR source.l_edge_lift::text = '/null/' THEN ''
 	else source.l_edge_lift::text
 	end,'os_edgeLift',target.os_edgeLift,null),
('l_dn',source.l_dn,CASE 
 	WHEN source.l_dn is null OR source.l_dn::text = '/null/' THEN ''
 	else source.l_dn::text
 	end,'clrx_os_dn',target.clrx_os_dn,null),	
('r_dn',source.r_dn,CASE 
 	WHEN source.r_dn is null OR source.r_dn::text = '/null/' THEN ''
 	else source.r_dn::text
 	end,'od_dn',target.od_dn,null),
('od_trial',source.trial::text,CASE 
 	WHEN source.trial::text is null OR source.trial::text = '/null/' THEN ''
 	else source.trial::text
 	end,'od_t',target.od_t,null),
('r_bc',source.r_bc,CASE 
 	WHEN source.r_bc is null OR source.r_bc::text = '/null/' THEN ''
 	else source.r_bc::text
 	end,'od_bc',target.od_bc,null),	
('r_add',source.r_add,CASE 
 	WHEN source.r_add is null OR source.r_add::text = '/null/' THEN ''
 	else source.r_add::text
 	end,'clrx_od_add',target.clrx_od_add,null)						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
