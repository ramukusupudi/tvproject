Delete from source_target_match where source_datasetId= 'Patients';


INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'Patients' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_patients as source
FULL JOIN v_migrated_patients as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
  
('designation', source.designation, CASE
	when source.designation = 'Mr.' THEN 2
	when source.designation = 'Mrs.' THEN 3
	when source.designation = 'Ms.' THEN 5
	when source.designation = 'Miss' THEN 4
	when source.designation = 'Dr.' THEN 1
	end::text,'title', target.title, null),
('firstname',source.firstname,source.firstname,'firstName', target.firstName,null),
('lastname',source.lastname,source.lastname,'lastName', target.lastName,null),
('preferred_name',source.preferred_name,source.preferred_name,'nickName', target.nickName,null),
('mi',source.mi,source.mi,'mi ', target.mi,null),
('birthday', source.birthday::text, case
	when source.birthday < current_date THEN source.birthday::text 
	else '1700-01-01'
	end::text, 'dob', target.dob::text, null),
--('NS_age',(source.birthday::date)::text,EXTRACT(year FROM age('2023-02-25'::date,birthday::date))::text,'age', target.age,null),
('sex', source.sex, case
	when source.sex = 'F' THEN '1'
	when source.sex = 'M' THEN '2'
	when source.sex = 'UNK' THEN '3'
	else '3' 
	end::text,
	'sex', target.sex::text, null),
('ssn', source.ssn, CASE 
	 WHEN source.ssn IS NULL THEN NULL
	 WHEN source.ssn IS NOT NULL THEN '*****' || RIGHT('000000000',4)
	 END,'ssn', target.ssn, null),					
('NS_addresstype','','1','address_type', target.address_type,null),					
('address',source.address,source.address,'address_addressLine1', target.address_addressLine1,null),
('city',source.city,source.city,'address_city ', target.address_city,null),
('state',source.state,source.state,'address_state ', target.address_state,null),
('zip',source.zip::text,case
	when length(source.zip::text) < 5 THEN LPAD(source.zip::text::text, 5, '0')
    when length(source.zip::text) > 5 AND length(source.zip::text) < 9 THEN LPAD(source.zip::text::text, 9, '0')
    when length(source.zip::text) > 9 THEN substring(source.zip::text, '^\d{1,5}')
	when length(source.zip::text) = 5 OR length(source.zip::text) = 9  THEN source.zip::text
	when source.zip::text IS NULL THEN '00000'
 	end::text,'address_zip ', target.address_zip,null),
('NS_address_ispreferred',null,'true','address_ispreferred', target.address_ispreferred,null),
('bad_address',source.bad_address::text,source.bad_address::text,'address_badAddress', target.address_badAddress,null),
('smoking_status', source.smoking_status, case
	when source.smoking_status = '449868002' THEN 1
	when source.smoking_status = '428041000124106' THEN 2
	else NULL 
	end::text,'smokingHistory_smokingStatus', target.smokingHistory_smokingStatus::text, null),
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
	end::text,'contactInformation_language', target.contactInformation_language::text, null),
('prefs_text', source.prefs::text, case
	when  source.no_call::text='false' AND (0= any(source.prefs))::text = 'true' THEN true
	else false 
	end::text,'contact_text', target.contact_text, null), 
('prefs_phone', source.prefs::text, case
	when  source.no_call::text='false' AND (1= any(source.prefs))::text= 'true' THEN true
	else false 
	end::text,'contact_phone', target.contact_phone, null), 
('prefs_email', source.prefs::text, case
	when  source.no_call::text='false' AND (2= any(source.prefs))::text='true' THEN true
	else false 
	end::text,'contact_email', target.contact_email, null), 
