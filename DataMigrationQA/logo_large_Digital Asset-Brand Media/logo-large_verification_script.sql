--DELETE FROM source_target_match WHERE  source_datasetId = 'brand_logo_large'
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'brand_logo_large' as source_datasetId,
   concat (source.uid ,'logo_large') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_digitalasset_brand_media_large as source
FULL JOIN v_migrated_brands_logo_large as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
	('logo_large', source.logo_large::text, source.logo_large::text, 'name', target.name::text, null),
	('logo_large', source.logo_large::text, source.logo_large::text, 'orginalfilename', target.orginalfilename::text, null),				 
  	('logo_large', source.logo_large::text,  split_part(source.logo_large::text,'.', 2 ), 'type', target.type::text, null),
	('logo_large', source.logo_large::text,  split_part(source.logo_large::text,'.', 2 ), 'subtype', target.subtype::text, null)
	)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
