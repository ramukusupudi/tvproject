--Delete from source_target_match where source_datasetId='binocular'

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'binocular' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_binocular as source 
FULL JOIN v_migrated_binocular as target ON CONCAT(source.uid,'_binocular') = target.source_instanceId

CROSS JOIN LATERAL (VALUES
('npc',source.npc,CASE 
 WHEN source.npc ='/null/' OR source.npc is  null THEN ''
 else source.npc
 end ,'notes',target.notes,null)
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					