/*					
('guar_prefs_text', source.guar_prefs::text, case
	when  source.parent is not null AND source.no_call::text='false' AND (0= any(source.guar_prefs))::text = 'true' THEN true
 	when  source.parent is not null AND source.no_call::text='false' AND (0= any(source.guar_prefs))::text != 'true' THEN false
 	when  source.parent is null AND source.no_call::text='false' AND (0= any(source.prefs))::text = 'true' THEN true
	when  source.parent is null AND source.no_call::text='false' AND source.prefs::text IS NULL THEN false				
	end::text,'guar_contact_text', target.guar_contact_text, null), 
('guar_prefs_phone', source.guar_prefs::text, case
	when  source.parent is not null AND source.no_call::text='false' AND (1= any(source.guar_prefs))::text= 'true' THEN true
 	when  source.parent is not null AND source.no_call::text='false' AND (1= any(source.prefs))::text != 'true' THEN false
 	when  source.parent is null AND source.no_call::text='false' AND (1= any(source.prefs))::text = 'true' THEN true
	when  source.parent is null AND source.no_call::text='false' AND source.prefs::text IS NULL THEN false	
	end::text,'guar_contact_phone', target.guar_contact_phone, null), 
('guar_prefs_email', source.guar_prefs::text, case
    when source.parent is not null AND source.no_call::text='false' AND (2= any(source.guar_prefs))::text='true' THEN true
 	when source.parent is not null AND source.no_call::text='false' AND (2= any(source.prefs))::text != 'true' THEN false
    when  source.parent is null AND source.no_call::text='false' AND (2= any(source.prefs))::text = 'true' THEN true
	when  source.parent is null AND source.no_call::text='false' AND source.prefs::text IS NULL THEN false	
 	end::text,'guar_contact_email', target.guar_contact_email, null),  
					*/
('NS_homephonetype', '',case
	when source.homephone::text is not null THEN '1'
 	when source.homephone::text is null THEN null
 	end::text, 'homephonetype', case
	when target.phone_type1::text = '1' THEN target.phone_type1
	when target.phone_type2::text = '1' THEN target.phone_type2
	when target.phone_type3::text = '1' THEN target.phone_type3
	end::text,null),
('NS_celltype', '',case
	when source.cell::text is not null THEN '3'
 	when source.cell::text is null THEN null
 	end::text, 'cellphonetype', case
		when target.phone_type1::text = '3' THEN target.phone_type1
		when target.phone_type2::text = '3' THEN target.phone_type2
		when target.phone_type3::text = '3' THEN target.phone_type3
		end::text,null),
('NS_workphonetype', '',case
	when source.workphone::text is not null THEN '2'
 	when source.workphone::text is null THEN null
 	end::text, 'workphonetype', case
		when target.phone_type1::text = '2' THEN target.phone_type1
		when target.phone_type2::text = '2' THEN target.phone_type2
		when target.phone_type3::text = '2' THEN target.phone_type3
		end::text,null),			
('homephone', source.homephone::text,source.homephone::text, 'homephone',case
	when target.phone_type1::text = '1' THEN target.phonenumber1
	when target.phone_type2::text = '1' THEN target.phonenumber2
	when target.phone_type3::text = '1' THEN target.phonenumber3
	end::text,null),
('bad_phone_homephone', source.bad_phone::text, case
	when source.bad_phone = 'true' AND source.homephone is not null then 'true'
	when source.bad_phone = 'false' AND source.homephone is not null then 'false'
	when source.homephone is null THEN null 
 	end::text, 'phone_isbad1', case
		when target.phone_type1 = '1' THEN target.phone_isbad1
		when target.phone_type2 = '1' THEN target.phone_isbad2
		when target.phone_type3 = '1' THEN target.phone_isbad3
		else NULL 
		end::text,null),					
('cell', source.cell::text, source.cell::text, 'cell', 
	case
	when target.phone_type1::text = '3' THEN target.phonenumber1
	when target.phone_type2::text = '3' THEN target.phonenumber2
	when target.phone_type3::text = '3' THEN target.phonenumber3
	end::text,null),
