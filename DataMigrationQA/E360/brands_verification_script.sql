DELETE FROM source_target_match WHERE  source_datasetId = 'brands';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'brands' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_brand as source
FULL JOIN v_migrated_brands as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('name', source.name::text, source.name::text, 'name', target.name::text, null),		
('brand_id', source.brand_id::text, source.brand_id::text, 'brandCode', target.code::text, null),
('available', source.available::text, source.available::text, 'isavailable', target.isavailable::text, null),
('notes', source.notes::text, source.notes::text, 'notes', target.notes::text, null),
('website', source.website::text, source.website::text, 'website', target.website::text, null),
('logo_small',CONCAT (source.logo_small,' ' ,source.brand_id),CONCAT(source.logo_small,'_' ,source.brand_id), 'dalogosmlid', target.dalogosmlid::text, null),
('logo_large',CONCAT (source.logo_large,' ' ,source.brand_id),CONCAT(source.logo_large,'_' ,source.brand_id), 'dalogolarglid', target.dalogolarglid::text, null),
('icon',CONCAT(source.icon,' ' ,source.brand_id),CONCAT(source.icon,'_' ,source.brand_id), 'daiconid', target.daiconid::text, null),					
('icon_Name', source.icon::text, source.icon::text, 'daiconfilename', target.daiconfilename::text, null),
('logo_small_Name', source.logo_small::text, source.logo_small::text, 'dalogosmlfilename', target.dalogosmlfilename::text, null),
('logo_large_Name', source.logo_large::text, source.logo_large::text, 'dalogolargfilename', target.dalogolargfilename::text, null)															
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;