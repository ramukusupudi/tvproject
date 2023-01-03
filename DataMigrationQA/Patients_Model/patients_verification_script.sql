--Patients' Script
--select * from v_source_patients
--select race from patients
--select * from v_migrated_patients
--Select * from source_target_match WHERE  source_datasetId = 'patients';
--DELETE FROM source_target_match WHERE  source_datasetId = 'patients';
--SELECT table_schema, table_name, column_name, data_type 
--FROM INFORMATION_SCHEMA.COLUMNS 
--WHERE table_name = 'source_target_match_dummy' 

--select * from source_target_match_dummy
INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
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
('mi',source.mi,source.mi,'mi ', target.mi,null),
('birthday', source.birthday::text, source.birthday::text, 'dob', target.dob::text, null),
--('null',source.null,source.null,'age ', target.age,null),
('sexs', source.sexs, case
       when source.sexs = 'F' THEN '1'
       when source.sexs = 'M' THEN '2'
       else NULL 
     end::text,
     'sex', target.sex::text, null),
--ssn is blocked in mapping doc as it will work only on production.
--('ssn', source.ssn, '*****' || RIGHT(source.ssn,4), 'ssn', target.ssn, null),
('address',source.address,source.address,'address_addressLine1', target.address_addressLine1,null),
('city',source.city,source.city,'address_city ', target.address_city,null),
('state',source.state,source.state,'address_state ', target.address_state,null),
('zip',source.zip::text,source.zip::text,'address_zip ', target.address_zip,null),
('NS_address_ispreferred',null,'true','address_ispreferred', target.address_ispreferred,null),
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
					
/* ('prefs', source.prefs, case
             when source.prefs = 'workphone' THEN 1
             else NULL 
     end::text,
     'contactinformation_workphone_type', target.contactinformation_workphone_type, null), */
					
--homephone					
('homephone', source.homephone::text, source.homephone::text,'contactinformation_phones_phonenumber1', 
 case
 when source.homephone::text = target.contactinformation_phones_phonenumber1 THEN target.contactinformation_phones_phonenumber1
 when source.homephone::text = target.contactinformation_phones_phonenumber2 THEN target.contactinformation_phones_phonenumber2
 when source.homephone::text = target.contactinformation_phones_phonenumber3 THEN target.contactinformation_phones_phonenumber3
 
      													    else NULL 
    													    end::text,
          													 null),	
('bad_phone', source.bad_phone::text, case
       when source.bad_phone = 'true' AND source.homephone is not null then 'true'
      when source.bad_phone = 'false' AND source.homephone is not null then 'false'
     
       else NULL 
 end::text, case						 
 when target.contactinformation_phone_type1 = '1' THEN 'contactinformation_phone_isbad1'
 when target.contactinformation_phone_type2 = '1' THEN 'contactinformation_phone_isbad2'
 when target.contactinformation_phone_type3 = '1' THEN'contactinformation_phone_isbad3' 
 else 'contactinformation_phone_isbad1'
 end::text, 
										 case
										 when target.contactinformation_phone_type1 = '1' THEN target.contactinformation_phone_isbad1
										 when target.contactinformation_phone_type2 = '1' THEN target.contactinformation_phone_isbad2
										 when target.contactinformation_phone_type3 = '1' THEN target.contactinformation_phone_isbad3

																										else NULL 
																										end::text,
																										 null),					
--cell					
('cell', source.cell::text, source.cell::text,'contactinformation_phones_phonenumber3', 
 case
 when source.cell::text = target.contactinformation_phones_phonenumber1 THEN target.contactinformation_phones_phonenumber1
 when source.cell::text = target.contactinformation_phones_phonenumber2 THEN target.contactinformation_phones_phonenumber2
 when source.cell::text = target.contactinformation_phones_phonenumber3 THEN target.contactinformation_phones_phonenumber3
 
      													    else NULL 
    													    end::text,
          													 null),						
					
--workphone	
				