('bad_phone_cell', source.bad_phone::text, case
	when source.bad_phone = 'true' AND source.cell is not null then 'true'
	when source.bad_phone = 'false' AND source.cell is not null then 'false'
	when source.cell is null THEN null 
 	end::text,'cellphone_isbad',case
		when target.phone_type1 = '3' THEN target.phone_isbad1
		when target.phone_type2 = '3' THEN target.phone_isbad2
		when target.phone_type3 = '3' THEN target.phone_isbad3
		else NULL 
		end::text,null),	
('workphone', source.workphone::text, source.workphone::text,'workphone',case
	 when target.phone_type1::text = '2' THEN target.phonenumber1
	 when target.phone_type2::text = '2' THEN target.phonenumber2
	 when target.phone_type3::text = '2' THEN target.phonenumber3
	 end::text,null),
('preferred_homephone', source.preferred_phone::text,case
	when source.preferred_phone = 'homephone' THEN true
	when (source.preferred_phone != 'homephone' OR source.preferred_phone is null) AND source.homephone is not null THEN false
 	when source.homephone is null THEN null
	end::text ,'homephone_ispreferred',case
		when  target.phone_type1::text = '1' THEN target.phone_ispreferred1
		when target.phone_type2::text = '1' THEN target.phone_ispreferred2
		when target.phone_type3::text = '1' THEN target.phone_ispreferred3
		else null
		end::text,null),
('preferred_cell', source.preferred_phone::text,case
	when source.preferred_phone = 'cell' THEN true
 	when (source.preferred_phone != 'cell' OR source.preferred_phone is null) AND source.cell is not null THEN false
 	when source.cell is null THEN null
	end::text ,'cellphone_ispreferred',case
		when  target.phone_type1::text = '3' THEN target.phone_ispreferred1
		when target.phone_type2::text = '3' THEN target.phone_ispreferred2
		when target.phone_type3::text = '3' THEN target.phone_ispreferred3
		else null
		end::text,null),
('preferred_workphone', source.preferred_phone::text,case
	when source.preferred_phone = 'workphone' THEN true
	when (source.preferred_phone != 'workphone' OR source.preferred_phone is null) AND source.workphone is not null THEN false
 	when source.workphone is null THEN null 
 	end::text ,'workphone_ispreferred',case
		when  target.phone_type1::text = '2' THEN target.phone_ispreferred1
		when target.phone_type2::text = '2' THEN target.phone_ispreferred2
		when target.phone_type3::text = '2' THEN target.phone_ispreferred3
		else null
		end::text,null),					
('bad_phone_workphone', source.bad_phone::text, case
	when source.bad_phone = 'true' AND source.workphone is not null then 'true'
	when source.bad_phone = 'false' AND source.workphone is not null then 'false'
	when source.workphone is null THEN null
	end::text,'workphone_isbad',case
		when target.phone_type1 = '2' THEN target.phone_isbad1
		when target.phone_type2 = '2' THEN target.phone_isbad2
		when target.phone_type3 = '2' THEN target.phone_isbad3
		else NULL 
		end::text,null),					
('NS_contactInformation_email_type','',CASE
 	 WHEN source.email='' or source.email IS NULL THEN NULL
	 ELSE '5'
	 end,'contactInformation_email_type', target.email_type,null),
('email',source.email,source.email,'email', target.email,null),
('NS_contactInformation_emails_isPreferred',NULL,CASE
 WHEN source.email IS NULL THEN NULL
 ELSE 'true'
 END,'email_isPreferred', target.email_isPreferred,null),
('bad_email',source.bad_email::text,CASE 
	 WHEN source.email IS NOT NULL THEN  source.bad_email::text
	 ELSE NULL
	 END,'badEmail', target.badEmail,null),
('no_email',source.no_email::text,Case 
	when target.email is null or target.email ='' THEN 'true'
	else source.no_email
	end::text,'noEmail', target.noEmail,null),
('occupation', source.occupation, case
	 when source.occupation = 'Unemployed' THEN 1
	 when source.occupation = 'Employed' THEN 2
	 when source.occupation = 'Student Part-Time'THEN 3
	 when source.occupation = 'Student Full-Time'THEN 4
	 else NULL 
	 end::text,'patientDetails_occupation', target.patientDetails_occupation::text, null),
