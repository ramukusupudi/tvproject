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
  
('patient_src',source.patient_src::text,source.patient_src::text,'patient_sourceId',target.patient_sourceId,null),
('date',source.date::text,TO_CHAR(source.date::date, 'MM/DD/YYYY'),'AppointmentDate',target.AppointmentDate,null),
('diastolic_bp',source.vital_signs->0->>'PatientStats_diastolic_bp',CASE
 WHEN source.vital_signs->0->>'PatientStats_diastolic_bp' ='/null/' OR source.vital_signs->0->>'PatientStats_diastolic_bp' is null THEN ''
 ELSE source.vital_signs->0->>'PatientStats_diastolic_bp'
 END,'bloodpressuredia',REPLACE(target.bloodpressuredia,'\n','\\n'),null),
('systolic_bp',source.vital_signs->0->>'PatientStats_systolic_bp',CASE
 WHEN source.vital_signs->0->>'PatientStats_systolic_bp' ='/null/' OR source.vital_signs->0->>'PatientStats_systolic_bp' is null THEN ''
 ELSE source.vital_signs->0->>'PatientStats_systolic_bp'
 END,'bloodpressuresys',REPLACE(target.bloodpressuresys,'\n','\\n'),null),					
('PatientStats_date',source.vital_signs->0->>'PatientStats_date'::text,TO_CHAR((source.vital_signs->0->>'PatientStats_date')::date, 'MM/DD/YYYY'),'vital_date',target.vital_date::text,null)					
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

