DELETE FROM source_target_match WHERE  source_datasetId = 'motility';
--select * FROM source_target_match WHERE  source_datasetId = 'motility' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'motility' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_eye_movements as source
FULL JOIN v_migrated_motility as target ON CONCAT(source.uid,'_motility') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('eoms',source.eoms, case
 						  when source.eoms ='/null/' THEN ''
 						  when source.eoms is null THEN ''
 						  when source.eoms ='' THEN ''	
       					  when source.eoms is not null THEN REPLACE(source.eoms,'\\nJerky','\nJerky') end::text,'eom.notes',target.eom_notes,null),
('cover_test_dcover_test_n', CONCAT(source.cover_test_d,source.cover_test_n),case 
 when source.cover_test_d ='/null/' and source.cover_test_n = '/null/'  THEN '' 
 when source.cover_test_d ='/null/' and source.cover_test_n is null  THEN '' 
 when source.cover_test_d is null and source.cover_test_n = '/null/'  THEN ''
 when source.cover_test_d ='' and source.cover_test_n = ''  THEN null 
 when source.cover_test_d is null and source.cover_test_n is null  THEN ''
 when source.cover_test_d is not null and source.cover_test_n is not null  THEN CONCAT('@D ',source.cover_test_d ,'@N ',source.cover_test_n)
 when source.cover_test_d is null and source.cover_test_n is not null THEN CONCAT('@N ',source.cover_test_n)
 when source.cover_test_d is null and source.cover_test_n is not null THEN CONCAT('@D ',source.cover_test_d ) end::text,'eom.covertest.notes',REPLACE(target.eom_covertest_notes,'\\n','\n'),null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;