('married', source.married, case
	when source.married is null THEN 10
	when source.married = 'unknown' THEN 10
	when source.married = 'Married' THEN 7
	when source.married = 'OTHER' THEN 10
	when source.married = 'SINGLE' THEN 9
	when source.married = 'Single' THEN 9
	when source.married = 'Other' THEN 10
	when source.married = 'Divorced' THEN 2
	when source.married = 'MARRIED' THEN 7
	end::text,'patientDetails_maritalStatus', target.patientDetails_maritalStatus::text, null),
('maiden_name',source.maiden_name,source.maiden_name,'patientDetails_maidenName', target.patientDetails_maidenName,null),
('sexual_orientation', source.sexual_orientation, case
       when source.sexual_orientation = '1' THEN 4
       when source.sexual_orientation = '2' THEN 6
	   when source.sexual_orientation = '3' THEN 1
       when source.sexual_orientation = '4' THEN 5
       when source.sexual_orientation = '5' THEN 3
       when source.sexual_orientation = '6' THEN 2
       else null 
       end::text,'patientDetails_sexualOrientation', target.patientDetails_sexualOrientation::text, null),
('gender_identity', source.gender_identity, case
       when source.gender_identity = '1' THEN 6
       when source.gender_identity = '2' THEN 3
	   when source.gender_identity = '3' THEN 4
       when source.gender_identity = '4' THEN 7
       when source.gender_identity = '5' THEN 5
       when source.gender_identity = '6' THEN 1
       when source.gender_identity = '7' THEN 2 
       else null 
     end::text,'patientDetails_genderIdentities', target.patientDetails_genderIdentities::text, null),
('employer',source.employer,source.employer,'patientDetails_employer', target.patientDetails_employer,null),
('previous_firstname',source.previous_firstname,source.previous_firstname,'patientDetails_previousFirstName', target.patientDetails_previousFirstName,null),
('previous_lastname',source.previous_lastname,source.previous_lastname,'patientDetails_previousLastName', target.patientDetails_previousLastName,null),
('previous_mi',source.previous_mi,source.previous_mi,'patientDetails_previousMiddleName', target.patientDetails_previousMiddleName,null),
('race1', source.race, case
	when SPLIT_PART(source.race,',',1) = 'American Indian or Alaska Native' THEN 1
	when SPLIT_PART(source.race,',',1) = 'Asian' THEN 2
	when SPLIT_PART(source.race,',',1) = 'Black or African American' THEN 3
	when SPLIT_PART(source.race,',',1) = 'Declined to specify' THEN 4
	when SPLIT_PART(source.race,',',1) = 'Declined' THEN 4
	when SPLIT_PART(source.race,',',1) = 'Native Hawaiian or Other Pacific Islander' THEN 5
	when SPLIT_PART(source.race,',',1) = 'Other Race' THEN 6
	when SPLIT_PART(source.race,',',1) = 'White' THEN 7 
	when SPLIT_PART(source.race,',',1) = 'Unable to collect' THEN 883
	when SPLIT_PART(source.race,',',1) is null THEN null
	when SPLIT_PART(source.race,',',1) = '' THEN null
	else 883
	end::text,'patientDetails_race_1', target.patientDetails_race_1::text, null),
('race2', SPLIT_PART(source.race,',',2), case
	when SPLIT_PART(source.race,',',2) = 'American Indian or Alaska Native' THEN 1
	when SPLIT_PART(source.race,',',2) = 'Asian' THEN 2
	when SPLIT_PART(source.race,',',2) = 'Black or African American' THEN 3
	when SPLIT_PART(source.race,',',2) = 'Declined to specify' THEN 4
	when SPLIT_PART(source.race,',',2) = 'Declined' THEN 4
	when SPLIT_PART(source.race,',',2) = 'Native Hawaiian or Other Pacific Islander' THEN 5
	when SPLIT_PART(source.race,',',2) = 'Other Race' THEN 6
	when SPLIT_PART(source.race,',',2) = 'White' THEN 7 
 	when SPLIT_PART(source.race,',',1) = 'Unable to collect' THEN 883
	when SPLIT_PART(source.race,',',2) is null THEN null
	when SPLIT_PART(source.race,',',2) = '' THEN null
	else 883
	end::text,'patientDetails_race_2', target.patientDetails_race_2::text, null),					
