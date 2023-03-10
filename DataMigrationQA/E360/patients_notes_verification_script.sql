--Delete from source_target_match where source_datasetId='patient_notes' 
--Select notes from v_migrated_patient_notes where _id='0c542496-03c4-4c73-b46a-c1f14e9ace5e'

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'patient_notes' as source_datasetId,
  CONCAT(source.uid,'_patient_notes') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_patient_notes as source 
FULL JOIN v_migrated_patient_notes as target ON CONCAT(source.uid,'_patient_notes')  = target.source_instanceid 
CROSS JOIN LATERAL (VALUES

('exams_notes',source.notes,CASE
 WHEN source.notes ='/null/' OR source.notes IS NULL  THEN ''
 else source.notes
 end,'patient_notes',REPLACE(target.notes,'\n','\\n'),null)
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;