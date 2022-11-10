DELETE FROM source_target_match
WHERE  source_datasetId = 'appointments';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
								 --target_id, 
								 target_field, target_value, matched, notes)
SELECT 
  'appointments' as source_datasetId,
  source.appointment_uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
 -- target_patients.source_Instanceid as target_id, 
  match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
--FROM appointments as source
FROM v_source_pat_app_loc_pro as source
FULL JOIN v_migrated_appointments as target ON source.appointment_uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
					
	('patient',source.p_uid,source.p_uid,'patient_source_instanceid ', target.patient_source_instanceid, null),

	('location',source.location_uid::text,source.location_uid::text,'location_source_instanceid ', target.office_source_instanceid::text, null),
				
	('provider_template', source.app_provider_template::text, source.app_provider_template::text, 'providerTemplate._id', target.providerTemplate_id, null),
					
	('date', source.app_date::text, source.app_date::text, 'appointmentDate', target.appointmentdate::text, null),
					 
  	('time', source.app_time::text, source.app_time::text, 'appointmentTime', target.appointmenttime::text, null),
					
  	('length', source.app_length::text, source.app_length::text, 'appointmentLength', target.appointmentLength::text, null),

  	('confirmed', source.app_confirmed::text, source.app_confirmed::text, 'isconfirmed', target.isconfirmed::text, null),

 	('notes', source.app_notes::text, source.app_notes::text, 'notes', target.notes::text, null),
					
 	('new_pat', source.new_pat::text, source.new_pat::text, 'newpatient', target.newpatient::text, null),

 	('patient_birthday', source.birthday::text, source.birthday::text, 'patient_dob', target.patient_dob::text, null),
					
 	('patient_parent', source.guarantor::text, source.guarantor::text, 'guarantor_id', target.guarantor_id::text, null),

	('provider_uid', source.provider_uid::text, source.provider_uid::text, 'provider_source_instanceid', target.provider_source_instanceid::text, null),
				
										
 --	('provider_template', source.app_provider_template::text, source.app_provider_template::text, 'providertemplate_id', target.providertemplate_id::text, null),
					
				
					
  ('type', source.app_type, case
       when source.app_type = '1' THEN 'Contact Lens Check'
	   when source.app_type = '2' THEN 'Contact Lens Dispense'
	   when source.app_type = '3' THEN 'Preop / Enhancement'
	   when source.app_type = '4' THEN 'Comprehensive'
	   when source.app_type = '6' THEN 'Followup Limited'
	   when source.app_type = '7' THEN 'Followup Long'
	   when source.app_type = '8' THEN 'VSD'
	   when source.app_type = '9' THEN 'IOP (Pressure Check)'
	   when source.app_type = '10' THEN 'Rx Check'
	   when source.app_type = '11' THEN 'Flashes / Floaters'
	   when source.app_type = '12' THEN 'Surgery Consult'
	   when source.app_type = '13' THEN 'Urgent'
	   when source.app_type = '15' THEN 'Glaucoma Eval'
	   when source.app_type = '16' THEN 'Preop / Consult'
	   when source.app_type = '18' THEN 'LASIK 1 Day Postop'
	   when source.app_type = '19' THEN 'LASIK 1 Week Postop'
	   when source.app_type = '21' THEN 'LASIK 3 Month Postop'
	   when source.app_type = '24' THEN 'LASIK Postop'
	   when source.app_type = '25' THEN 'Medical Office Visit'
	   when source.app_type = '26' THEN 'LASIK Enhancement'
	   when source.app_type = '28' THEN 'Surgical Postop'
	   when source.app_type = '29' THEN 'No Appointment'
	   when source.app_type = '30' THEN 'Contact Lens Teach'
	   when source.app_type = '31' THEN 'Dilate'
	   when source.app_type = '37' THEN 'Refraction'
	   when source.app_type = '38' THEN 'OCT'
	   when source.app_type = '39' THEN 'Cataract Eval'
	   when source.app_type = '40' THEN 'YAG Eval'
	   when source.app_type = '48' THEN 'Preop / Enhancement'
	   when source.app_type = '50' THEN 'Contact Lens Fitting'
	   when source.app_type = '51' THEN 'PRK Postop'
	   when source.app_type = '52' THEN 'PRK Postop'
	   when source.app_type = '53' THEN 'PRK Postop'
	   when source.app_type = '54' THEN 'Corneal Topography'
	   when source.app_type = '57' THEN 'MEPCOM Consultation'
	   when source.app_type = '61' THEN 'Wavefront Allegretto fs2000'
	   when source.app_type = '62' THEN 'Wavefront Allegretto'
	   when source.app_type = '63' THEN 'Other'
	   when source.app_type = '64' THEN 'Glaucoma Eval'
	   when source.app_type = '65' THEN 'Retina Eval'
	   when source.app_type = '66' THEN 'MPOD'
	   when source.app_type = '67' THEN 'Photo'
	   when source.app_type = '68' THEN 'Dry Eye Eval'
	   when source.app_type = '69' THEN 'Lipiflow'
	   when source.app_type = '70' THEN 'Plaquenil Eval'
	   when source.app_type = '71' THEN 'Other'
	   when source.app_type = '72' THEN 'Telehealth Visit'
	   when source.app_type = '74' THEN 'Open Appointment'
	   when source.app_type = '80' THEN 'Vision Therapy'
	   when source.app_type = '81' THEN 'Occupational Therapy'
	   when source.app_type = '82' THEN 'Sensorimotor'
	   when source.app_type = '85' THEN 'Glasses Consultation'
	   when source.app_type = '86' THEN 'Corneal Refractive Therapy Eval (CRT)C'
     end::text,
     'type', target.appointmentcode::text, null)					
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
where  target.source_instanceId is not null
;
/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
WHERE  source_datasetId = 'appointments'
and matched = true
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
where  source_datasetId = 'appointments'
and matched = true
group by source_datasetId, source_field, target_field, matched, notes

select * from source_target_match
where source_field = 'provider_template'
and matched is false

*/
