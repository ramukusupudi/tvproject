DELETE FROM source_target_match WHERE  source_datasetId = 'external';
--select * FROM source_target_match WHERE  source_datasetId = 'external' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'external' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_external as source
FULL JOIN v_migrated_external as target ON CONCAT(source.uid,'_external') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('slx_ll_od-slx_ll_os',CONCAT(source.slx_ll_od,source.slx_ll_os),case 
 when source.slx_ll_od is null and source.slx_ll_os is null THEN ''
 when source.slx_ll_od ='/null/' and source.slx_ll_os ='/null/' THEN ''
 when source.slx_ll_od ='/null/' and source.slx_ll_os is not null THEN CONCAT('OS:',source.slx_ll_os)
 when source.slx_ll_od is not null and source.slx_ll_os ='/null/' THEN CONCAT('OD:',source.slx_ll_od)
 when source.slx_ll_od is not null  and source.slx_ll_os is not null THEN CONCAT('OD:',source.slx_ll_od,'; OS:',source.slx_ll_os) end,'lids_lashes_notes',target.lids_lashes_notes,null),
('slx_tears_od-slx_tears_os',CONCAT(source.slx_tears_od,source.slx_tears_os),case 
 when source.slx_tears_od is null and source.slx_tears_os is null THEN ''
 when source.slx_tears_od ='/null/' and source.slx_tears_os ='/null/' THEN ''
 when source.slx_tears_od ='/null/' and source.slx_tears_os is not null THEN CONCAT('OS:',source.slx_tears_os)
 when source.slx_tears_od is not null and source.slx_tears_os ='/null/' THEN CONCAT('OD:',source.slx_tears_od)
 when source.slx_tears_od is not null and source.slx_tears_os is not null THEN CONCAT('OD:',source.slx_tears_od,'; OS:',source.slx_tears_os) end,'lacrimal_notes',target.lacrimal_notes,null)										
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;