--select * from v_source_patients
--select * from v_migrated_patients1
--Select * from source_target_match WHERE  source_datasetId = 'patients';
--DELETE FROM source_target_match WHERE  source_datasetId = 'patients';


INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'patients' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_patients as source
FULL JOIN v_migrated_patients as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
  
 ('designation', source.designation, case
       when source.designation = 'Mr.' THEN 2
       when source.designation = 'Mrs.' THEN 3
       when source.designation = 'Ms.' THEN 5
       when source.designation = 'Miss' THEN 4
       when source.designation = 'Dr.' THEN 1
     end::text,
     'title', target.title, null),
('firstname',source.firstname,source.firstname,'firstName', target.firstName,null),
('lastname',source.lastname,source.lastname,'lastName', target.lastName,null),
('pat_id',source.pat_id,source.pat_id,'id', target.id,null),
('preferred_name',source.preferred_name,source.preferred_name,'nickName', target.nickName,null),
--(NULL, NULL, target.mrn, 'mrn', target.mrn, 'no MRN in E360'),
('mi',source.mi,source.mi,'mi ', target.mi,null),
('birthday', source.birthday::text, source.birthday::text, 'dob', target.dob::text, null),
--('null',source.null,source.null,'age ', target.age,null),
('sexs', source.sexs, case
       when source.sexs = 'F' THEN 1
       when source.sexs = 'M' THEN 2
       else NULL 
     end::text,
     'sex', target.sex::text, null),

--('ssn',source.ssn,source.ssn,'ssn ', target.ssn,null),
('ssn', source.ssn, '*****' || RIGHT(source.ssn,4), 'ssn', target.ssn, null),
('address',source.address,source.address,'address_addressLine1', target.address_addressLine1,null),
('city',source.city,source.city,'address_city ', target.address_city,null),
('state',source.state,source.state,'address_state ', target.address_state,null),
('zip',source.zip::text,source.zip::text,'address_zip ', target.address_zip,null),
('bad_address',source.bad_address::text,source.bad_address::text,'address_badAddress', target.address_badAddress,null),
('smoking_status', source.smoking_status, case
       when source.smoking_status = '449868002' THEN 1
       when source.smoking_status = '428041000124106' THEN 2
       else NULL 
     end::text,
     'smokingHistory_smokingStatus', target.smokingHistory_smokingStatus::text, null),
('no_call',source.no_call::text,source.no_call::text,'contactPrefrence ', target.contactPrefrence,null),
('preferred_language', source.preferred_language, case
 when source.preferred_language = 'English' THEN 7
 when source.preferred_language = 'Spanish' THEN 20
 when source.preferred_language = 'French (Canada)' THEN 8
 when source.preferred_language = 'French (France)' THEN 8
 when source.preferred_language = 'German' THEN 9
 when source.preferred_language = 'Chinese' THEN 4
 when source.preferred_language = 'Japanese' THEN 14
 when source.preferred_language = 'Italian' THEN 13
 when source.preferred_language = 'Portuguese' THEN 17
 when source.preferred_language = 'Declined' THEN 5
 when source.preferred_language = 'Russian' THEN 18
 when source.preferred_language = 'Korean' THEN 15
 when source.preferred_language = 'Arabic' THEN 2
 
else NULL 
 end::text,
 'contactInformation_language', target.contactInformation_language::text, null),					 
('preferred_contact',source.preferred_contact::text,source.preferred_contact::text,'contactInformation_preferred', target.contactInformation_preferred,null),
('preferred_phone',source.preferred_phone,source.preferred_phone,'contactInformation_phones_isPreferred', target.contactInformation_phones_isPreferred,null),
('bad_phone',source.bad_phone::text,source.bad_phone::text,'contactInformation_phones_isBad', target.contactInformation_phones_isBad,null),
('email',source.email,source.email,'contactInformation_emails_email', target.contactInformation_emails_email,null),
('bad_email',source.bad_email::text,source.bad_email::text,'contactInformation_emails_badEmail', target.contactInformation_emails_badEmail,null),
('no_email',source.no_email::text,source.no_email::text,'contactInformation_noEmail', target.contactInformation_noEmail,null),

('occupation', source.occupation, case
 when source.occupation = 'Unemployed' THEN 1
 when source.occupation = 'Employed' THEN 2
 when source.occupation = 'Student Part-Time'THEN 3
 when source.occupation = 'Student Full-Time'THEN 4
 else NULL 
 end::text,
 'patientDetails_occupation', target.patientDetails_occupation::text, null),
 
				
('married', source.married, case
       when source.married = 'null' THEN 10
       when source.married = 'unknown' THEN 10
 when source.married = 'Married' THEN 7
       when source.married = 'OTHER' THEN 10
  when source.married = 'SINGLE' THEN 9
       when source.married = 'Single' THEN 9
 when source.married = 'Other' THEN 10
       when source.married = 'Divorced' THEN 2
  when source.married = 'MARRIED' THEN 7
 
       else NULL 
     end::text,
     'patientDetails_maritalStatus', target.patientDetails_maritalStatus::text, null),
					
