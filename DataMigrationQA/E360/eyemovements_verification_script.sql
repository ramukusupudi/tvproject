DELETE FROM source_target_match WHERE  source_datasetId = 'eyemovement';
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'eyemovement' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_eye_movements as source
FULL JOIN v_migrated_eyemovements as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('eoms',source.eoms,source.eoms,'eom_notes',target.eom_notes,null),					
('cover_test_dcover_test_n',CONCAT(source.cover_test_d,source.cover_test_n),CONCAT('@D ',source.cover_test_d ,'@N ',source.cover_test_n),'lids_lashes_notes',target.lids_lashes_notes,null)

					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;



