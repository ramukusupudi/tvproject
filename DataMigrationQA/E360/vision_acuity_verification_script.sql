DELETE FROM source_target_match WHERE  source_datasetId = 'Vision Acuities';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'Vision Acuities' as source_datasetId,
  CONCAT(source.uid,'_VISION_ACUITIES') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_vision_acuities as source
FULL JOIN v_migrated_visionacuity as target ON CONCAT(source.uid,'_VISION_ACUITIES') = target.source_instanceId
CROSS JOIN LATERAL (VALUES

('patient_src',source.patient_src::text,source.patient_src::text,patient_sourceId,target.patient_sourceId,null),
('patient_targetId',target.patient_id::text,target.patient_id::text,patient_tableId',target.patient_targetId,null),
('date',source.date,source.date,'AppointmentDate',target.AppointmentDate,null),
('acuity_n_od', source.acuity_n_od, case
       when source.acuity_n_type = 'N' AND source.acuity_n_od !='/null/' THEN source.acuity_n_od
       WHEN source.acuity_n_od ='/null/' OR source.acuity_n_od is null THEN ''
 	   WHEN source.acuity_n_type != 'N' THEN ''		
 	   end::text,
   'near_od_cc', target.near_od_cc, null),
('acuity_n_os', source.acuity_n_os, case
       when source.acuity_n_type = 'N' AND source.acuity_n_os !='/null/' THEN source.acuity_n_os
       WHEN source.acuity_n_os ='/null/' OR source.acuity_n_os is null THEN ''
 	   WHEN source.acuity_n_type != 'N' THEN ''
 	   end::text,
   'near_os_cc', target.near_os_cc, null),
('acuity_n_ou', source.acuity_n_ou, case
       when source.acuity_n_type = 'N' AND source.acuity_n_ou !='/null/' AND  source.acuity_n_ou is not null THEN source.acuity_n_ou
       WHEN source.acuity_n_ou ='/null/' OR source.acuity_n_ou is null OR source.acuity_n_type is null THEN ''
 	   WHEN source.acuity_n_type != 'N' THEN ''
 	   end::text,
   'near_ou_cc', target.near_ou_cc, null),
('near_value','',case
       when source.acuity_n_type = 'N' THEN 'Snellen'
 	   WHEN source.acuity_n_type != 'N' THEN ''
 	   ELSE ''	
 	   end::text,'near_value', target.near_value,null),
('acuity_d_od',source.acuity_d_od,CASE 
	 WHEN source.acuity_d_od ='/null/' OR source.acuity_d_od is null THEN ''
 	 ELSE source.acuity_d_od
  	 END,'distance_od_ph', target.distance_od_ph,null),
('acuity_d_os',source.acuity_d_os,CASE 
	 WHEN source.acuity_d_os ='/null/' OR source.acuity_d_os is null THEN ''
 	 ELSE source.acuity_d_os
  	 END,'distance_os_ph', target.distance_os_ph,null),
('acuity_d_ou',source.acuity_d_ou,CASE 
	 WHEN source.acuity_d_ou ='/null/' OR source.acuity_d_ou is null THEN ''
 	 ELSE source.acuity_d_ou
  	 END,'distance_ou_ph', target.distance_ou_ph,null),
('distance_value','','Snellen','distance_value', target.distance_value,null),
('super_acuity_n_od', source.acuity_n_od, case
       WHEN source.acuity_n_type = 'PH' AND source.acuity_n_od !='/null/' THEN source.acuity_n_od
 	   WHEN source.acuity_n_type != 'PH' THEN ''	
 	   WHEN source.acuity_n_od ='/null/' OR source.acuity_n_od is null THEN '' 	
 	   end::text,
   'superpinhole_od', target.superpinhole_od, null),
('super_acuity_n_os', source.acuity_n_os, case
       when source.acuity_n_type = 'PH' AND source.acuity_n_os !='/null/' THEN source.acuity_n_os
 	   WHEN source.acuity_n_type != 'PH' THEN ''	
 	   WHEN source.acuity_n_os ='/null/' OR source.acuity_n_os is null THEN '' 		
 	   end::text,
   'superpinhole_os', target.superpinhole_os, null)				
					
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
