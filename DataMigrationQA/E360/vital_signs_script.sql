Delete from source_target_match where source_datasetId='vital_signs';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'vital_signs' as source_datasetId,
  CONCAT(source.uid,'_vital_signs') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_vital_signs as source 
FULL JOIN v_migrated_vital_signs as target ON CONCAT(source.uid,'_vital_signs')  = target.source_instanceid 
CROSS JOIN LATERAL (VALUES
  
--('exams.patient',source.exams.patient,source.exams.patient,'patient_id',target.patient_id,null),
--('exams.date',source.exams.date,source.exams.date,'appointmentDate',target.appointmentDate,null),
('diastolic_bp',source.diastolic_bp,CASE
 WHEN source.diastolic_bp ='/null/' OR source.diastolic_bp is null THEN ''
 ELSE source.diastolic_bp
 END,'bloodpressuredia',REPLACE(target.bloodpressuredia,'\n','\\n'),null),
('systolic_bp',source.systolic_bp,CASE
 WHEN source.systolic_bp ='/null/' OR source.systolic_bp is null THEN ''
 ELSE source.systolic_bp
 END,'bloodpressuresys',REPLACE(target.bloodpressuresys,'\n','\\n'),null)					
					
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
