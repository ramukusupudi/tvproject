Delete from source_target_match where source_datasetId='coverage';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'coverage' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_coverage as source
FULL JOIN v_migrated_coverage as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
  
--('patient', source.patient, source.patient, 'beneficiary_id', target.beneficiary_id, null),
('patins_type', source.patins_type::text, case
	when source.patins_type = '0' THEN 'UNKNOWN'
	when source.patins_type = '1' THEN 'VISION'
	when source.patins_type = '2' THEN 'MEDICAL'
	when source.patins_type = '3' THEN 'SUPPLEMENT'
	when source.patins_type = '4' THEN 'COORDINATED'
	else 'UNKNOWN'
	end, 'insurancetype', target.insurancetype, null),															
--('insurance',source.insurance,source.insurance,'payer_id ', target.payer_id, null),																							
--  ('plan',source.plan,source.plan,'plan_id ', target.plan_id, null),																							
-- ('insurance_id',source.insurance_id,source.insurance_id,'insuranceId',target.insuranceId, null),																							
('group_number ',source.group_number,source.group_number,'group', target.group, null),																							
('card_phone ',source.card_phone,CASE 
 WHEN LENGTH(source.card_phone::text)>10 THEN LEFT(source.card_phone::text,10)
 WHEN LENGTH(source.card_phone::text)<10 THEN '1234567890'
 else source.card_phone::text
 end,
 'insPhone', target.insPhone, null),																							
/*
('ordering', source.ordering::text, case
when source.ordering = '0' THEN 'PRIMARY'
when source.ordering = '1' THEN 'SECONDARY'
when source.ordering = '2' THEN 'TERTIARY'
end,
'priority', target.priority, null),*/
('subscriber_relationship',source.subscriber_relationship::text,case
	when source.subscriber_relationship::text = 'SELF' THEN '99'
	when source.subscriber_relationship::text = 'SPOUSE' THEN '1'
	when source.subscriber_relationship::text = 'CHILD' THEN '110'
	when source.subscriber_relationship::text = 'GRANDCHILD' THEN '5'
	when source.subscriber_relationship::text = 'NEPHEW / NIECE' THEN '7'
 	when source.subscriber_relationship::text = 'NEPHEW' THEN '7'
 	when source.subscriber_relationship::text = 'NIECE' THEN '7'
	when source.subscriber_relationship::text = 'PARENT' THEN '19'
	when source.subscriber_relationship::text = 'GRANDPARENT' THEN '4'
	when source.subscriber_relationship::text = 'DOMESTIC_PARTNER' THEN '53'
	when source.subscriber_relationship::text = 'FRIEND' THEN '106'
	when source.subscriber_relationship::text = 'SIBLING' THEN '113'
	else '99'
	end,'subscriberRelation',target.subscriberRelation, null),																							
('subscriber_relationship', source.subscriber_relationship, case
	when source.subscriber_relationship = 'SELF' THEN 'true'
	when source.subscriber_relationship <> 'SELF' THEN 'false'
	end,'isPatientSubscriber', target.isPatientSubscriber, null),																		
('active',source.active::text,source.active::text,'active', target.active, null),																							
('selected',source.selected::text,source.selected::text,'selected', target.selected, null),																							
('firstname',source.firstname,source.firstname,'subscriber_firstname', target.subscriber_firstname, null),
('lastname',source.lastname,source.lastname,'subscriber_lastName', target.subscriber_lastName, null),
('birthday',source.birthday::text,case
	when source.birthday < current_date THEN source.birthday::text 
	else '1990-01-01'
	end::text,'subscriber_dob', target.subscriber_dob::text, null),
('addresstype','','1','subscriber_addresstype', target.subscriber_addresstype, null),					
('address',source.address,source.address,'subscriber_addressLine1', target.subscriber_addressLine1, null),
('city',source.city,source.city,'subscriber_city', target.subscriber_city, null),
('state',source.state,source.state,'subscriber_state', target.subscriber_state, null),
('zip',source.zip::text,case
	when length(source.zip::text) != 5 THEN '12345'
	else source.zip 
	end::text,'subscriber_zip', target.subscriber_zip, null),
('emailtype','','5','subscriber_emailtype',target.subscriber_emailtype, null),
('email',source.email,source.email,'subscriber_email',target.subscriber_email, null),
('homephonetype','',CASE 
 	when source.homephone::text is null THEN null
 	when source.homephone::text is not null THEN '1'
 	end,'subscriber_homephonetype', case
	when source.homephone::text = target.subscriber_number0 THEN target.subscriber_numbertype0
	when source.homephone::text = target.subscriber_number1 THEN target.subscriber_numbertype1
	when source.homephone::text = target.subscriber_number2 THEN target.subscriber_numbertype2
	else null
	end, null),	
