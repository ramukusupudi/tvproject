
--select * from v_source_visionacuity
--select * from v_migrated_visionacuity
--Select * from source_target_match WHERE  source_datasetId = 'va';
--DELETE FROM source_target_match WHERE  source_datasetId = 'va';


INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'va' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_visionacuity as source
FULL JOIN v_migrated_visionacuity as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES

('patient',source.patient,source.patient,'patient_id', target.patient_id,null),
('date',source.date,source.date,'appointmentDate', target.appointmentDate,null),
--('acuity_n_od',source.acuity_n_od,source.acuity_n_od,'near_OD_value1', target.near_OD_value1,null),
('acuity_n_type', source.acuity_n_type, case
       when source.acuity_n_type <> 'N' or 'PH' THEN null
 	   end::text,
   'near_OD_value1', null, null),
--('acuity_n_os',source.acuity_n_os,source.acuity_n_os,'near_OS_value1', target.near_OS_value1,null),
('acuity_n_type', source.acuity_n_type, case
       when source.acuity_n_type <> 'N' or 'PH' THEN null
 	   end::text,
   'near_OS_value1', null, null),
--('acuity_n_ou',source.acuity_n_ou,source.acuity_n_ou,'near_OU_value1', target.near_OU_value1,null),
('acuity_n_type', source.acuity_n_type, case
       when source.acuity_n_type <> 'N' or 'PH' THEN null
 	   end::text,
   'near_OU_value1', null, null),
('null',"Snellen","Snellen",'near_value', target.near_value,null),
('acuity_d_od',source.acuity_d_od,source.acuity_d_od,'distance_OD_value1', target.distance_OD_value1,null),
('acuity_d_os',source.acuity_d_os,source.acuity_d_os,'distance_OS_value1', target.distance_OS_value1,null),
('acuity_d_ou',source.acuity_d_ou,source.acuity_d_ou,'distance_OU_value1', target.distance_OU_value1,null),
('null',"Snellen","Snellen",'distance_value', target.distance_value,null),
--('acuity_n_od',source.acuity_n_od,source.acuity_n_od,'superPinhole_OD', target.superPinhole_OD,null),
('acuity_n_type', source.acuity_n_type, case
       when source.acuity_n_type <> 'N' or 'PH' THEN null
 	   end::text,
   'superPinhole_OD', null, null),
--('acuity_n_os',source.acuity_n_os,source.acuity_n_os,'superPinhole_OS', target.superPinhole_OS,null),
('acuity_n_type', source.acuity_n_type, case
       when source.acuity_n_type <> 'N' or 'PH' THEN null
 	   end::text,
   'superPinhole_OS', null, null),				
					
as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
group by source_datasetId, source_field, target_field, matched, notes

select source_field, target_field, matched, notes, count(*)
from source_target_match
where  source_datasetId = 'va' and target_id is not null
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched, notes

select source_id, target_id, source_field, source_value, expected_mapped_value, target_field, target_value,notes, matched
from source_target_match
where matched = false and source_datasetId = 'va'and target_id is not null
order by source_fiel

select * from source_target_match where matched=false and target_field='dob'
*/