('NS_workphonetype', '', case
 when target.contactinformation_phone_type1 ='2' THEN '2'
 when target.contactinformation_phone_type2 = '2' THEN '2'
 when target.contactinformation_phone_type3 = '2' THEN '2'
 
      													    else NULL 
    													    end::text,'contactinformation_phone_type2', 
 case
 when target.contactinformation_phone_type1 ='2' THEN target.contactinformation_phone_type1
 when target.contactinformation_phone_type2 = '2' THEN target.contactinformation_phone_type2
 when target.contactinformation_phone_type3 = '2' THEN target.contactinformation_phone_type3
 
      													    else NULL 
    													    end::text,
          													 null),
			
('workphone', source.workphone::text, source.workphone::text,'contactinformation_phones_phonenumber2', 
 case
 when target.contactinformation_phone_type1 = '2' THEN target.contactinformation_phones_phonenumber1
 when target.contactinformation_phone_type2 = '2' THEN target.contactinformation_phones_phonenumber2
 when target.contactinformation_phone_type3 = '2' THEN target.contactinformation_phones_phonenumber3
 
      													    else NULL 
    													    end::text,
          													 null),	
('preferred_phone', source.preferred_phone::text, case
       when source.preferred_phone = 'workphone' THEN true
       else NULL 
     end::text,'contactinformation_phone_ispreferred2', 
											 case
											 when target.contactinformation_phone_type1 = '2' THEN target.contactinformation_phone_ispreferred1
											 when target.contactinformation_phone_type2 = '2' THEN target.contactinformation_phone_ispreferred2
											 when target.contactinformation_phone_type3 = '2' THEN target.contactinformation_phone_ispreferred3

																										else NULL 
																										end::text,
																										 null),	
('bad_phone', source.bad_phone::text, case
       when source.bad_phone = 'true' AND source.workphone is not null then 'true'
      when source.bad_phone = 'false' AND source.workphone is not null then 'false'
     
       else NULL 
     end::text,case						 
 when target.contactinformation_phone_type1 = '2' THEN 'contactinformation_phone_isbad1'
 when target.contactinformation_phone_type2 = '2' THEN 'contactinformation_phone_isbad2'
 when target.contactinformation_phone_type3 = '2' THEN'contactinformation_phone_isbad3' 
 else 'contactinformation_phone_isbad2'
 end::text,  
											 case
											 when target.contactinformation_phone_type1 = '2' THEN target.contactinformation_phone_isbad1
											 when target.contactinformation_phone_type2 = '2' THEN target.contactinformation_phone_isbad2
											 when target.contactinformation_phone_type3 = '2' THEN target.contactinformation_phone_isbad3

																										else NULL 
																										end::text,
																										 null),					


('contactInformation_emails_type',NULL,'5','contactInformation_emails_type', target.contactInformation_emails_type,null),
('email',source.email,source.email,'contactInformation_emails_email', target.contactInformation_emails_email,null),
('contactInformation_emails_isPreferred',NULL,'true','contactInformation_emails_isPreferred', target.contactInformation_emails_isPreferred,null),
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
('sexual_orientation', source.sexual_orientation, case
       when source.sexual_orientation = '1' THEN 4
       when source.sexual_orientation = '2' THEN 6
	   when source.sexual_orientation = '3' THEN 1
       when source.sexual_orientation = '4' THEN 5
       when source.sexual_orientation = '5' THEN 3
       when source.sexual_orientation = '6' THEN 2
       else null 
     end::text,
     'patientDetails_sexualOrientation', target.patientDetails_sexualOrientation::text, null),
('gender_identity', source.gender_identity, case
       when source.gender_identity = '1' THEN 6
       when source.gender_identity = '2' THEN 3
	   when source.gender_identity = '3' THEN 4
       when source.gender_identity = '4' THEN 7
       when source.gender_identity = '5' THEN 5
       when source.gender_identity = '6' THEN 1
       when source.gender_identity = '7' THEN 2 
       else null 
     end::text,
     'patientDetails_genderIdentities', target.patientDetails_genderIdentities::text, null),