('celltype','',CASE 
 	when source.cell::text is null THEN null
 	when source.cell::text is not null THEN '3'
 	end,'subscriber_celltype', case
		when source.cell::text = target.subscriber_number0 THEN target.subscriber_numbertype0
		when source.cell::text = target.subscriber_number1 THEN target.subscriber_numbertype1
		when source.cell::text = target.subscriber_number2 THEN target.subscriber_numbertype2
		else null
		end, null),	
('workphonetype','',CASE 
 	when source.workphone::text is null THEN null
 	when source.workphone::text is not null THEN '2'
 	end,'subscriber_workphonetype', case
		when source.workphone::text = target.subscriber_number0 THEN target.subscriber_numbertype0
		when source.workphone::text = target.subscriber_number1 THEN target.subscriber_numbertype1
		when source.workphone::text = target.subscriber_number2 THEN target.subscriber_numbertype2
		else null
		end, null),					
('homephone',source.homephone::text,source.homephone::text,'subscriber_number0', case
	when source.homephone::text = target.subscriber_number0 THEN target.subscriber_number0
	when source.homephone::text = target.subscriber_number1 THEN target.subscriber_number1
	when source.homephone::text = target.subscriber_number2 THEN target.subscriber_number2
	else null
	end, null),
('workphone',source.workphone::text,source.workphone::text,'subscriber_number1', case
	when source.workphone::text = target.subscriber_number0 THEN target.subscriber_number0
	when source.workphone::text = target.subscriber_number1 THEN target.subscriber_number1
	when source.workphone::text = target.subscriber_number2 THEN target.subscriber_number2
	else null
	end, null),
('cell',source.cell::text,source.cell::text,'subscriber_number2', case
	when source.cell::text = target.subscriber_number0 THEN target.subscriber_number0
	when source.cell::text = target.subscriber_number1 THEN target.subscriber_number1
	when source.cell::text = target.subscriber_number2 THEN target.subscriber_number2
	else null
	end, null),
('cov_ic_uid','',CASE 
 	when source.ic_uid::text is null THEN null
 	else CONCAT(source.ic_uid::text,'_front')
 	end,'ins_front_uid', target.ic_front_source_instanceid, null),
('cov_ins_front_id','',CASE 
 	when target.cov_digitalassetsmasterfrontuid::text is null THEN null
 	else target.cov_digitalassetsmasterfrontuid
 	end,'ins_front_id', target.ic_front_id, null),					
('cov_front_version','',CASE 
 	when target.cov_digitalassetsmasterfrontversion::text is null THEN null
 	else target.cov_digitalassetsmasterfrontversion
 	end,'ins_front_version', target.ic_front_version, null),	
('cov_front_filename','',CASE 
 	when target.cov_digitalassetsmasterfrontfilename::text is null THEN null
 	else target.cov_digitalassetsmasterfrontfilename
 	end,'ins_front_filename', target.ic_front_fileName, null)		
/*('cov_ins_back_id','',CASE 
 	when target.digitalassetsmasterbackuid::text is null THEN null
 	else target.digitalassetsmasterbackuid
 	end,'ins_back_id', target.ic_back_id, null),	
('cov_ic_uid','',CASE 
 	when source.ic_uid::text is null THEN null
 	else source.ic_uid::text
 	end,'ins_back_uid', target.ic_back_source_instanceid, null),
('cov_back_version','',CASE 
 	when target.ic_back_version::text is null THEN null
 	else target.ic_back_version
 	end,'ins_back_version', target.digitalassetsmasterbackversion, null),	
('cov_back_filename','',CASE 
 	when target.ic_back_fileName::text is null THEN null
 	else target.ic_back_fileName
 	end,'ins_back_filename', target.digitalassetsmasterbackfilename, null)*/						
-- ('ssn',source.ssn,source.ssn,'subscriber_ssn', target.subscriber_ssn, null),
--('notes',source.notes,source.notes,'subscriber_notes', target.subscriber_notes, null)
--('plan_insurance',source.plan_insurance,source.plan_insurance,'planname',target.planname, null),					
-- ('name',source.name,source.name,'planname',target.planname, null),
--('phone1',source.phone1::text,source.phone1::text,'planphone', target.planphone, null),
--('plan_address',source.address,source.address,'planaddress', target.planaddress, null),
-- ('plan_state',source.state,source.state,'planstate', target.planstate, null),
-- ('plan_city',source.city,source.city,'plancity', target.plancity, null),
--('plan_zip',source.zip::text,source.zip::text,'planzip', target.planzip, null)

) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;


  