('maiden_name',source.maiden_name,source.maiden_name,'patientDetails_maidenName', target.patientDetails_maidenName,null),
('sexual_orientation',source.sexual_orientation,source.sexual_orientation,'patientDetails_sexualOrientation', target.patientDetails_sexualOrientation,null),
('gender_identity',source.gender_identity,source.gender_identity,'patientDetails_genderIdentities', target.patientDetails_genderIdentities,null),
('employer',source.employer,source.employer,'patientDetails_employer', target.patientDetails_employer,null),
('previous_firstname',source.previous_firstname,source.previous_firstname,'patientDetails_previousFirstName', target.patientDetails_previousFirstName,null),
('previous_lastname',source.previous_lastname,source.previous_lastname,'patientDetails_previousLastName', target.patientDetails_previousLastName,null),
('previous_mi',source.previous_mi,source.previous_mi,'patientDetails_previousMiddleName', target.patientDetails_previousMiddleName,null),
('race', source.race, case
       when source.race = 'American Indian or Alaskan Native' THEN 1
       when source.race = 'Asian' THEN 2
	   when source.race = 'Black or African American' THEN 3
       when source.race = 'Declined to specify' THEN 4
       when source.race = 'Native Hawaiian or Other Pacific Islander' THEN 5
       when source.race = 'Other Race' THEN 6
       when source.race = 'White' THEN 7 
       else NULL 
     end::text,
     'patientDetails_race', target.patientDetails_race::text, null),
					
('ethnicity', source.race, case
       when source.race = 'Declined to specify' THEN 1
 	   when source.race = 'Hispanic or Latino' THEN 2
       when source.race = 'Not Hispanic or Latino' THEN 3
       when source.race = 'Other' THEN 4
       when source.race = 'Unknown' THEN 5
 
					 else NULL 
     end::text,
   'patientDetails_ethnicity', target.patientDetails_ethnicity::text, null),
					
('new_pat',source.new_pat::text,source.new_pat::text,'patientDetails_isFlagNew', target.patientDetails_isFlagNew,null),
('collections',source.collections::text,source.collections::text,'patientDetails_isFlagInCollection', target.patientDetails_isFlagInCollection,null),
('bad_check',source.bad_check::text,source.bad_check::text,'patientDetails_isFlagBadCheck', target.patientDetails_isFlagBadCheck,null),
('deceased',source.deceased::text,source.deceased::text,'patientDetails_isFlagDeceased', target.patientDetails_isFlagDeceased,null),
('chartless',source.chartless::text,source.chartless::text,'patientDetails_isFlagChartless', target.patientDetails_isFlagChartless,null),
('notes',source.notes,source.notes,'notes_text', target.notes_text,null)
/*
('parent_firstname',source.parent_firstname ,source.parent_firstname ,'guarantor_firstName', target.guarantor_firstName,null),
('parent_lastname',source.parent_lastname ,source.parent_lastname ,'guarantor_lastName', target.guarantor_lastName,null),
('parent_birthday',source.parent_birthday,source.parent_birthday,'guarantor_dob', target.guarantor_dob,null),
('parent_married',source.parent_married,source.parent_married,'guarantor_maritalStatus', target.guarantor_maritalStatus,null),
('parent_mi',source.parent_mi,source.parent_mi,'guarantor_middleName', target.guarantor_middleName,null),
('parent',source.parent,source.parent,'guarantor_relationship', target.guarantor_relationship,null),
('parent_sex',source.parent_sex,source.parent_sex,'guarantor_sex', target.guarantor_sex,null),
('parent_ssn',source.parent_ssn,source.parent_ssn,'guarantor_ssn', target.guarantor_ssn,null),
('parent_designation',source.parent_designation,source.parent_designation,'guarantor_title', target.guarantor_title,null),
('parent_address',source.parent_address,source.parent_address,'guarantor_address_addressLine1', target.guarantor_address_addressLine1,null),
('parent_city',source.parent_city,source.parent_city,'guarantor_address_city', target.guarantor_address_city,null),
('parent_state',source.parent_state,source.parent_state,'guarantor_address_state', target.guarantor_address_state,null),
('parent_zip',source.parent_zip,source.parent_zip,'guarantor_address_zip', target.guarantor_address_zip,null),
('parent_email',source.parent_email,source.parent_email,'guarantor_contactInformation_emails0_email', target.guarantor_contactInformation_emails0_email,null),
('parent_homephone',source.parent_homephone,source.parent_homephone,'guarantor_contactInformation_phones0_number', target.guarantor_contactInformation_phones0_number,null),
('parent_workphone',source.parent_workphone,source.parent_workphone,'guarantor_contactInformation_phones1_number', target.guarantor_contactInformation_phones1_number,null),
('parent_cell',source.parent_cell,source.parent_cell,'guarantor_contactInformation_phones2_number', target.guarantor_contactInformation_phones2_number,null)					
*/
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
group by source_datasetId, source_field, target_field, matched, notes

select source_field, target_field, matched, notes, count(*)
from source_target_match
where  source_datasetId = 'patients' and target_id is not null
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched, notes

select source_id, target_id, source_field, source_value, expected_mapped_value, target_field, target_value,notes, matched
from source_target_match
where matched = false and source_datasetId = 'patients'and target_id is not null
order by source_fiel

select * from source_target_match where matched=false and target_field='dob'
select dob from v_migrated_patients where source_instanceid = '9E038C19F5C44FC3AD4E7890C43D645E' */