('employer',source.employer,source.employer,'patientDetails_employer', target.patientDetails_employer,null),
('previous_firstname',source.previous_firstname,source.previous_firstname,'patientDetails_previousFirstName', target.patientDetails_previousFirstName,null),
('previous_lastname',source.previous_lastname,source.previous_lastname,'patientDetails_previousLastName', target.patientDetails_previousLastName,null),
('previous_mi',source.previous_mi,source.previous_mi,'patientDetails_previousMiddleName', target.patientDetails_previousMiddleName,null),
('race', source.race, case
       when source.race = 'American Indian or Alaskan Native' THEN 1
       when source.race = 'Asian' THEN 2
	   when source.race = 'Black or African American' THEN 3
       when source.race = 'Declined to specify' THEN 4
       when source.race = 'Declined' THEN 4
       when source.race = 'Native Hawaiian or Other Pacific Islander' THEN 5
       when source.race = 'Other Race' THEN 6
       when source.race = 'White' THEN 7 
      
     end::text,
     'patientDetails_race', target.patientDetails_race::text, null),
					
('ethnicity', source.ethnicity, case
       when source.ethnicity = 'Declined to specify' THEN 1
       when source.ethnicity = 'Declined' THEN 1
 	   when source.ethnicity = 'Hispanic or Latino' THEN 2
       when source.ethnicity = 'Not Hispanic or Latino' THEN 3
       when source.ethnicity = 'Other' THEN 4
       when source.ethnicity = 'Unknown' THEN 5
 				  
     end::text,
   'patientDetails_ethnicity', target.patientDetails_ethnicity::text, null),
					
('new_pat',source.new_pat::text,source.new_pat::text,'patientDetails_isFlagNew', target.patientDetails_isFlagNew,null),
('collections',source.collections::text,source.collections::text,'patientDetails_isFlagInCollection', target.patientDetails_isFlagInCollection,null),
('bad_check',source.bad_check::text,source.bad_check::text,'patientDetails_isFlagBadCheck', target.patientDetails_isFlagBadCheck,null),
('deceased',source.deceased::text,source.deceased::text,'patientDetails_isFlagDeceased', target.patientDetails_isFlagDeceased,null),
('chartless',source.chartless::text,source.chartless::text,'patientDetails_isFlagChartless', target.patientDetails_isFlagChartless,null),
('notes',source.notes,source.notes,'notes_text', target.notes_text,null),
('guar_firstname', source.guar_firstname, case
       when source.guar_firstname is null THEN source.firstname
 		else source.guar_firstname
	    end::text,
     'guarantor_firstName', target.guarantor_firstName, null),
('guar_lastname', source.guar_lastname, case
       when source.guar_lastname is null THEN source.lastname
 		else source.guar_lastname
	    end::text,
     'guarantor_lastName', target.guarantor_lastName, null),
('guar_birthday', source.guar_birthday::text, case
       when source.guar_birthday is null THEN source.birthday
 		else source.guar_birthday
	    end::text,
     'guarantor_dob', target.guarantor_dob::text, null),
('guar_married', source.guar_married, case
       when source.guar_married = 'null' THEN 10
       when source.guar_married = 'unknown' THEN 10
 when source.guar_married = 'Married' THEN 7
       when source.guar_married = 'OTHER' THEN 10
  when source.guar_married = 'SINGLE' THEN 9
       when source.guar_married = 'Single' THEN 9
 when source.guar_married = 'Other' THEN 10
       when source.guar_married = 'Divorced' THEN 2
  when source.guar_married = 'MARRIED' THEN 7
 
       else NULL 
     end::text,
'guarantor_maritalStatus', target.guarantor_maritalStatus::text, null),

('guar_mi',source.guar_mi,source.guar_mi,'guarantor_middleName', target.guarantor_middleName,null),
--guarantor_relationship is blocked in mapping doc
/*
('subscriber_relationship', source.parent, case
       when source.subscriber_relationship = 'Self' THEN 1
       when source.subscriber_relationship = 'Son' THEN 2
       when source.subscriber_relationship = 'Mother' THEN 3
       when source.subscriber_relationship = 'Father' THEN 4
       when source.subscriber_relationship = 'Spouse' THEN 5 
       else NULL 
     end::text,
     'guarantor_relationship', target.guarantor_relationship::text, null),
					*/

