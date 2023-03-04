--Delete from source_target_match where source_datasetId = 'contact_lens_evaluation'

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'contact_lens_evaluation' as source_datasetId,
  CONCAT(source.uid,'_clevaluation') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_contact_lens_evaluation as source 
FULL JOIN  v_migrated_contact_lens_evaluation as target ON CONCAT(source.uid,'_clevaluation') = target.source_instanceId 
CROSS JOIN LATERAL (VALUES

--('patient',source.patient,source.patient,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentDate',target.appointmentDate,null),
('candm_detail',source.candm_detail,CASE
	WHEN source.candm_detail = '/null/' OR source.candm_detail is null  THEN ''
 	ELSE source.candm_detail
	END,'drawingnotes',REPLACE(target.drawingnotes,'\n','\\n'),null),
('candm',source.candm::text,CASE
 	WHEN source.candm = 'TRUE' THEN 'true'
 	WHEN source.candm = 'FALSE' THEN 'false'
 	WHEN source.candm = '/null/' OR source.candm is null  THEN null
	END,'goodCentrationMovement',target.goodCentrationMovement,null),
('contact_add_od',source.contact_add_od,CASE
	WHEN source.contact_add_od = '/null/' OR source.contact_add_od is null  THEN ''
 	ELSE source.contact_add_od
	END,'od_add',target.od_add,null),
('contact_acuity_d_od',source.contact_acuity_d_od,CASE
	WHEN source.contact_acuity_d_od = '/null/' OR source.contact_acuity_d_od is null  THEN ''
 	ELSE source.contact_acuity_d_od
	END,'od_dva',target.od_dva,null),
('contact_j_acuity_od',source.contact_j_acuity_od,CASE
	WHEN source.contact_j_acuity_od = '/null/' OR source.contact_j_acuity_od is null  THEN ''
 	ELSE source.contact_j_acuity_od
	END,'od_nva',target.od_nva,null),
('contact_axis_od',source.contact_axis_od,CASE
	WHEN source.contact_axis_od = '/null/' OR source.contact_axis_od is null  THEN ''
 	ELSE source.contact_axis_od
	END,'od_axis',target.od_axis,null),
('od_contact_notes',source.contact_notes,CASE 
 	WHEN source.contact_sph_od is not null AND source.contact_notes != '/null/' THEN source.contact_notes
 	WHEN source.contact_notes is null OR  source.contact_notes='/null/' THEN ''
 	end,'od_notes',target.od_notes,null),
('contact_sph_od',source.contact_sph_od,CASE
	WHEN source.contact_sph_od = '/null/' OR source.contact_sph_od is null  THEN ''
 	ELSE source.contact_sph_od
	END,'od_sphere',target.od_sphere,null),
('contact_cyl_od',source.contact_cyl_od,CASE
	WHEN source.contact_cyl_od = '/null/' OR source.contact_cyl_od is null  THEN ''
 	ELSE source.contact_cyl_od
	END,'od_cylinder',target.od_cylinder,null),
('contact_add_os',source.contact_add_os,CASE
	WHEN source.contact_add_os = '/null/' OR source.contact_add_os is null  THEN ''
 	ELSE source.contact_add_os
	END,'os_add',target.os_add,null),
('contact_acuity_d_os',source.contact_acuity_d_os,CASE
	WHEN source.contact_acuity_d_os = '/null/' OR source.contact_acuity_d_os is null  THEN ''
 	ELSE source.contact_acuity_d_os
	END,'os_dva',target.os_dva,null),
('contact_j_acuity_os',source.contact_j_acuity_os,CASE
	WHEN source.contact_j_acuity_os = '/null/' OR source.contact_j_acuity_os is null  THEN ''
 	ELSE source.contact_j_acuity_os
	END,'os_nva',target.os_nva,null),
('contact_axis_os',source.contact_axis_os,CASE
	WHEN source.contact_axis_os = '/null/' OR source.contact_j_acuity_os is null  THEN ''
 	ELSE source.contact_axis_os
	END,'os_axis',target.os_axis,null),
('os_contact_notes',source.contact_notes,CASE 
 	WHEN source.contact_sph_os is not null AND source.contact_notes != '/null/' THEN source.contact_notes
 	WHEN source.contact_notes is null OR  source.contact_notes='/null/' THEN ''
 	end,'os_notes',target.od_notes,null),
('contact_sph_os',source.contact_sph_os,CASE
	WHEN source.contact_sph_os = '/null/' OR source.contact_sph_os is null  THEN ''
 	ELSE source.contact_sph_os
	END,'os_sphere',target.os_sphere,null),
('contact_cyl_os',source.contact_cyl_os,CASE
	WHEN source.contact_cyl_os = '/null/' OR source.contact_cyl_os is null  THEN ''
 	ELSE source.contact_cyl_os
	END,'os_cylinder',target.os_cylinder,null)

) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					