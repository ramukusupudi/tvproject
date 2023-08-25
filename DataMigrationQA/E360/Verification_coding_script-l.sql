DELETE FROM source_target_match WHERE  source_datasetId = 'coding';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'coding' as source_datasetId,
  CONCAT(source.uid,'_coding') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_coding as source
FULL JOIN v_migrated_coding as target ON CONCAT(source.uid,'_coding') = target.source_instanceid
CROSS JOIN LATERAL (VALUES
--('patient_src',source.patient_src::text,source.patient_src::text,'patient_sourceId',target.patient_sourceId,null),				
--('date',source.date::text,TO_CHAR(source.date::DATE,'mm/dd/yyyy'),'appointmentdate',target.appointmentdate,null),
('mod2',source.mod2::text,case when source.mod2::text is null then ''
                            when source.mod2::text is not null then source.mod2::text end::text,'mod2',target.mod2::text,null),
('mod3',source.mod3::text,case when source.mod3::text is null then ''
                                when source.mod3::text is not null then source.mod3::text end::text,'mod3',target.mod3::text,null),
('mod4',source.mod4::text,case  when source.mod4::text is null then ''
 								when source.mod4::text is not null then source.mod4::text end::text,'mod4', target.mod4::text,null),
('cpt',source.cpt,source.cpt,'cpt',target.cpt,null),	
('employee',source.employee,source.employee,'createdBy', target.createdby_source_instanceid,null),
('employee',source.employee,source.employee,'updatedBy',target.updatedby_source_instanceid,null),
('deleted','false','false','isDeleted',target.isDeleted::text,null),
--('confirmationdate', source.confirmationdate::text,TO_CHAR(source.confirmationdate::date,'mm/dd/yyyy'), 'confirmationdate', target.confirmationdate::text, null),
('created_stamp',source.created_stamp::text,TO_CHAR(source.created_stamp::date,'mm/dd/yyyy'),'createdDate' ,target.createdDate::text,null),
('updated_stamp',source.updated_stamp::text,TO_CHAR(source.updated_stamp::date,'mm/dd/yyyy'), 'updatedDate',target.updatedDate::text,null)
									
 )as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;


/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
WHERE  source_datasetId = 'coding' and matched is false
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched is false
select * 
select *
from source_target_match
WHERE  source_datasetId = 'appointments'and matched is false and source_id='C42CE3E2A998A0C6A4C984E9E2704DFE'

select * from source_target_match
where source_field = 'mod4'
and source_datasetid = 'coding'
and matched is false

*/
