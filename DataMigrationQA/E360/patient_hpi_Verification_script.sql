DELETE FROM source_target_match WHERE  source_datasetId = 'patient_hpi';

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
('patient_src',source.patient_src::text,source.patient_src::text,'patient_sourceId',target.patient_sourceId,null),				
('date',source.date::text,TO_CHAR(source.date::DATE,'mm/dd/yyyy'),'appointmentdate',target.appointmentdate,null),
('chief_hpi_complaint',CONCAT(source.chief_complaint,source.hpi_complaint) ,case 
 when source.chief_complaint is null and source.hpi_complaint is null THEN ''
 when source.chief_complaint ='/null/' and source.hpi_complaint is null THEN ''
 when source.chief_complaint ='/null/' and source.hpi_complaint is not null THEN REGEXP_REPLACE(source.expected_hpi_value::text,E'[\\n]+', '', 'g')
 when source.chief_complaint is null and source.hpi_complaint is not null THEN source.expected_hpi_value::text
 when source.chief_complaint is not null and source.hpi_complaint is null THEN BTRIM (CONCAT('Chief Complaint: ',source.chief_complaint))
 when source.chief_complaint is not null and source.hpi_complaint is not null THEN  REGEXP_REPLACE((CONCAT('Chief Complaint: ',source.chief_complaint,source.expected_hpi_value)),'^[\\r\\n\\t ]*|[\\r\\n\\t ]*$', '', 'g') 
 end::text,'notes',REGEXP_REPLACE(REPLACE(target.hpi_notes,'\n','\\n'),E'[\\n]+', '', 'g'),null),
('provider',source.provider_src,case 
  when source.provider_src is null or source.provider_src::text ='/null/' THEN '' else target.prov_id
  end::text,'provider_id',target.provider_id,null),
 ('employee',source.employee, case 
  when source.employee is null or source.employee::text ='/null/' THEN '' else target.emp_id 
  end,'technician_id',target.technician_id,null)				
 )as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
--select * FROM source_target_match WHERE  source_datasetId = 'patient_hpi' and matched ='FALSE' and target_value is not null