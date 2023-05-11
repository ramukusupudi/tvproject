Delete from source_target_match where source_datasetId = 'DigitalAssets_ic_front';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'DigitalAssets_ic_front' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_digitalassets_ic_front as source
FULL JOIN v_migrated_digitalassets_ic_front as target ON SPLIT_PART(target.source_instanceId,'_',1)  = source.uid
CROSS JOIN LATERAL (VALUES
('name',source.front,Case
 				WHEN  source.front is null THEN NULL
 				else source.front
 	end::text,'name',target.name,null),					
('front',source.front,Case
 				WHEN  source.front is null THEN NULL 
 				else source.front
 	end::text,'originalFileName',target.originalFileName,null),						
('type','',Case
 				WHEN  source.front is null THEN NULL
 				else SPLIT_PART(source.front,'.',2)
 	end::text,'type',target.type,null),					
('subtype','',Case
 				WHEN  source.front is null THEN NULL
 				else SPLIT_PART(source.front,'.',2)
 	end::text,'subType',target.subType,null)						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

Delete from source_target_match where source_datasetId = 'DigitalAssets_ic_back';
INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'DigitalAssets_ic_back' as source_datasetId,
  CONCAT(source.uid,'_back') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_digitalassets_ic_back as source
FULL JOIN v_migrated_digitalassets_ic_back as target ON SPLIT_PART(target.source_instanceId,'_',1)  = source.uid
CROSS JOIN LATERAL (VALUES
('name',source.back,Case
 				WHEN  source.back is null THEN NULL
 				else source.back
 	end::text,'name',target.name,null),					
('back',source.back,Case
 				WHEN  source.back is null THEN NULL
 				else source.back
 	end::text,'originalFileName',target.originalFileName,null),						
('type','',Case
 				WHEN  source.back is null THEN NULL
 				else SPLIT_PART(source.back,'.',2)
 	end::text,'type',target.type,null),					
('subtype','',Case
 				WHEN  source.back is null THEN NULL
 				else SPLIT_PART(source.back,'.',2)
 	end::text,'subType',target.subType,null)						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
; 

Delete from source_target_match where source_datasetId = 'DigitalAssets_documents';
INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'DigitalAssets_documents' as source_datasetId,
  CONCAT(source.uid,'_document') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_digitalassets_documents as source
FULL JOIN v_migrated_digitalassets_documents as target ON source.uid  = SPLIT_PART(target.source_instanceId,'_',1)
CROSS JOIN LATERAL (VALUES

('name',source.filename,source.filename,'name',target.name,null),					
('filename',source.filename,source.filename,'originalfilename',target.originalfilename,null),				
('type','',SPLIT_PART(source.filename,'.',2),'type',target.type,null),					
('subtype','',SPLIT_PART(source.filename,'.',2),'subType',target.subType,null)							
						
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
; 
