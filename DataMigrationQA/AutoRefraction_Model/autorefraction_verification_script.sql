--AutoRefraction script
--select * from v_source_autorefraction
--select * from v_migrated_autorefraction;
--Select * from source_target_match WHERE  source_datasetId = 'autorefraction';
--DELETE FROM source_target_match WHERE  source_datasetId = 'autorefraction';


INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'autorefraction' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_autorefraction as source 
FULL JOIN v_migrated_autorefraction as target ON source._id  = target._id 

CROSS JOIN LATERAL (VALUES

('date',source.date,source.date,'appointmentDate',target.appointmentDate,null),
('keratometry_dk_od',source.keratometry_dk_od,source.keratometry_dk_od,'power1',target.power1,null),
('keratometry2_dk_od',source.keratometry2_dk_od,source.keratometry2_dk_od,'power2',target.power2,null),
('keratometry2_axis_od',source.keratometry2_axis_od,source.keratometry2_axis_od,'vertical',target.vertical,null),
('keratometry_axis_od',source.keratometry_axis_od,source.keratometry_axis_od,'horizontal',target.horizontal,null),
('keratometry_dk_os',source.keratometry_dk_os,source.keratometry_dk_os,'power1',target.power1,null),
('keratometry2_dk_os',source.keratometry2_dk_os,source.keratometry2_dk_os,'power2',target.power2,null),
('keratometry2_axis_os',source.keratometry2_axis_os,source.keratometry2_axis_os,'vertical',target.vertical,null),
('keratometry_axis_os',source.keratometry_axis_os,source.keratometry_axis_os,'horizontal',target.horizontal,null),
('retino_acuity_d_od',source.retino_acuity_d_od,source.retino_acuity_d_od,'notes',target.notes,null),
('retino_axis_od',source.retino_axis_od,source.retino_axis_od,'method',target.method,null),
('retino_sph_od',source.retino_sph_od,source.retino_sph_od,'mirequality',target.mirequality,null),
('retino_cyl_od',source.retino_cyl_od,source.retino_cyl_od,'va',target.va,null),
('retino_acuity_d_os',source.retino_acuity_d_os,source.retino_acuity_d_os,'axis',target.axis,null),
('retino_axis_os',source.retino_axis_os,source.retino_axis_os,'sphere',target.sphere,null),
('retino_sph_os',source.retino_sph_os,source.retino_sph_os,'cylinder',target.cylinder,null),
('retino_cyl_os',source.retino_cyl_os,source.retino_cyl_os,'va',target.va,null),
('cyclo_axis_od',source.cyclo_axis_od,source.cyclo_axis_od,'axis',target.axis,null),
('cyclo_sph_od',source.cyclo_sph_od,source.cyclo_sph_od,'sphere',target.sphere,null),
('cyclo_cyl_od',source.cyclo_cyl_od,source.cyclo_cyl_od,'cylinder',target.cylinder,null),
('cyclo_axis_os',source.cyclo_axis_os,source.cyclo_axis_os,'axis',target.axis,null),
('cyclo_sph_os',source.cyclo_sph_os,source.cyclo_sph_os,'sphere',target.sphere,null),
('cyclo_cyl_os',source.cyclo_cyl_os,source.cyclo_cyl_os,'cylinder',target.cylinder,null)
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;