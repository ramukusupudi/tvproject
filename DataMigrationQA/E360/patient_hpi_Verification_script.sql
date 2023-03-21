DELETE FROM source_target_match WHERE  source_datasetId = 'patient_hpi';
--select *  FROM source_target_match WHERE  source_datasetId = 'patient_hpi' and matched ='FALSE' and target_value is not null and target_field ='notes'
select * FROM source_target_match WHERE  source_id='00138E4D70D4A56FE6C7A9A810E587E8'
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'patient_hpi' as source_datasetId,
  CONCAT(source.uid,'patient_hpi') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_hpi_verfication as source
FULL JOIN v_migrated_patient_hpi as target ON CONCAT(source.uid,'_patient_hpi') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('chief_hpi_complaint',CONCAT(source.chief_complaint,source.hpi_complaint) ,case 
 when source.chief_complaint is null and source.hpi_complaint is null THEN ''
 when source.chief_complaint ='/null/' and source.hpi_complaint is null THEN ''
 when source.chief_complaint ='/null/' and source.hpi_complaint is not null THEN source.expected_hpi_value::text
 when source.chief_complaint is null and source.hpi_complaint is not null THEN source.expected_hpi_value::text
 when source.chief_complaint is not null and source.hpi_complaint::text is null THEN CONCAT('Chief Complaint: ',source.chief_complaint::text) 
 when source.chief_complaint is not null and source.hpi_complaint is not null THEN CONCAT('Chief Complaint: ',source.chief_complaint::text,source.expected_hpi_value::text) end::text,'notes',REPLACE(target.hpi_notes,'\n','\\n'),null),
('provider',source.provider,case 
  when source.provider is null or source.provider::text ='/null/' THEN '' else target.prov_id
  end::text,'provider_id',target.provider_id,null),
 ('employee',source.employee, case 
  when source.employee is null or source.employee::text ='/null/' THEN '' else target.emp_id 
  end,'technician_id',target.technician_id,null)				
 )as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;