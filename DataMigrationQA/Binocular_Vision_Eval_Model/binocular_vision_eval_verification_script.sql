
INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'binocular_vision_eval' as source_datasetId,
  source._id as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_binocular_vision_eval as source 
FULL JOIN v_migrated_binocular_vision_eval as target ON source.uid = target.source_instanceId

CROSS JOIN LATERAL (VALUES
('patient',source.patient,source.patient,'patient_id',target.patient_id,null),
('date',source.date,source.date,'appointmentDate',target.appointmentDate,null),
('npc',source.npc,source.npc,'notes',target.notes,null)
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					
					