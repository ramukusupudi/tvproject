DELETE FROM source_target_match WHERE  source_datasetId = 'systemic_medication_history';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'systemic_medication_history' as source_datasetId,
  CONCAT(source.uid,'_systemic_medication_history') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_exam_systemic_medication_history as source
FULL JOIN v_migrated_systemic_medication_history as target ON CONCAT(source.uid,'_systemic_medication_history') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
					
--('patient_src',source.patient_src::text,source.patient_src::text,patient_sourceId,target.patient_sourceId,null),
('patient_targetId',target.patient_id::text,target.patient_id::text,'patient_tableId',target.patient_targetId,null),
('date',source.date::text,TO_CHAR(source.date::date, 'MM/DD/YYYY'),'AppointmentDate',target.AppointmentDate,null),					
('dose',source.sysmedications_json->0->>'drug_prescriptions.dose', CASE 
  WHEN source.sysmedications_json->0->>'drug_prescriptions.dose' = '' THEN NULL
  ELSE source.sysmedications_json->0->>'drug_prescriptions.dose'
  END, 'dose', CASE 
 	WHEN target.dose = '' THEN NULL
 	ELSE target.dose
 	END,null),
('d_units',source.sysmedications_json->0->>'drug_prescriptions.dose_units', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.dose_units' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.dose_units'
    END, 'unit', CASE 
         WHEN target.unit = '' THEN NULL
         ELSE target.unit
         END,null),
--('route',source.sysmedications_json->0->>'drug_prescriptions.dose', source.sysmedications_json->0->>'drug_prescriptions.dose', 'route', target.route,null),
('strength',source.sysmedications_json->0->>'drug_prescriptions.strength', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.strength' ='' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.strength'
         END , 'dosage', CASE 
         WHEN target.dosage = '' THEN NULL
          ELSE target.dosage 
          END,null),
('invalid',source.sysmedications_json->0->>'drug_prescriptions.invalid', CASE
         WHEN source.sysmedications_json->0->>'drug_prescriptions.invalid' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.invalid'
         END, 'status', CASE 
         WHEN target.status ='' THEN NULL
         ELSE target.status
         END,null),
('form',source.sysmedications_json->0->>'drug_prescriptions.form', CASE
         WHEN source.sysmedications_json->0->>'drug_prescriptions.form' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.form'
         END, 'drfirst.form', CASE 
         WHEN target.form = '' THEN NULL
         ELSE target.form
          END,null),
('drugs.name',source.sysmedications_json->0->>'drugs.name', CASE
         WHEN source.sysmedications_json->0->>'drugs.name' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drugs.name'
         END, 'drfirst.name', CASE 
         WHEN target.name = '' THEN NULL
         ELSE target.name
         END,null),
('ndcid',source.sysmedications_json->0->>'drug_prescriptions.ndcid', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.ndcid' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.ndcid'
         END, 'ndcid',CASE 
         WHEN target.ndcid = '' THEN NULL
         ELSE target.ndcid
    END,null),
--('strength',source.sysmedications_json->0->>'drug_prescriptions.dose', source.sysmedications_json->0->>'drug_prescriptions.dose', 'drfirst.strength', target.drfirst.strength,null),
('route_code',source.sysmedications_json->0->>'drug_prescriptions.route_code', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.route_code' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.route_code'
         END,'routeCode', CASE 
         WHEN target.routeCode = '' THEN NULL
         ELSE target.routeCode
         END,null),
('refills',source.sysmedications_json->0->>'drug_prescriptions.refills', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.refills' = '' THEN NULL
    ELSE source.sysmedications_json->0->>'drug_prescriptions.refills'
         END, 'refills', CASE 
         WHEN target.refills = '' THEN NULL
         ELSE target.refills
         END,null),
('dose_units',source.sysmedications_json->0->>'drug_prescriptions.dose_units', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.dose_units' ='' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.dose_units'
         END, 'doseUnit',CASE 
         WHEN target.doseUnit = '' THEN NULL
         END,null),
('duration',source.sysmedications_json->0->>'drug_prescriptions.duration', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.duration' = '' THEN NULL
    ELSE source.sysmedications_json->0->>'drug_prescriptions.duration'
    END, 'duration', CASE 
         WHEN target.duration ='' THEN NULL
         ELSE target.duration 
         END,null),
('quantity',source.sysmedications_json->0->>'drug_prescriptions.quantity', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.quantity' ='' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.quantity'
         END, 'quantity', CASE 
         WHEN target.quantity ='' THEN NULL
         ELSE target.quantity
         END,null),
('stop_date',source.sysmedications_json->0->>'drug_prescriptions.stop_date', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.stop_date' = '' THEN NULL
         ELSE TO_CHAR((source.sysmedications_json->0->>'drug_prescriptions.stop_date')::date, 'MM/DD/YYYY')
         END, 'stopDate', CASE 
         WHEN target.stopDate = '' THEN NULL
         ELSE target.stopDate
         END,null),
('frequency',source.sysmedications_json->0->>'drug_prescriptions.frequency', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.frequency' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.frequency'
         END, 'frequency', CASE 
         WHEN target.frequency ='' THEN NULL
         ELSE target.frequency 
         END,null),
('start_date',source.sysmedications_json->0->>'drug_prescriptions.start_date', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.start_date' = '' THEN NULL
         ELSE TO_CHAR((source.sysmedications_json->0->>'drug_prescriptions.start_date')::date, 'MM/DD/YYYY')
         END, 'startDate', CASE 
         WHEN target.startDate = '' THEN NULL
         ELSE target.startDate
         END,null),
('quantity_units',source.sysmedications_json->0->>'drug_prescriptions.quantity_units', CASE 
         WHEN source.sysmedications_json->0->>'drug_prescriptions.quantity_units' = '' THEN NULL
         ELSE source.sysmedications_json->0->>'drug_prescriptions.quantity_units'
         END, 'quantityUnit', CASE 
         WHEN target.quantityUnit = '' THEN NULL
         ELSE target.quantityUnit
         END,null),
('no_medications',source.no_medications::text, source.no_medications::text, 'noMedications', target.noMedications,null)
					
					
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;	

--select sysmedications_json from public.v_source_exam_systemic_medication_history
--Limit 1