('ethnicity1', SPLIT_PART(source.ethnicity,',',1), case
	when SPLIT_PART(source.ethnicity,',',1) = 'Declined to specify' THEN 1
	when SPLIT_PART(source.ethnicity,',',1) = 'Declined' THEN 1
	when SPLIT_PART(source.ethnicity,',',1) = 'Hispanic or Latino' THEN 2
	when SPLIT_PART(source.ethnicity,',',1) = 'Not Hispanic or Latino' THEN 3
	when SPLIT_PART(source.ethnicity,',',1) = 'Other' THEN 4
	when SPLIT_PART(source.ethnicity,',',1) = 'Unknown' THEN 5
	when SPLIT_PART(source.ethnicity,',',1) is null  THEN null
	when SPLIT_PART(source.ethnicity,',',1) = ''  THEN null
	else 5
	end::text,'patientDetails_ethnicity_1', target.patientDetails_ethnicity_1::text, null),
('ethnicity2', SPLIT_PART(source.ethnicity,',',2), case
	when SPLIT_PART(source.ethnicity,',',2) = 'Declined to specify' THEN 1
	when SPLIT_PART(source.ethnicity,',',2) = 'Declined' THEN 1
	when SPLIT_PART(source.ethnicity,',',2) = 'Hispanic or Latino' THEN 2
	when SPLIT_PART(source.ethnicity,',',2) = 'Not Hispanic or Latino' THEN 3
	when SPLIT_PART(source.ethnicity,',',2) = 'Other' THEN 4
	when SPLIT_PART(source.ethnicity,',',2) = 'Unknown' THEN 5
	when SPLIT_PART(source.ethnicity,',',2) is null  THEN null
	when SPLIT_PART(source.ethnicity,',',2) = ''  THEN null
	else 5
	end::text,'patientDetails_ethnicity_2', target.patientDetails_ethnicity_2::text, null),
('new_pat',source.new_pat::text,source.new_pat::text,'patientDetails_isFlagNew', target.patientDetails_isFlagNew,null),
('collections',source.collections::text,source.collections::text,'patientDetails_isFlagInCollection', target.patientDetails_isFlagInCollection,null),
('bad_check',source.bad_check::text,source.bad_check::text,'patientDetails_isFlagBadCheck', target.patientDetails_isFlagBadCheck,null),
('deceased',source.deceased::text,source.deceased::text,'patientDetails_isFlagDeceased', target.patientDetails_isFlagDeceased,null),
('chartless',source.chartless::text,source.chartless::text,'patientDetails_isFlagChartless', target.patientDetails_isFlagChartless,null),
--Manual test-notes					
--('notes_content',source.notes_content,source.notes_content,'notes_text', target.notes_text,null), 
('guar_firstname', source.guar_firstname, case
	when source.parent is null THEN source.firstname
	when source.parent is not null AND source.guar_firstname is null THEN source.firstname
	else source.guar_firstname
	end::text,'guarantor_firstName', target.guarantor_firstName, null),
('guar_lastname', source.guar_lastname, case
	when source.parent is null THEN source.lastname
	when source.parent is not null AND source.guar_lastname is null THEN source.lastname
	else source.guar_lastname
	end::text,'guarantor_lastName', target.guarantor_lastName, null),
