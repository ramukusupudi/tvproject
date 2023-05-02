Delete from source_target_match where source_datasetId='Employee';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'Employee' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_employees as source
FULL JOIN v_migrated_employees as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('designation',source.designation,case    
	when source.designation is null THEN 'Employee'
	when source.designation is not null THEN source.designation
	end::text,'designation', target.designation,null),
('firstname',source.firstname,source.firstname,'firstName', target.firstName,null),
('lastname',source.lastname,source.lastname,'lastName', target.lastName,null),
('employee_number',source.employee_number,case    
	when length(source.employee_number::text) >11 THEN LEFT(source.uid,11)
	when source.employee_number is null THEN LEFT(source.uid,11)
 	else source.employee_number
	end::text,'employeeNumber', target.employeeNumber,null),
('mi',source.mi,source.mi,'mi', target.mi,null),
('birthday',source.birthday::text,source.birthday::text,'dob', target.dob::text,null),
('email',source.email,TRIM(source.email),'email', target.email,null),
('sex', source.sex, case
	when source.sex = 'M' THEN 11
	when source.sex = 'F' THEN 12
	else NULL 
	end::text,'sex_key', target.sex_key::text, null),					
('available',source.available::text,source.available::text,'available', target.available,null),
('notes',source.notes,source.notes,'note', target.note,null),
('home_address',source.home_address,case
	when source.home_address is null THEN '14842 Manchester Rd'
	else source.home_address
	end::text,'addressLine1', target.addressLine1,null),
('home_city',source.home_city,case
	when source.home_city is null THEN 'Ballwin'
	else source.home_city
	end::text,'city', target.city,null),
('home_state',source.home_state,case
	when source.home_state is null THEN 'MO'
	else source.home_state
	end::text,'address_state', target.address_state,null),
('home_zip',source.home_zip::text,case
	when source.home_zip is null THEN '63011'
	else source.home_zip
	end::text,'zip', target.zip,null),
('homephone',source.homephone::text,source.homephone::text,'homePhone', target.homePhone,null),
('officephone',source.officephone::text,case
	when length(officephone::text)>10  THEN '1234567890'
 	when source.officephone is  null THEN null
	else source.officephone
	end::text,'workPhone', target.workPhone,null),
('cell',source.cell::text,source.cell::text,'cellPhone', target.cellPhone,null),					
('provider', source.provider, case
	when source.provider is null THEN false
	else true 
	end::text,'isProvider', target.isProvider::text, null),						

/*
('username', source.username, case
       when source.username is not null THEN true
 	   else false 
       end::text,'drfirstcredential', target.drfirstcredential::text, null),	*/	
					
('npi_number', source.npi_number::text, CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null AND source.npi_number is null THEN '1689670697'
 WHEN source.provider is not null AND source.npi_number is not null THEN source.npi_number::text
 end::text,'npi', target.npi::text, null),
('contact_eq',source.contact_eq,source.contact_eq,'contactEq', target.contactEq,null),	
('location_list',source.location_list,CASE
 	WHEN source.location_list IS NULL THEN '8EBBE1B453631CE542B11663626BB007'
	 WHEN source.location_list IS NOT NULL THEN SPLIT_PART(source.location_list,' ',1)
	 END,'office_id', target.office_source_instanceid,null),
('office_targetId',target.offices_id1,target.offices_id1,'target_office_id', target.office_target_id,null),					
--('location_list',source.location_list,SPLIT_PART(source.location_list,' ',2),'offices_id1', target.offices_id2,null),
('license_ids',source.license_ids::text,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN SPLIT_PART(source.license_ids::text,' ',1)::text
 end::text,'licenseid', target.provider_source_instanceid,null),
('provider_targetId',target.licenseid::text,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN target.licenseid::text
 end::text,'Provider_id', target.provider_target_id,null),					
('direct_address',source.direct_address,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN source.direct_address
 end::text,'directAddress', target.directAddress,null),	
('professional_eq',source.professional_eq,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN source.professional_eq
 end::text,'professionalEq', target.professionalEq,null),
('optical_eq',source.optical_eq,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN source.optical_eq
 end::text,'opticalEq', target.opticalEq,null),
('surgical_eq',source.surgical_eq,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN source.surgical_eq
 end::text,'surgicalEq', target.surgicalEq,null),
('on_line',source.on_line::text,CASE 
 WHEN source.provider is null OR source.on_line is null THEN false
 WHEN source.provider is not null AND source.on_line is not null THEN source.on_line
 end::text,'onlineProvider', target.onlineProvider,null),
('scope',source.scope,CASE 
 WHEN source.provider is null THEN null
 WHEN source.provider is not null THEN source.scope
 end::text,'license_state',target.license_state,null)
--('dea_ids',source.dea_ids::text,source.dea_ids::text,'dea', target.dea,null)

) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
