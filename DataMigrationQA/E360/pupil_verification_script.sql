DELETE FROM source_target_match WHERE  source_datasetId = 'pupil';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'pupil' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_pupil as source
FULL JOIN v_migrated_pupils as target ON CONCAT(source.uid,'_pupil') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patient_src,source.patient_src,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('pupils',source.pupils,case when source.pupils = '/null/' THEN ''
                             when source.pupils is null THEN ''
                             when source.pupils is not null THEN source.pupils
	 end::text,'pupil.OD.notes',target.pupil_od_notes,null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

