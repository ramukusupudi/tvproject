INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'patients_notes' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_patients_notes as source 
FULL JOIN v_migrated_patients_notes as target ON source._id  = target._id 
CROSS JOIN LATERAL (VALUES
  
('exams.patient',source.exams.patient,source.exams.patient,'patient._id',target.patient._id,null),
('exams.date',source.exams.date,source.exams.date,'appointmentDate',target.appointmentDate,null),
('exams.notes',source.exams.notes,source.exams.notes,'notes',target.notes,null)
					
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;