('guar_birthday', source.guar_birthday::text, case
	when source.parent is null AND source.birthday < current_date THEN source.birthday::text
	when source.parent is null AND source.birthday is null OR source.birthday > current_date THEN '1700-01-01'
	when source.parent is not null AND source.guar_birthday < current_date THEN source.guar_birthday::text
 	when source.parent is not null AND source.guar_birthday is null THEN source.birthday::text
	when source.parent is not null AND source.guar_birthday is null OR source.guar_birthday > current_date THEN '1700-01-01'
	end::text,'guarantor_dob', target.guarantor_dob::text, null),
('guar_married', source.guar_married, case
    when  source.parent is null THEN null
	when  source.guar_married is null THEN 10
	when  source.guar_married = 'unknown' THEN 10
	when  source.guar_married = 'Married' THEN 7
	when  source.guar_married = 'OTHER' THEN 10
	when  source.guar_married = 'SINGLE' THEN 9
	when  source.guar_married = 'Single' THEN 9
	when  source.guar_married = 'Other' THEN 10
	when  source.guar_married = 'Divorced' THEN 2
	when  source.guar_married = 'MARRIED' THEN 7
	end::text,'guarantor_maritalStatus', target.guarantor_maritalStatus::text, null),
('guar_mi',source.guar_mi,source.guar_mi,'guarantor_middleName', target.guarantor_middleName,null),
('parent', source.subscriber_relationship, case
	when source.subscriber_relationship = 'SELF' THEN 99
	when source.subscriber_relationship = 'SPOUSE' THEN 1
 	when source.subscriber_relationship = 'CHILD' THEN 116
 	when source.subscriber_relationship = 'GRANDCHILD' THEN 5
 	when source.subscriber_relationship = 'NIECE' THEN 7
 	when source.subscriber_relationship = 'NEPHEW' THEN 7
	when source.subscriber_relationship = 'UNKNOWN' THEN 9
 	when source.subscriber_relationship = 'PARENT' THEN 122
 	when source.subscriber_relationship = 'GRANDPARENT' THEN 4
 	when source.subscriber_relationship = 'DOMESTIC_PARTNER' THEN 53
    when source.parent IS NOT NULL AND  source.subscriber_relationship IS NULL  THEN 21
 	ELSE 99
	end::text,'guarantor_relationship', target.guarantor_relationship::text, null),
('guarantor_releaseHippaInfo',null,'true','guarantor_releaseHippaInfo', target.guarantor_releaseHippaInfo,null),
('guar_sex', source.guar_sex, case
    when source.parent is null AND source.sex = 'F' THEN 1
 	when source.parent is null AND source.sex = 'M' THEN 2
 	when source.parent is null AND source.sex = 'UNK' THEN 3
 	when source.parent is null AND source.sex is null THEN 3
	when  source.guar_sex = 'F' THEN 1
	when  source.guar_sex = 'M' THEN 2
	when  source.guar_sex = 'UNK' THEN 3
	when  source.guar_sex is null THEN 3
	end::text,'guarantor_sex', target.guarantor_sex::text, null),
('guar_ssn', source.guar_ssn, CASE 
 WHEN source.guar_ssn IS NULL THEN NULL
 WHEN source.guar_ssn IS NOT NULL THEN  '*****' || RIGHT('000000000',4)
 END,'guarantor_ssn', target.guarantor_ssn, null),						
('guar_designation', source.guar_designation, case
    When source.parent is null THEN null
	when source.parent is not null AND source.guar_designation = 'Mr.' THEN 2
	when source.parent is not null AND source.guar_designation = 'Mrs.' THEN 3
	when source.parent is not null AND source.guar_designation = 'Ms.' THEN 5
	when source.parent is not null AND source.guar_designation = 'Miss' THEN 4
	when source.parent is not null AND source.guar_designation = 'Dr.' THEN 1
	end::text,'guarantor_title', target.guarantor_title, null),
('NS_guar_addresstype', '', '1','guarantor_address_type', target.guarantor_address_type, null),				
('guar_address', source.guar_address, case
	when source.parent is null THEN source.address
	when source.parent is not null AND source.guar_address is null THEN source.address
	else source.guar_address
	end::text,'guarantor_address_addressLine1', target.guarantor_address_addressLine1, null),
