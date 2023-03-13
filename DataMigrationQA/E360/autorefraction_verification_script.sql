DELETE FROM source_target_match WHERE  source_datasetId = 'autorefraction';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'autorefraction' as source_datasetId,
  CONCAT(source.uid,'_ar') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_autorefraction as source 
FULL JOIN v_migrated_autorefraction as target ON CONCAT(source.uid,'_ar') = target.source_instanceId

CROSS JOIN LATERAL (VALUES

--('date',source.date,source.date,'appointmentDate',target.appointmentDate,null),
('keratometry_dk_od_org',source.keratometry_dk_od,CASE 
 	WHEN source.keratometry_dk_od = '/null/' OR source.keratometry_dk_od is null THEN ''
 	ELSE source.keratometry_dk_od
 	END,'keratometry_od_power1_org',target.keratometry_od_power1_org,null),
					/*
('keratometry_dk_od_conv',''::text,CASE 
 	WHEN source.keratometry_dk_od::text = '/null/' OR source.keratometry_dk_od is null THEN null
 	--ELSE (CAST(337.50 AS DOUBLE PRECISION)/CAST(source.keratometry_dk_od AS DOUBLE PRECISION))::text
 ELSE (337.50 ::text/source.keratometry_dk_od ::text)::text
 	END,'keratometry_od_power1_conv',target.keratometry_od_power1_conv::text,null),	
					*/	
					
('keratometry2_dk_od',source.keratometry2_dk_od,CASE 
 	WHEN source.keratometry2_dk_od = '/null/' OR source.keratometry2_dk_od is null THEN ''
 	ELSE source.keratometry2_dk_od
 	END,'keratometry_od_power2_org',target.keratometry_od_power2_org,null),
					/*
('keratometry2_dk_od_conv','',CASE 
 	WHEN source.keratometry2_dk_od = '/null/' OR source.keratometry2_dk_od is null THEN null
 	ELSE (CAST(337.50 AS DOUBLE PRECISION)/CAST(source.keratometry2_dk_od AS DOUBLE PRECISION))::text
 	END,'keratometry_od_power2_conv',target.keratometry_od_power2_conv,null),
					*/
('keratometry2_axis_od',source.keratometry2_axis_od,CASE 
 	WHEN source.keratometry2_axis_od = '/null/' OR source.keratometry2_axis_od is null THEN ''
 	ELSE source.keratometry2_axis_od
 	END,'keratometry_od_vertical',target.keratometry_od_vertical,null),
('keratometry_axis_od',source.keratometry_axis_od,CASE 
 	WHEN source.keratometry_axis_od = '/null/' OR source.keratometry_axis_od is null THEN ''
 	ELSE source.keratometry_axis_od
 	END,'keratometry_od_horizontal',target.keratometry_od_horizontal,null),
('keratometry_dk_os_org',source.keratometry_dk_os,CASE 
 	WHEN source.keratometry_dk_os = '/null/' OR source.keratometry_dk_os is null THEN ''
 	ELSE source.keratometry_dk_os
 	END,'keratometry_os_power1_org',target.keratometry_os_power1_org,null),
					/*
('keratometry_dk_os_conv',source.keratometry_dk_os,CASE 
 	WHEN source.keratometry_dk_os = '/null/' OR source.keratometry_dk_os is null THEN null
 	ELSE (CAST(337.50 AS DOUBLE PRECISION)/CAST(source.keratometry_dk_os AS DOUBLE PRECISION))::text
 	END,'keratometry_os_power1_conv',target.keratometry_os_power1_conv,null),	
					*/
('keratometry2_dk_os_org',source.keratometry2_dk_os,CASE 
 	WHEN source.keratometry2_dk_os = '/null/' OR source.keratometry2_dk_os is null THEN ''
 	ELSE source.keratometry2_dk_os
 	END,'keratometry_os_power2_org',target.keratometry_os_power2_org,null),
					/*
('keratometry2_dk_os_conv',source.keratometry2_dk_os,CASE 
 	WHEN source.keratometry2_dk_os = '/null/' OR source.keratometry2_dk_os is null THEN null
 	ELSE (CAST(337.50 AS DOUBLE PRECISION)/CAST(source.keratometry_dk_os AS DOUBLE PRECISION))::text
 	END,'keratometry_os_power2_conv',target.keratometry_os_power2_conv,null),
					*/
('keratometry2_axis_os',source.keratometry2_axis_os,CASE 
 	WHEN source.keratometry2_axis_os = '/null/' OR source.keratometry2_axis_os is null THEN ''
 	ELSE source.keratometry2_axis_os
 	END,'keratometry_os_vertical',target.keratometry_os_vertical,null),
('keratometry_axis_os',source.keratometry_axis_os,CASE 
 	WHEN source.keratometry_axis_os = '/null/' OR source.keratometry_axis_os is null THEN ''
 	ELSE source.keratometry_axis_os
 	END,'keratometry_os_horizontal',target.keratometry_os_horizontal,null),
('retino_acuity_d_od',source.retino_acuity_d_od,CASE 
 	WHEN source.retino_acuity_d_od = '/null/' OR source.retino_acuity_d_od is null THEN ''
 	ELSE source.retino_acuity_d_od
 	END,'retinoscopy_od_va',target.retinoscopy_od_va,null),
('retino_axis_od',source.retino_axis_od,CASE 
 	WHEN source.retino_axis_od = '/null/' OR source.retino_axis_od is null THEN ''
 	ELSE source.retino_axis_od
 	END,'retinoscopy_od_axis',target.retinoscopy_od_axis,null),
('retino_sph_od',source.retino_sph_od,CASE 
 	WHEN source.retino_sph_od = '/null/' OR source.retino_sph_od is null THEN ''
 	ELSE source.retino_sph_od
 	END,'retinoscopy_od_sphere',target.retinoscopy_od_sphere,null),
('retino_cyl_od',source.retino_cyl_od,CASE 
 	WHEN source.retino_cyl_od = '/null/' OR source.retino_cyl_od is null THEN ''
 	ELSE source.retino_cyl_od
 	END,'retinoscopy_od_cylinder',target.retinoscopy_od_cylinder,null),
('retino_acuity_d_os',source.retino_acuity_d_os,CASE 
 	WHEN source.retino_acuity_d_os = '/null/' OR source.retino_acuity_d_os is null THEN ''
 	ELSE source.retino_acuity_d_os
 	END,'retinoscopy_os_va',target.retinoscopy_os_va,null),
('retino_axis_os',source.retino_axis_os,CASE 
 	WHEN source.retino_axis_os = '/null/' OR source.retino_axis_os is null THEN ''
 	ELSE source.retino_axis_os
 	END,'retinoscopy_os_axis',target.retinoscopy_os_axis,null),
('retino_sph_os',source.retino_sph_os,CASE 
 	WHEN source.retino_sph_os = '/null/' OR source.retino_sph_os is null THEN ''
 	ELSE source.retino_sph_os
 	END,'retinoscopy_os_sphere',target.retinoscopy_os_sphere,null),
('retino_cyl_os',source.retino_cyl_os,CASE 
 	WHEN source.retino_cyl_os = '/null/' OR source.retino_cyl_os is null THEN ''
 	ELSE source.retino_cyl_os
 	END,'retinoscopy_os_cylinder',target.retinoscopy_os_cylinder,null),
('auto_r_axis',source.auto_r_axis,CASE 
 	WHEN source.auto_r_axis = '/null/' OR source.auto_r_axis is null THEN ''
 	ELSE source.auto_r_axis
 	END,'autorefraction_od_axis',target.autorefraction_od_axis,null),
('auto_r_sph',source.auto_r_sph,CASE 
 	WHEN source.auto_r_sph = '/null/' OR source.auto_r_sph is null THEN ''
 	ELSE source.auto_r_sph
 	END,'autorefraction_od_sphere',target.autorefraction_od_sphere,null),
('auto_r_cyl',source.auto_r_cyl,CASE 
 	WHEN source.auto_r_cyl = '/null/' OR source.auto_r_cyl is null THEN ''
 	ELSE source.auto_r_cyl
 	END,'autorefraction_od_cylinder',target.autorefraction_od_cylinder,null),
('auto_l_axis',source.auto_l_axis,CASE 
 	WHEN source.auto_l_axis = '/null/' OR source.auto_l_axis is null THEN ''
 	ELSE source.auto_l_axis
 	END,'autorefraction_os_axis',target.autorefraction_os_axis,null),
('auto_l_sph',source.auto_l_sph,CASE 
 	WHEN source.auto_l_sph = '/null/' OR source.auto_l_sph is null THEN ''
 	ELSE source.auto_l_sph
 	END,'autorefraction_os_sphere',target.autorefraction_os_sphere,null),
('auto_l_cyl',source.auto_l_cyl,CASE 
 	WHEN source.auto_l_cyl = '/null/' OR source.auto_l_cyl is null THEN ''
 	ELSE source.auto_l_cyl
 	END,'autorefraction_os_cylinder',target.autorefraction_os_cylinder,null),					
('auto_notes',source.auto_notes,CASE 
 	WHEN source.auto_notes = '/null/' OR source.auto_notes is null THEN ''
 	ELSE source.auto_notes
 	END,'autorefraction_notes',REPLACE(target.autorefraction_notes,'\n','\\n'),null),
('cyclo_axis_od',source.cyclo_axis_od,CASE 
 	WHEN source.cyclo_axis_od = '/null/' OR source.cyclo_axis_od is null THEN ''
 	ELSE source.cyclo_axis_od
 	END,'cycloplegicret_od_axis',target.cycloplegicret_od_axis,null),
('cyclo_sph_od',source.cyclo_sph_od,CASE 
 	WHEN source.cyclo_sph_od = '/null/' OR source.cyclo_sph_od is null THEN ''
 	ELSE source.cyclo_sph_od
 	END,'cycloplegicret_od_sphere',target.cycloplegicret_od_sphere,null),
('cyclo_cyl_od',source.cyclo_cyl_od,CASE 
 	WHEN source.cyclo_cyl_od = '/null/' OR source.cyclo_cyl_od is null THEN ''
 	ELSE source.cyclo_cyl_od
 	END,'cycloplegicret_od_cylinder',target.cycloplegicret_od_cylinder,null),
('cyclo_axis_os',source.cyclo_axis_os,CASE 
 	WHEN source.cyclo_axis_os = '/null/' OR source.cyclo_axis_os is null THEN ''
 	ELSE source.cyclo_axis_os
 	END,'cycloplegicret_os_axis',target.cycloplegicret_os_axis,null),
('cyclo_sph_os',source.cyclo_sph_os,CASE 
 	WHEN source.cyclo_sph_os = '/null/' OR source.cyclo_sph_os is null THEN ''
 	ELSE source.cyclo_sph_os
 	END,'cycloplegicret_os_sphere',target.cycloplegicret_os_sphere,null),
('cyclo_cyl_os',source.cyclo_cyl_os,CASE 
 	WHEN source.cyclo_cyl_os = '/null/' OR source.cyclo_cyl_os is null THEN ''
 	ELSE source.cyclo_cyl_os
 	END,'cycloplegicret_os_cylinder',target.cycloplegicret_os_cylinder,null)
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;