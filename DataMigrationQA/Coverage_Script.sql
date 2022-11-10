DELETE FROM source_target_match
WHERE  source_datasetId = 'coverage';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'coverage' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_patient_insurances as source
FULL JOIN v_migrated_coverage as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
  -- TO FIX: source reference and target reference cannot be compared directly, but only as cross check - like mail patient insurances, aged of 30, etc
  --('patient', source.patient, source.patient, 'beneficiary_id', target.beneficiary_id, null),
('uid', source.uid, source.uid, 'source_instanceId', target.source_instanceId, null),	

  ('patins_type', source.patins_type::text, source.patins_type ::text, 'insurancetype', target.insurancetype, null),																

  ('insurance ',source.insurance,source.insurance,'payer_id ', target.payer_id, null),																							

  ('plan',source.plan,source.plan,'plan_id ', target.plan_id, null),																							

  ('insurance_id',source.insurance_id,source.insurance_id,'insuranceId',target.insuranceId, null),																							

  ('group_number ',source.group_number,source.group_number,'group', target.group, null),																							

  ('card_phone ',source.card_phone,source.card_phone,'insPhone', target.insPhone, null),																							

  ('ordering', source.ordering::text, case
         when source.ordering = '0' THEN 'Primary'
         when source.ordering = '1' THEN 'Secondary'
       end,
       'priority', target.priority, null),
  	
  ('subscriber_relationship',source.subscriber_relationship,source.subscriber_relationship,'subscriberRelation',target.subscriberRelation, null),																							

  ('subscriber_relationship', source.subscriber_relationship, case
         when source.subscriber_relationship = 'Self' THEN 'True'
         when source.subscriber_relationship <> 'Self' THEN 'False'
         end,
       'isPatientSubscriber', target.isPatientSubscriber, null),																		

  ('active',source.active::text,source.active::text,'active', target.active, null),																							

  ('selected',source.selected::text,source.selected::text,'selected', target.selected, null),																							
  --('patient_insurance',source.patient_insurance,source.patient_insurance,'digitalAssets.master_front.uid',target.digitalAssets.master_front.uid, null)																							
  --('XXXXXXX',source.XXXXXXX,source.XXXXXXX,'digitalAssets.master_back.uid ', target.digitalAssets.master_back.uid, null),	

  ('firstname',source.firstname,source.firstname,'subscriber_firstname', target.subscriber_firstname, null),

  ('lastname',source.lastname,source.lastname,'subscriber_lastName', target.subscriber_lastName, null),

  ('birthday',source.birthday::text,source.birthday::text,'subscriber_dob', target.subscriber_dob, null),

  ('address',source.address,source.address,'subscriber_addressLine1', target.subscriber_addressLine1, null),

  ('city',source.city,source.city,'subscriber_city', target.subscriber_city, null),

  ('state',source.state,source.state,'subscriber_state', target.subscriber_state, null),

  ('zip',source.zip::text,source.zip::text,'subscriber_zip', target.subscriber_zip, null),

  ('email',source.email,source.email,'subscriber_email',target.subscriber_email, null),

  ('homephone',source.homephone::text,source.homephone::text,'subscriber_number0', target.subscriber_number0, null),

  ('workphone',source.workphone::text,source.workphone::text,'subscriber_number1', target.subscriber_number1, null),

  ('cell',source.cell::text,source.cell::text,'subscriber_number2', target.subscriber_number2, null),

  ('ssn',source.ssn,source.ssn,'subscriber_ssn', target.subscriber_ssn, null),

  ('notes',source.notes,source.notes,'subscriber_notes', target.subscriber_notes, null),
  					
  --('plan_insurance',source.plan_insurance,source.plan_insurance,'planname',target.planname, null),					

  ('name',source.name,source.name,'planname',target.planname, null),

  ('phone1::text',source.phone1::text,source.phone1::text,'planphone', target.planphone, null),

  ('plan_address',source.address,source.address,'planaddress', target.planaddress, null),

  ('plan_state',source.state,source.state,'planstate', target.planstate, null),

  ('plan_city',source.city,source.city,'plancity', target.plancity, null),

  ('plan_zip',source.zip::text,source.zip::text,'planzip', target.planzip, null)
  	
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
where source_datasetId = 'coverage'
group by source_datasetId, source_field, target_field, matched, notes

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
where source_datasetId = 'coverage' 
  and matched = false
group by source_datasetId, source_field, target_field, matched, notes

/*
select Distinct target_field from source_target_match where matched=false and target_field='zip'
*/
--where --source_id = '9E038C19F5C44FC3AD4E7890C43D645E'
 --NOT matched 
 
 --select subscriber_email from public.v_migrated_coverage
  