('guar_city', source.guar_city, case
	when source.parent is null THEN source.city
	when source.parent is not null AND source.guar_city is null THEN source.city
	else source.guar_city
	end::text,'guarantor_address_city', target.guarantor_address_city, null),					
('guar_state', source.guar_state, case
	when source.parent is null THEN source.state
	when source.parent is not null AND source.guar_state is null THEN source.state
	else source.guar_state
	end::text,'guarantor_address_state', target.guarantor_address_state, null),	
('guar_zip', source.guar_zip::text, case
	when  source.parent is null AND length(source.zip::text) < 5 THEN LPAD(source.zip::text, 5, '0')
    when  source.parent is null AND length(source.zip::text) > 5 AND length(source.zip::text) < 9 THEN LPAD(source.zip::text, 9, '0')
    when  source.parent is null AND length(source.zip::text) > 9 THEN substring(source.zip::text, '^\d{1,5}')
 	when  source.parent is null AND (length(source.zip::text) = 5 OR length(source.zip::text) = 9 ) THEN source.zip::text
    when  source.parent is not null AND length(source.guar_zip::text) < 5 THEN LPAD(source.guar_zip::text, 5, '0')
    when  source.parent is not null AND length(source.guar_zip::text) > 5 AND length(source.guar_zip::text) < 9 THEN LPAD(source.guar_zip::text, 9, '0')
    when  source.parent is not null AND length(source.guar_zip::text) > 9 THEN substring(source.guar_zip::text, '^\d{1,5}')
    when  source.parent is not null AND (length(source.guar_zip::text) = 5 OR length(source.zip::text) = 9 ) THEN source.guar_zip::text
	when  source.parent is not null AND (source.guar_zip::text) IS NULL THEN source.zip::text 
 	when  source.parent is null AND (source.zip::text) IS NULL THEN '00000' 
 	end::text,'guarantor_address_zip', target.guarantor_address_zip, null),	
('guar_email', source.guar_email, case
	when source.parent is null THEN source.email
	when source.parent is not null AND (source.guar_email is null OR source.guar_email ='') THEN NULL
	when source.parent is not null AND source.guar_email is not null THEN source.guar_email
	end::text,'guarantor_email', target.guarantor_email, null),	
('NS_guar_homephonetype', '',case
    WHEN source.parent is null AND source.homephone::text is not null THEN '1'
	when source.parent is not null AND source.guar_homephone::text is not null THEN '1'
 	WHEN source.parent is not null AND (source.guar_homephone::text IS NULL 
	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL)
 	AND source.homephone::text is not null THEN '1'
 	end::text, 'guar_homephonetype', case
		when target.guarantor_phone_type1::text = '1' THEN target.guarantor_phone_type1
		when target.guarantor_phone_type2::text = '1' THEN target.guarantor_phone_type2
		when target.guarantor_phone_type3::text = '1' THEN target.guarantor_phone_type3
		end::text,null),
('NS_guar_celltype', '',case
 	when source.parent::text is null AND  source.cell::text is not null THEN '3'
	when source.parent::text is not null AND source.guar_cell::text is not null THEN '3'
 	WHEN source.parent is not null AND (source.guar_homephone::text IS NULL 
	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL)
 	AND source.cell::text is not null THEN '3'
 	end::text, 'guar_cellphonetype', case
	when target.guarantor_phone_type1::text = '3' THEN target.guarantor_phone_type1
	when target.guarantor_phone_type2::text = '3' THEN target.guarantor_phone_type2
	when target.guarantor_phone_type3::text = '3' THEN target.guarantor_phone_type3
	end::text,null),
