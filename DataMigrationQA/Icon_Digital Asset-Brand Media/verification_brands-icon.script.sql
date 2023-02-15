--DELETE FROM source_target_match WHERE  source_datasetId = 'brands_icon'
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'brands_icon' as source_datasetId,
  concat (source.uid ,'logo_small') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_digitalasset_brand_media_small as source
FULL JOIN v_migrated_brands_logo_small as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
	('brands_icon', source.brands_icon::text, source.brands_icon::text, 'name', target.name::text, null),
	('brands_icon', source.brands_icon::text, source.brands_icon::text, 'orginalfilename', target.orginalfilename::text, null),				 
  	('brands_icon', source.brands_icon::text,  split_part(source.brands_icon::text,'.', 2 ), 'type', target.type::text, null),
	('brands_icon', source.brands_icon::text,  split_part(source.brands_icon::text,'.', 2 ), 'subtype', target.subtype::text, null)
	)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;