('guarantor_releaseHippaInfo',null,'true','guarantor_releaseHippaInfo', target.guarantor_releaseHippaInfo,null),
('guar_sex', source.guar_sex, case
       when source.guar_sex = 'F' THEN 1
       when source.guar_sex = 'M' THEN 2
       else NULL 
     end::text,
     'guarantor_sex', target.guarantor_sex::text, null),
--guar_ssn is blocked, this will work only in production due to data privacy 					
--('guar_ssn', source.guar_ssn, '*****' || RIGHT(source.guar_ssn,4), 'guarantor_ssn', target.guarantor_ssn, null),
('guar_designation', source.guar_designation, case
       when source.guar_designation = 'Mr.' THEN 2
       when source.guar_designation = 'Mrs.' THEN 3
       when source.guar_designation = 'Ms.' THEN 5
       when source.guar_designation = 'Miss' THEN 4
       when source.guar_designation = 'Dr.' THEN 1
     end::text,
     'guarantor_title', target.guarantor_title, null),
('guar_address', source.guar_address, case
       when source.guar_address is null THEN source.address
 		else source.guar_address
	    end::text,
     'guarantor_address_addressLine1', target.guarantor_address_addressLine1, null),
('guar_city', source.guar_city, case
       when source.guar_city is null THEN source.city
 		else source.guar_city
	    end::text,
     'guarantor_address_city', target.guarantor_address_city, null),					
('guar_state', source.guar_state, case
       when source.guar_state is null THEN source.state
 		else source.guar_state
	    end::text,
     'guarantor_address_state', target.guarantor_address_state, null),	
('guar_zip', source.guar_zip::text, case
       when source.guar_zip is null THEN source.zip
 		else source.guar_zip
	    end::text,
     'guarantor_address_zip', target.guarantor_address_zip, null),	
('guar_email', source.guar_email, case
       when source.guar_email is null THEN source.email
 		else source.guar_email
	    end::text,
     'guarantor_contactinformation_email', target.guarantor_contactinformation_email, null),	
					
('guar_homephone', source.guar_homephone::text, case
       when source.guar_homephone is null THEN source.homephone
 		else source.guar_homephone
	    end::text,
     'guarantor_contactinformation_phone_number1', case
 when source.guar_homephone::text  = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.guar_homephone::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.guar_homephone::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
 when source.homephone::text  = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.homephone::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.homephone::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
 
      													    else NULL 
    													    end::text, null),	
					
('guar_workphone', source.guar_workphone::text, case
       when source.guar_workphone is null THEN source.workphone
 		else source.guar_workphone
	    end::text,
     'guarantor_contactinformation_phone_number2',  case
 when source.guar_workphone::text = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.guar_workphone::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.guar_workphone::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
  when source.workphone::text = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.workphone::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.workphone::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
 
      													    else NULL 
    													    end::text, null), 	
('guar_cell', source.guar_cell::text, case
       when source.guar_cell is null THEN source.cell
 		else source.guar_cell
	    end::text,
     'guarantor_contactinformation_phone_number3', case
 when source.guar_cell::text = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.guar_cell::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.guar_cell::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
 when source.cell::text = target.guarantor_contactinformation_phone_number1 THEN target.guarantor_contactinformation_phone_number1
 when source.cell::text = target.guarantor_contactinformation_phone_number2 THEN target.guarantor_contactinformation_phone_number2
 when source.cell::text = target.guarantor_contactinformation_phone_number3 THEN target.guarantor_contactinformation_phone_number3
 
      													    else NULL 
    													    end::text, null)
--guarantor.contactInformation.preferredContactMethod is pending as it required more clarification					
					
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
order by source_field

select * from source_target_match where matched=false and target_field='dob'
select dob from v_migrated_patients where source_instanceid = '9E038C19F5C44FC3AD4E7890C43D645E' */