('NS_guar_workphonetype', '',case
  	WHEN source.parent is null AND source.workphone::text is not null THEN '2'
	when source.parent::text is not null AND source.guar_workphone::text is not null THEN '2'
   --when source.workphone::text is not null OR source.guar_workphone::text is not null THEN '2'
 	WHEN source.parent is not null AND (source.guar_homephone::text IS NULL 
	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL)
 	AND source.workphone::text is not null THEN '2'
 	end::text, 'guar_workphonetype', case
	when target.guarantor_phone_type1::text = '2' THEN target.guarantor_phone_type1
	when target.guarantor_phone_type2::text = '2' THEN target.guarantor_phone_type2
	when target.guarantor_phone_type3::text = '2' THEN target.guarantor_phone_type3
    else NULL 
	end::text,null),								
('guar_homephone', source.guar_homephone::text, case
	 WHEN source.parent is null THEN source.homephone::text
	 when source.parent is not null AND source.guar_homephone::text IS NOT NULL THEN source.guar_homephone::text
 	when source.parent is not null AND (source.guar_homephone::text IS NULL 
 	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL) THEN source.homephone::text
 when source.parent is not null AND source.guar_homephone::text IS NULL AND source.homephone::text IS NULL THEN NULL 
	 end::text,'guarantor_homephone', case
		when target.guarantor_phone_type1::text = '1' THEN target.guarantor_phone_number1
		when target.guarantor_phone_type2::text = '1' THEN target.guarantor_phone_number2
		when target.guarantor_phone_type3::text = '1' THEN target.guarantor_phone_number3
		else NULL 
		end::text, null),	
('guar_workphone', source.guar_workphone::text, case
		WHEN source.parent is null THEN source.workphone::text
		when source.parent is not null AND source.guar_workphone::text IS NOT NULL THEN source.guar_workphone::text
       	when source.parent is not null AND (source.guar_homephone::text IS NULL 
 	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL) THEN source.workphone::text 
        when source.parent is not null AND source.guar_workphone::text IS NULL AND source.workphone::text IS NULL THEN NULL 
		end::text,'guarantor_workphone',  case
		when target.guarantor_phone_type1::text = '2' THEN target.guarantor_phone_number1
		when target.guarantor_phone_type2::text = '2' THEN target.guarantor_phone_number2
		when target.guarantor_phone_type3::text = '2' THEN target.guarantor_phone_number3
		else NULL 
		end::text, null), 	
('guar_cell', source.guar_cell::text, case
 	WHEN source.parent is null THEN source.cell::text
	when source.parent is not null AND source.guar_cell::text IS NOT NULL THEN source.guar_cell::text
 		when source.parent is not null AND (source.guar_homephone::text IS NULL 
 	AND   source.guar_workphone::text IS NULL AND  source.guar_cell::text IS NULL) THEN source.cell::text
    when source.parent is not null AND source.guar_cell::text IS NULL AND source.cell::text IS NULL THEN NULL
	end::text,'guarantor_cell', case
		when target.guarantor_phone_type1::text = '3' THEN target.guarantor_phone_number1
		when target.guarantor_phone_type2::text = '3' THEN target.guarantor_phone_number2
		when target.guarantor_phone_type3::text = '3' THEN target.guarantor_phone_number3
		else NULL 
		end::text, null),
('NS_guar_emailtype', '',CASE
	 WHEN source.guar_email IS NOT NULL THEN '5'
     when source.parent is null AND source.email IS NOT NULL THEN '5'
	 --when source.parent is not null AND (source.guar_email is null OR source.guar_email ='') THEN NULL
	 end,'guarantor_email_type', target.guarantor_email_type, null),
('guar_preferred_contact',source.guar_preferred_contact,CASE
	 WHEN source.guar_preferred_contact IS NULL THEN NULL
     WHEN source.guar_preferred_contact = 'EMAIL' THEN '2'
	 WHEN source.guar_preferred_contact = 'PHONE' THEN '1'
     WHEN source.guar_preferred_contact = 'LETTER' THEN '1'
	 end,'guar_preferred_contact', CASE 
      WHEN target.guar_contact_text='true' THEN '1'
      WHEN target.guar_contact_email='true' THEN '2'
      WHEN target.guar_contact_phone='true' THEN '1'
      END, null)
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;


