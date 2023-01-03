--digitalAssets' Script
--select * from v_source_digitalAssets
--select * from v_migrated_digitalAssets where source_datasetId = 'insurance_cards';
--Select * from source_target_match WHERE  source_datasetId = 'digitalAssets';
--DELETE FROM source_target_match WHERE  source_datasetId = 'digitalAssets';
--SELECT table_schema, table_name, column_name, data_type 
--FROM INFORMATION_SCHEMA.COLUMNS 
--WHERE table_name = 'source_target_match_dummy' 
--select CONCAT(patient,'_',insurance) as p from v_source_digitalAssets

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'digitalAssets' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_digitalassets as source
FULL JOIN v_migrated_digitalassets as target ON CONCAT(source.patient,'_',source.insurance)  = target.source_instanceId
CROSS JOIN LATERAL (VALUES
  
('front',source.front,source.front,'originalfilename', SPLIT_PART(target.originalfilename,'.',1),null),
('back',source.back,source.back,'originalfilename', SPLIT_PART(target.originalfilename,'.',1),null)
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;