--select * from v_source_employees
--select * from v_migrated_employees
--Select * from source_target_match WHERE  source_datasetId = 'employees';
--DELETE FROM source_target_match WHERE  source_datasetId = 'employees';


INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'sle' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_sle as source
FULL JOIN v_migrated_sle as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('patient',source.patient,source.patient,'patient_id',target.patient_id,null),
('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('slx_lens_od',source.slx_lens_od,source.slx_lens_od,'lens_OD_notes',target.lens_OD_notes,null),
('slx_lens_os ',source.slx_lens_os ,source.slx_lens_os ,'lens_OS_notes',target.lens_OS_notes,null),
('slx_cornea_od',source.slx_cornea_od,source.slx_cornea_od,'cornea_OD_notes',target.cornea_OD_notes,null),
('slx_cornea_os',source.slx_cornea_os,source.slx_cornea_os,'cornea_OS_notes',target.cornea_OS_notes,null),
('slx_iris_od',source.slx_iris_od,source.slx_iris_od,'irisPupil_OD_notes',target.irisPupil_OD_notes,null),
('slx_iris_os',source.slx_iris_os,source.slx_iris_os,'irisPupil_OS_notes',target.irisPupil_OS_notes,null),
('slx_a_c_od',source.slx_a_c_od,source.slx_a_c_od,'antchamber_OD_notes',target.antchamber_OD_notes,null),
('slx_a_c_os',source.slx_a_c_os,source.slx_a_c_os,'antchamber_OS_notes',target.antchamber_OS_notes,null),
('slx_conj_od',source.slx_conj_od ,case
       when source.slx_conj_od is null THEN source.slx_sclera_od
  when source.slx_sclera_od is null THEN source.slx_conj_od
 when source.slx_sclera_od is null AND source.slx_conj_od is null THEN null
 		when source.slx_sclera_od is not null AND source.slx_conj_od is not null THEN CONCAT(source.slx_conj_od,source.slx_sclera_od)
	    end::text,
 'Conjunctiva_OD_notes',target.Conjunctiva_OD_notes,null),
('slx_conj_os',source.slx_conj_os ,case
       when source.slx_conj_os is null THEN source.slx_sclera_os
  when source.slx_sclera_os is null THEN source.slx_conj_os
 		when source.slx_conj_os is not null AND source.slx_sclera_os is not null THEN CONCAT(source.slx_conj_os,source.slx_sclera_os)
	    end::text,'Conjunctiva_OS_notes',target.Conjunctiva_OS_notes,null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

					
