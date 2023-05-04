DELETE FROM source_target_match WHERE  source_datasetId = 'appointments';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
								 target_id, 
								 target_field, target_value, matched, notes)
SELECT 
  'appointments' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value,target._id as target_id, 
  match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_appointments as source
FULL JOIN v_migrated_appointments as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
					
	
	('date', source.date::text, source.date::text, 'appointmentDate', target.appointmentdate::text, null),
	('patient',source.patient_src,source.patient_src,'patient_source_instanceid ', target.patient_source_instanceid, null),
    ('encounter_index',source.encounter_index::text, source.encounter_index::text,'encounter', split_part(target.encounter::text, '.', 1), null),					
	('location',source.location::text,source.location::text,'location_source_instanceid ', target.office_source_instanceid::text, null),
				 
  	('time', source.time::text, source.time::text, 'appointmentTime', target.appointmenttime::text, null),
					
  	('length', source.length::text, source.length::text, 'appointmentLength', target.appointmentLength::text, null),
					
	('appointmentendtime', '', (source.time + (source.length||' minutes')::interval)::text, 'appointmentendtime',target.appointmentendtime::text,null),
			
	('confirmed', source.confirmed::text, case when source.confirmed is null THEN FALSE
	                                  when source.confirmed is not null THEN source.confirmed end::text, 'isconfirmed', target.isconfirmed::text, null),

 	('notes', source.notes::text, source.notes::text, 'notes', target.notes::text, null),
					
 	('new_pat', source.new_pat::text, source.new_pat::text, 'new_pat', target.new_pat::text, null),

 	('patient_birthday', source.birthday::text, case when source.birthday > CURRENT_DATE THEN '1990-01-01'
	                                              when source.birthday <= CURRENT_DATE THEN source.birthday end::text,'patientdob', target.patientdob::text, null),
	('patient_parent', source.parent::text, source.parent::text,'guarantor_id',target.source_guarantor_id::text, null),

	('provider_uid', source.provider::text, source.provider::text, 'provider_source_instanceid', target.provider_source_instanceid::text, null),
				
  ('type', source.type, case
       when source.type = '1' THEN 'Contact Lens Check'
	   when source.type = '2' THEN 'Contact Lens Dispense'
	   when source.type = '3' THEN 'Preop / Enhancement'
	   when source.type = '4' THEN 'Comprehensive'
       when source.type = '5' THEN 'NO_APPOINTMENT'
	   when source.type = '6' THEN 'Followup Limited'
	   when source.type = '7' THEN 'Followup Long'
	   when source.type = '8' THEN 'Visual Field'
	   when source.type = '9' THEN 'IOP (Pressure Check)'
	   when source.type = '10' THEN 'Rx Check'
	   when source.type = '11' THEN 'Flashes / Floaters'
	   when source.type = '12' THEN 'Surgery Consult'
	   when source.type = '13' THEN 'Urgent'
       when source.type = '14' THEN 'NO_APPOINTMENT'
	   when source.type = '15' THEN 'Glaucoma Eval'
	   when source.type = '16' THEN 'Preop / Consult'
       when source.type = '17' THEN 'NO_APPOINTMENT'
	   when source.type = '18' THEN 'LASIK 1 Day Postop'
	   when source.type = '19' THEN 'LASIK 1 Week Postop'
   	   when source.type = '20' THEN 'NO_APPOINTMENT'
	   when source.type = '21' THEN 'LASIK 3 Month Postop'
       when source.type = '22' THEN 'NO_APPOINTMENT'
       when source.type = '23' THEN 'NO_APPOINTMENT'
	   when source.type = '24' THEN 'LASIK Postop'
	   when source.type = '25' THEN 'Medical Office Visit'
	   when source.type = '26' THEN 'LASIK Enhancement'
       when source.type = '27' THEN 'NO_APPOINTMENT'
	   when source.type = '28' THEN 'Surgical Postop'
	   when source.type = '29' THEN 'NO_APPOINTMENT'
	   when source.type = '30' THEN 'Contact Lens Teach'
	   when source.type = '31' THEN 'Dilate'
       when source.type = '35' THEN 'NO_APPOINTMENT'
       when source.type = '36' THEN 'NO_APPOINTMENT'
	   when source.type = '37' THEN 'Refraction'
	   when source.type = '38' THEN 'OCT'
	   when source.type = '39' THEN 'Cataract Eval'
	   when source.type = '40' THEN 'YAG Eval'
       when source.type = '41' THEN 'NO_APPOINTMENT'
       when source.type = '42' THEN 'NO_APPOINTMENT'
       when source.type = '43' THEN 'NO_APPOINTMENT'
   	   when source.type = '44' THEN 'NO_APPOINTMENT'
   	   when source.type = '45' THEN 'NO_APPOINTMENT'
       when source.type = '46' THEN 'NO_APPOINTMENT'
       when source.type = '47' THEN 'NO_APPOINTMENT'
	   when source.type = '48' THEN 'Preop / Enhancement'
       when source.type = '49' THEN 'NO_APPOINTMENT'
	   when source.type = '50' THEN 'Contact Lens Fitting'
	   when source.type = '51' THEN 'PRK Postop'
	   when source.type = '52' THEN 'PRK Postop'
	   when source.type = '53' THEN 'PRK Postop'
	   when source.type = '54' THEN 'Corneal Topography'
       when source.type = '55' THEN 'NO_APPOINTMENT'
       when source.type = '56' THEN 'NO_APPOINTMENT'
	   when source.type = '57' THEN 'MEPCOM Consultation'
       when source.type = '58' THEN 'NO_APPOINTMENT'
       when source.type = '59' THEN 'NO_APPOINTMENT'
       when source.type = '60' THEN 'NO_APPOINTMENT'
	   when source.type = '61' THEN 'Wavefront Allegretto fs2000'
	   when source.type = '62' THEN 'Wavefront Allegretto'
	   when source.type = '63' THEN 'Other'
	   when source.type = '64' THEN 'Glaucoma Eval'
	   when source.type = '65' THEN 'Retina Eval'
	   when source.type = '66' THEN 'MPOD'
	   when source.type = '67' THEN 'Photo'
	   when source.type = '68' THEN 'Dry Eye Eval'
	   when source.type = '69' THEN 'Lipiflow'
	   when source.type = '70' THEN 'Plaquenil Eval'
	   when source.type = '71' THEN 'Other'
	   when source.type = '72' THEN 'Telehealth Visit'
	   when source.type = '74' THEN 'Open Appointment'
	   when source.type = '80' THEN 'Vision Therapy'
	   when source.type = '81' THEN 'Occupational Therapy'
	   when source.type = '82' THEN 'Sensorimotor'
       when source.type = '83' THEN 'NO_APPOINTMENT'
       when source.type = '84' THEN 'NO_APPOINTMENT'
	   when source.type = '85' THEN 'Glasses Consultation'
	   when source.type = '86' THEN 'Corneal Refractive Therapy Eval (CRT)'
       when source.type = '87' THEN 'NO_APPOINTMENT'
       when source.type = '88' THEN 'NO_APPOINTMENT'
       when source.type = '89' THEN 'NO_APPOINTMENT'
     end::text,
     'type', target.Appointmenttype::text, null)					
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
where  target.source_instanceId is not null
;
/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
WHERE  source_datasetId = 'appointments' and matched is false
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched is false
select * 
select *
from source_target_match
WHERE  source_datasetId = 'appointments'and matched is false and source_id='C42CE3E2A998A0C6A4C984E9E2704DFE'

select * from source_target_match
where source_field = 'provider_uid'
and source_datasetid = 'appointments'
and matched is false

*/
