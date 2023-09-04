Delete from source_target_match where source_datasetId='notes'; 

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_field, target_value, matched, notes)
SELECT 
  'notes' as source_datasetId,source.uid as source_id,match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  match_tests.target_field, match_tests.target_value,match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_notes as source 
FULL JOIN v_migrated_notes as target ON source.uid = target.source_instanceid 
CROSS JOIN LATERAL (VALUES

('patient_src',source.patient_src::text,source.patient_src::text,'patient_sourceid',target.patient_sourceid,null),
('category',source.category,source.category,'category',target.category,null),	
('type',source.type, case when source.type = '3' THEN 'ALERT'
                     when source.type = '2' THEN 'IMPORTANT'
 					when source.type = '1' THEN 'NORMAL' 
 				when source.type = '0' THEN 'NORMAL'end::text
                     ,'notetagcode',target.notetagcode,null),
					
					
('deleted',source.deleted,source.deleted,'archive',target.archive,null),
('notes',source.notes,source.notes,'text',target.text,null)					
											
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
WHERE  source_datasetId = 'notes'
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched is false

select * from source_target_match
where source_field = 'type'
and source_datasetid = 'notes' and matched is false
