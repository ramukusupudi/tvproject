DELETE FROM source_target_match WHERE  source_datasetId = 'systemic_allergy_history';
--select * FROM source_target_match WHERE  source_datasetId = 'systemic_allergy_history' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'systemic_allergy_history' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_systemic_allergy_history as source
FULL JOIN v_migrated_allergies as target ON CONCAT(source.uid,'_systemic_allergy_history') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('allergylognotes',source.allergylognotes,source.allergylognotes,'allergylognotes',target.notes,null),
('rxnorm',source.rxnorm,source.rxnorm,'code',target.code,null),	
('allergienames',concat(source.allergienames,'*',source.allergy_name), case
 when source.allergienames='' THEN source.allergy_name
 when source.allergienames is not null THEN source.allergienames 
 when source.allergienames is null and source.allergy_name is null THEN null end::text ,'name',target.name,null),	
('allergienames',concat(source.allergienames,'_',source.allergy_name), case
 when source.allergienames ='' THEN source.allergy_name
 when source.allergienames is not null THEN source.allergienames 
 when source.allergienames is null and source.allergy_name is null THEN null end::text ,'drfirstname',target.drfirstname,null),						
('ndcid',source.ndcid,source.ndcid,'drfirstndcid',target.drfirstndcid,null),
('allergy_id',source.allergy_id,case 
 when source.allergy_type='Rcopia_Allergy' THEN source.allergy_id
 when source.allergy_type !='Rcopia_Allergy' THEN '' 
 end::text,'drfirstrcopiaID',target.drfirstrcopiaID,null),
('rxnorm',source.rxnorm,source.rxnorm,'drfirstrxnormID',target.drfirstrxnormID,null),
('allergy_id',source.allergy_id,case 
 when source.allergy_type='Rcopia_Allergy' THEN source.allergy_id
 when source.allergy_type !='Rcopia_Allergy' THEN '' 
 end::text,'rcopiaId'
 ,target.rcopiaId,null),					
('reaction',source.reaction,source.reaction,'reaction',target.reaction,null),
('rxnorm',source.rxnorm,source.rxnorm,'rxNormId',target.rxNormId,null),					
('severity',source.severity,source.severity,'severity',target.severity,null),										
('no_drug_allergy',source.no_drug_allergy::text,source.no_drug_allergy::text,'noDrugAllergy',target.noDrugAllergy::text,null)					
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
