--Select count(*) from source_target_match WHERE  source_datasetId = 'employee';
--DELETE FROM source_target_match WHERE  source_datasetId = 'employee';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'employee' as source_datasetId,
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
('sex', source.sex, case
       when source.sex = 'M' THEN 11
 	   when source.sex = 'F' THEN 12
       else NULL 
     end::text,
   'sex_key', target.sex_key::text, null),					
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
       when source.officephone is null OR length(officephone::text)>10  THEN '1234567890'
      else source.officephone
     end::text,'workPhone', target.workPhone,null),
('cell',source.cell::text,source.cell::text,'cellPhone', target.cellPhone,null),					
--('provider',source.provider,source.provider,'isProvider', target.isProvider,null),
('provider', source.provider, case
       when source.provider is null THEN false
 	   else true 
     end::text,
   'isProvider', target.isProvider::text, null),						

/*
('username', source.username, case
       when source.username is not null THEN true
 	   else false 
       end::text,
   'drfirstcredential', target.drfirstcredential::text, null),	*/	
					
('npi_number', source.npi_number::text, case
       when source.npi_number is null THEN '1689670697'
       else source.npi_number::text
 	   end::text,
   'npi', target.npi::text, null),
('contact_eq',source.contact_eq,source.contact_eq,'contactEq', target.contactEq,null),	
--('location_list',source.location_list,SPLIT_PART(source.location_list,' ',1),'offices_id1', target.offices_id1,null),
--('location_list',source.location_list,SPLIT_PART(source.location_list,' ',2),'offices_id1', target.offices_id2,null),
('license_ids',source.license_ids::text,source.license_ids::text,'licenseid', target.licenseid,null),
('direct_address',source.direct_address,source.direct_address,'directAddress', target.directAddress,null),	
('professional_eq',source.professional_eq,source.professional_eq,'professionalEq', target.professionalEq,null),
('optical_eq',source.optical_eq,source.optical_eq,'opticalEq', target.opticalEq,null),
('surgical_eq',source.surgical_eq,source.surgical_eq,'surgicalEq', target.surgicalEq,null),
('on_line',source.on_line::text,source.on_line::text,'onlineProvider', target.onlineProvider,null),

('scope',source.scope,source.scope,'license_state', target.license_state,null)
--('dea_ids',source.dea_ids::text,source.dea_ids::text,'dea', target.dea,null)
					



) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
