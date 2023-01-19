INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'cvf' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_cvf as source 
FULL JOIN v_migrated_cvf as target ON source._id  = target._id 
CROSS JOIN LATERAL (VALUES
  
('exams.patient',source.exams.patient,source.exams.patient,'patient_id',target.patient_id,null),
('exams.date',source.exams.date,source.exams.date,'appointmentDate',target.appointmentDate,null),
('cvf',source.cvf,source.cvf,'cvf_notes',target.cvf_notes,null)
					
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;