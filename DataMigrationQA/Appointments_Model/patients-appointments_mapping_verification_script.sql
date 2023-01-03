--Patients-Appointments mapping script
--select * from v_migrated_patients where id='feb5bd40-bd1a-4f8f-afab-fc335ad01a34'
--select * from v_migrated_appointments;
--Select * from source_target_match WHERE  source_datasetId = 'patients_appointments';
--DELETE FROM source_target_match WHERE  source_datasetId = 'patients_appointments';
--Delete from public.source_target_match_dummy
--select * from public.source_target_match_dummy
INSERT INTO source_target_match_dummy(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'patients_appointments' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_migrated_patients as source 
FULL JOIN v_migrated_appointments as target ON source._id  = target.patient_id 
CROSS JOIN LATERAL (VALUES
  
('_id',source._id,source._id,'patient_id', target.patient_id,null)
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;