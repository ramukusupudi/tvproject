INSERT INTO source_target_match_dummy(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'contact_lens_evaluation' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_migrated_patients as source 
FULL JOIN v_migrated_appointments as target ON source.uid = target.source_instanceId 
CROSS JOIN LATERAL (VALUES

('patient',source.patient,source.patient,'patient_id',target.patient_id,null),
('date',source.date,source.date,'appointmentDate',target.appointmentDate,null),
('candm_detail',source.candm_detail,source.candm_detail,'notes',target.notes,null),
('candm',source.candm,source.candm,'goodCentrationMovement',target.goodCentrationMovement,null),
('contact_add_od',source.contact_add_od,source.contact_add_od,'od_add',target.od_add,null),
('contact_acuity_d_od',source.contact_acuity_d_od,source.contact_acuity_d_od,'od_dva',target.od_dva,null),
('contact_j_acuity_od',source.contact_j_acuity_od,source.contact_j_acuity_od,'od_nva',target.od_nva,null),
('contact_axis_od',source.contact_axis_od,source.contact_axis_od,'od_axis',target.od_axis,null),
('contact_notes',source.contact_notes,source.contact_notes,'od_notes',target.od_notes,null),
('contact_sph_od',source.contact_sph_od,source.contact_sph_od,'od_sphere',target.od_sphere,null),
('contact_cyl_od',source.contact_cyl_od,source.contact_cyl_od,'od_cylinder',target.od_cylinder,null),
('contact_add_os',source.contact_add_os,source.contact_add_os,'os_add',target.os_add,null),
('contact_acuity_d_os',source.contact_acuity_d_os,source.contact_acuity_d_os,'os_dva',target.os_dva,null),
('contact_j_acuity_os',source.contact_j_acuity_os,source.contact_j_acuity_os,'os_nva',target.os_nva,null),
('contact_axis_os',source.contact_axis_os,source.contact_axis_os,'os_axis',target.os_axis,null),
('contact_sph_os',source.contact_sph_os,source.contact_sph_os,'os_sphere',target.os_sphere,null),
('contact_cyl_os',source.contact_cyl_os,source.contact_cyl_os,'os_cylinder',target.os_cylinder,null)

) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					