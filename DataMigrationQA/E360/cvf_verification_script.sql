Delete from source_target_match where source_datasetId='cvf';


INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'cvf' as source_datasetId,
  CONCAT(source.uid,'_cvf') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_cvf as source 
FULL JOIN v_migrated_cvf as target ON CONCAT(source.uid,'_cvf')  = target.source_instanceid 
CROSS JOIN LATERAL (VALUES
  
('patient_src',source.patient_src::text,source.patient_src::text,patient_sourceId,target.patient_sourceId,null),
('patient_targetId',target.patient_id::text,target.patient_id::text,'patient_tableId',target.patient_targetId,null),
('date',source.date::text,TO_CHAR(source.date::date, 'MM/DD/YYYY'),'AppointmentDate',target.AppointmentDate,null),
('cvf',source.cvf,CASE
 WHEN source.cvf ='/null/' OR source.cvf is null THEN ''
 ELSE source.cvf
 END,'cvf_notes',REPLACE(target.cvf_notes,'\n','\\n'),null)
					
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;