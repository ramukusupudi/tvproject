INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
								 target_id, 
								 target_field, target_value, matched, notes)
SELECT 
  'diagnosisdescription ' as source_datasetId,
 CONCAT(source.Plan_uid1,source.Plan_uid2,source.Plan_uid3,source.Plan_uid4,source.Plan_uid5,source.Plan_uid6,source.Plan_uid7) as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_diagnosisdescription as source
FULL JOIN v_migrated_diagnosisdescription as target ON CONCAT(source.Plan_uid1,source.Plan_uid2,source.Plan_uid3,source.Plan_uid4,source.Plan_uid5,source.Plan_uid6,source.Plan_uid7) 
= target.source_instanceId
CROSS JOIN LATERAL (VALUES
  ('diagnosis1',source.diagnosis1,source.diagnosis1,'diagnosis_plan1',target.diagnosis_plan1,null),
  ('diagnosis2',source.diagnosis2,source.diagnosis2,'diagnosis_plan2',target.diagnosis_plan2,null),
  ('diagnosis3',source.diagnosis3,source.diagnosis3,'diagnosis_plan3',target.diagnosis_plan3,null),
  ('diagnosis4',source.diagnosis4,source.diagnosis4,'diagnosis_plan4',target.diagnosis_plan4,null),
  ('diagnosis5',source.diagnosis5,source.diagnosis5,'diagnosis_plan5',target.diagnosis_plan5,null),
  ('diagnosis6',source.diagnosis6,source.diagnosis6,'diagnosis_plan6',target.diagnosis_plan6,null),
  ('diagnosis7',source.diagnosis7,source.diagnosis7,'diagnosis_plan7',target.diagnosis_plan7,null)
 ) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;