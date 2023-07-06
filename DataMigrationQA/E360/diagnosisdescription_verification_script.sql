DELETE FROM source_target_match WHERE  source_datasetId = 'diagnosisdescription';
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
								 target_id, 
								 target_field, target_value, matched, notes)
SELECT 
  'diagnosisdescription' as source_datasetId,
 concat(source.uid,'_','diagnosisdescription') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_diagnosisdescription as source
FULL JOIN v_migrated_diagnosisdescription as target ON concat(source.uid,'_','diagnosisDescription')= target.source_instanceId
CROSS JOIN LATERAL (VALUES
  ('patient_src',source.patient_src::text,source.patient_src::text,'patient_sourceId',target.patient_sourceId,null),				
  ('date',source.date::text,TO_CHAR(source.date::DATE,'mm/dd/yyyy'),'appointmentdate',target.appointmentdate,null),
  ('plan_description1',source.plan_description1,source.plan_description1,'diagnosis_plan1',target.diagnosis_plan1,null),
  ('plan_description2',source.plan_description2,source.plan_description2,'diagnosis_plan2',target.diagnosis_plan2,null),
  ('impression_icd101',source.impression_icd101,source.impression_icd101,'diagnosis_icdcode1',target.diagnosis_icdcode1,null),
  ('impression_icd102',source.impression_icd102,source.impression_icd102,'diagnosis_icdcode2',target.diagnosis_icdcode2,null),
  ('impression_desc1',source.impression_desc1,source.impression_desc1,'diagnosis_desc1',target.diagnosis_desc1,null),
  ('impression_desc2',source.impression_desc2,source.impression_desc2,'diagnosis_desc2',target.diagnosis_desc2,null)					
 ) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
--select * FROM source_target_match WHERE  source_datasetId = 'diagnosisdescription' and matched ='FALSE' and target_value is not null