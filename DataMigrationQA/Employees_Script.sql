 --select * from v_source_employees
--select * from v_migrated_employees
--Select * from source_target_match WHERE  source_datasetId = 'employees';
--DELETE FROM source_target_match WHERE  source_datasetId = 'employees';


INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'employees' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_employees as source
FULL JOIN v_migrated_employees as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('designation',source.designation,source.designation,'designation', target.designation,null),
('firstname',source.firstname,source.firstname,'firstName', target.firstName,null),
('lastname',source.lastname,source.lastname,'lastName', target.lastName,null),
('employee_number',source.employee_number,source.employee_number,'employeeNumber', target.employeeNumber,null),
('mi',source.mi,source.mi,'mi', target.mi,null),
('birthday',source.birthday::text,source.birthday::text,'dob', target.dob::text,null),
('email',source.email,source.email,'email', target.email,null),
('sexs', source.sexs, case
       when source.sexs = 'M' THEN 11
 	   when source.sexs = 'F' THEN 12
       else NULL 
     end::text,
   'sex_key', target.sex_key::text, null),					
('available',source.available::text,source.available::text,'available', target.available,null),
('notes',source.notes,source.notes,'note', target.note,null),
('home_address',source.home_address,source.home_address,'addressLine1', target.addressLine1,null),
('home_city',source.home_city,source.home_city,'city', target.city,null),
('home_state',source.home_state,source.home_state,'address_state', target.address_state,null),
('home_zip',source.home_zip::text,source.home_zip::text,'zip', target.zip,null),
('homephone',source.homephone::text,source.homephone::text,'homePhone', target.homePhone,null),
('officephone',source.officephone::text,source.officephone::text,'workPhone', target.workPhone,null),
('cell',source.cell::text,source.cell::text,'cellPhone', target.cellPhone,null),
--('provider',source.provider,source.provider,'isProvider', target.isProvider,null),
('provider', source.provider, case
       when source.provider is null THEN false
 	   else true 
     end::text,
   'isProvider', target.isProvider::text, null)						

--one field is expecting here as per mapping doc
/*					
('npi_number', source.npi_number::text, case
       when source.npi_number is null THEN '1689670697'
       else source.npi_number::text
 	   end::text,
   'npi', target.npi::text, null),
('contact_eq',source.contact_eq,source.contact_eq,'contactEq', target.contactEq,null),	
('location_list',source.location_list,source.location_list,'offices_id1', target.offices_id1,null),
	
('license_ids',source.license_ids::text,source.license_ids::text,'licenseid', target.licenseid,null),
('direct_address',source.direct_address,source.direct_address,'directAddress', target.directAddress,null),	
('professional_eq',source.professional_eq,source.professional_eq,'professionalEq', target.professionalEq,null),
					('optical_eq',source.optical_eq,source.optical_eq,'opticalEq', target.opticalEq,null),
('surgical_eq',source.surgical_eq,source.surgical_eq,'surgicalEq', target.surgicalEq,null),

('on_line',source.on_line::text,source.on_line::text,'onlineProvider', target.onlineProvider,null),

('scope',source.scope,source.scope,'license_state', target.license_state,null),
('dea_ids',source.dea_ids::text,source.dea_ids::text,'dea', target.dea,null),
*/					



) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
/*
select Distinct source_id, target_id from source_target_match where target_id is null

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
group by source_datasetId, source_field, target_field, matched, notes

select source_field, target_field, matched, notes, count(*)
from source_target_match
where  source_datasetId = 'employees' and target_id is not null
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched, notes

select source_id, target_id, source_field, source_value, expected_mapped_value, target_field, target_value,notes, matched
from source_target_match
where matched = false and source_datasetId = 'employees'and target_id is not null
order by source_field

select * from source_target_match where matched=false and target_field='dob'
select dob from v_migrated_patients where source_instanceid = '9E038C19F5C44FC3AD4E7890C43D645E' */					