--DELETE FROM source_target_match WHERE  source_datasetId = 'brands_logo_small'
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'brands_logo_small' as source_datasetId,
  concat (source.uid ,'logo_small') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_digitalasset_brand_media_small as source
FULL JOIN v_migrated_brands_logo_small as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
	('logo_small', source.logo_small::text, source.logo_small::text, 'name', target.name::text, null),
	('logo_small', source.logo_small::text, source.logo_small::text, 'orginalfilename', target.orginalfilename::text, null),				 
  	('logo_small', source.logo_small::text,  split_part(source.logo_small::text,'.', 2 ), 'type', target.type::text, null),
	('logo_small', source.logo_small::text,  split_part(source.logo_small::text,'.', 2 ), 'subtype', target.subtype::text, null)
	)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;