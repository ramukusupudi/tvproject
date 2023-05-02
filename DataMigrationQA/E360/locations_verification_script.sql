DELETE from source_target_match where source_datasetId ='locations';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'locations' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_locations as source
FULL JOIN v_migrated_location as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
	('brand', source.brand::text, source.brand::text, 'brand_id', target.brandid::text, null),				 
  	('name', source.name::text, source.name::text, 'name', target.name::text, null),				
  	('city', source.city::text, source.city::text, 'city', target.city::text, null),
	('state', source.state::text, source.state::text, 'state', target.state::text, null),
	('email', source.email::text, case when source.email is null THEN 'info@eyecare-partners.com'
	else source.email::text end, 'email', target.email::text, null),
	('hicf_location', source.hicf_location, case when source.hicf_location::text = '11' THEN '2'
	 else source.hicf_location::text end,'hicflocationkey', target.hicflocationkey::text, null),											
	('fax', source.fax::text, source.fax::text, 'fax', target.fax::text, null),
	('zip', source.zip::text, source.zip::text, 'zip', target.zip::text, null),
	('address', source.address::text, source.address::text, 'address', target.address::text, null),
	('phone1', source.phone1::text, source.phone1::text, 'phone', target.phone::text, null),
	('notes', source.notes::text, source.notes::text, 'note', target.note::text, null),
	('available', source.available::text, source.available::text, 'isAvailable', target.isAvailable::text, null),
	('affiliate', source.affiliate::text, source.affiliate::text, 'isAffiliate', target.isAffiliate::text, null),				
	('lab_account_num', source.lab_account_num::text, source.lab_account_num::text, 'labAccountNumber', target.labAccountNumber::text, null),
	('open', source.open::text, source.open::text, 'isOpen', target.isOpen::text, null),
	('location_number', source.location_number::text, source.location_number::text, 'locationnumber', target.locationnumber::text, null),		
	('billing', source.billing::text, source.billing::text, 'isBillingOffice', target.isBillingOffice::text, null),
	('tax_id', source.tax_id::text, source.tax_id::text, 'taxId', target.taxId::text, null),
	('npi_number', source.npi_number::text, source.npi_number::text, 'npiNumber', target.npiNumber::text, null),	
	('group_npi', source.group_npi::text, source.group_npi::text, 'groupNpi', target.groupNpi::text, null),
	('practice_location', source.practice_location::text, source.practice_location::text, 'practiceLocationid', target.practiceLocationid::text, null),
	('billing_location', source.billing_location::text, source.billing_location::text, 'billingLocationid', target.billingLocationid::text, null),
('rx_expiration',source.rx_expiration::text, source.rx_expiration::text, 'rxExpirationValidity', target.rxExpirationValidity::text, null),					
('cl_expiration',source.cl_expiration::text, source.cl_expiration::text, 'clrxExpirationValidity', target.clrxExpirationValidity::text, null),
('online_schedule_email', source.online_schedule_email::text, source.online_schedule_email::text, 'onlineScheduleEmail', target.onlineScheduleEmail::text, null)
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;