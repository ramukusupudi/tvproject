--DELETE FROM source_target_match WHERE  source_datasetId = 'sle'
--select * FROM source_target_match WHERE  source_datasetId = 'sle' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'sle' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_sle as source
FULL JOIN v_migrated_sle as target ON CONCAT(source.uid,'_sle') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patient',source.patient,source.patient,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('slx_lens_od',source.slx_lens_od,case  when source.slx_lens_od ='/null/' THEN '' 
                                        when source.slx_lens_od is not null THEN source.slx_lens_od
 									 	when source.slx_lens_od is null THEN ''
 										when source.slx_lens_od ='' THEN ''end::text,'lens_OD_notes',target.lens_OD_notes,null),
					
('slx_lens_os ',source.slx_lens_os ,case when source.slx_lens_os is null THEN ''
                                         when source.slx_lens_os is not null THEN source.slx_lens_os
 										 when source.slx_lens_os ='/null/' THEN ''
                                         when source.slx_lens_os ='' THEN '' end::text
 ,'lens_OS_notes',target.lens_OS_notes,null),
('slx_cornea_od',source.slx_cornea_od,case when source.slx_cornea_od ='/null/' THEN ''
 										   when source.slx_cornea_od ='' THEN ''	
 										   when source.slx_cornea_od is not null THEN source.slx_cornea_od
                                           when source.slx_cornea_od is null THEN '' end::text,
 'cornea_OD_notes',target.cornea_OD_notes,null),
('slx_cornea_os',source.slx_cornea_os,case when source.slx_cornea_os is null THEN ''
 										   when source.slx_cornea_os ='/null/' THEN ''	
 										   when source.slx_cornea_os is not null THEN source.slx_cornea_os
									       when source.slx_cornea_os ='' THEN '' end::text ,'cornea_OS_notes',target.cornea_OS_notes,null),
('slx_iris_od',source.slx_iris_od, case when source.slx_iris_od ='/null/' THEN ''
 										when source.slx_iris_os ='' THEN ''
 										when source.slx_iris_od is not null THEN source.slx_iris_od
  								        when source.slx_iris_od is null THEN '' end::text
 ,'irisPupil_OD_notes',target.irisPupil_OD_notes,null),
('slx_iris_os',source.slx_iris_os, case when source.slx_iris_os is null THEN ''
 										when source.slx_iris_os = '/null/' THEN ''
 										when source.slx_iris_os is not null THEN source.slx_iris_os
                                        when source.slx_iris_os = '' THEN ''end::text ,'irisPupil_OS_notes',target.irisPupil_OS_notes,null),
('slx_a_c_od',source.slx_a_c_od, case when source.slx_a_c_od  is null THEN ''
 									   when source.slx_a_c_od='/null/' THEN ''	
                 					   when source.slx_a_c_od  is not null THEN source.slx_a_c_od 
 		                               when source.slx_a_c_od='' THEN '' end::text ,'antchamber_OD_notes',target.antchamber_OD_notes,null),
('slx_a_c_os',source.slx_a_c_os, case when source.slx_a_c_os ='/null/' THEN ''
 									  when source.slx_a_c_os = '' THEN ''
 									  when source.slx_a_c_os is not null THEN source.slx_a_c_os	
 									  when source.slx_a_c_os is null THEN '' end::text ,'antchamber_OS_notes',target.antchamber_OS_notes,null),
('slx_conj_od',source.slx_conj_od ,case when source.slx_sclera_od is null AND source.slx_conj_od is null THEN ''
        when source.slx_conj_od is null THEN source.slx_sclera_od
        when source.slx_sclera_od is null THEN source.slx_conj_od
        when source.slx_sclera_od = '/null/' AND source.slx_conj_od ='/null/' THEN ''
 		when source.slx_sclera_od is not null AND source.slx_conj_od is not null THEN CONCAT('Conj:',source.slx_conj_od,'; Sclera:',source.slx_sclera_od)
	    end::text,
 'Conjunctiva_OD_notes',target.Conjunctiva_OD_notes,null),
('slx_conj_os',source.slx_conj_os ,case when source.slx_sclera_os is null and source.slx_conj_os is null THEN ''
       when source.slx_conj_os is null THEN source.slx_sclera_os
       when source.slx_sclera_os is null THEN source.slx_conj_os
       when source.slx_sclera_os ='/null/' and source.slx_conj_os ='/null/' THEN ''
 		when source.slx_conj_os is not null AND source.slx_sclera_os is not null THEN CONCAT('Conj:',source.slx_conj_os,'; Sclera:',source.slx_sclera_os)
	    end::text,'Conjunctiva_OS_notes',target.Conjunctiva_OS_notes,null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
