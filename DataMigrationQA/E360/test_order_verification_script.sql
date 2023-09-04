DELETE FROM source_target_match WHERE  source_datasetId = 'test_order';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'test_order' as source_datasetId,
  CONCAT(source.uid,'_test_order') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id,match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM public.v_source_exam_test_order as source
FULL JOIN public.v_migrated_testorder as target ON CONCAT(source.uid,'_test_order') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
                                        
--('patient_src',source.patient_src::text,source.patient_src::text,patient_sourceId,target.patient_sourceId,null),
('date',source.date::text,TO_CHAR(source.date::date, 'MM/DD/YYYY'),'AppointmentDate',target.AppointmentDate,null),

('patient_targetId', target.patient_id, target.patient_id,'order_patient_id', target.order_patient_id, null),
('date', source.date::text, TO_CHAR(source.date::date, 'MM/DD/YYYY'),'startdate', target.startdate, null),
('type', source.type, CASE 
         WHEN source.type= 'com.foxparksoftware.growemr.examsheet.clarkson.CornealTopographySheet' THEN '01348458-2f3f-4c17-ab74-e7c28061ce8b'
     WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.DarkAdaptationSheet' THEN '0b50650c-fdae-4e16-87b4-d7e050bf086a'
          WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt ='92285' THEN '0ef82f74-59c9-4bc0-8b1e-d684805ca04d'
         WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' THEN '17c9de8b-49f6-4f01-8b2f-4e25582ca388'
     WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92134' THEN 'b49b71d9-9ece-4b48-bc5d-be178d917f6b'
          WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133' THEN 'b75736ec-d447-467c-a14d-9824824a5e36'
          WHEN source.type='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt='92250' THEN 'bbf89106-349c-47fa-a6d1-e9ed0be0a268'
     END,'testtypeid', target.testtypeid, null),
('emp_id', target.employee_id, target.employee_id,'technicianid', target.technicianid, null),
('provider_id', target.provider_id, target.provider_id,'orderingproviderid', target.orderingproviderid, null),
('oct_thickness_od', source.oct_thickness_od, CASE
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92134' AND source.oct_thickness_od !='/null/' THEN  source.oct_thickness_od
         WHEN source.oct_thickness_od = '/null/' OR source.oct_thickness_od IS NULL THEN ''
    ELSE NULL
         END,'od_cst', target.od_cst, null),
('oct_interpretation_oct_report', CONCAT(source.oct_interpretation,',',source.oct_report), CASE
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92134'  AND 
     source.oct_interpretation IS NOT NULL AND source.oct_interpretation !='/null/'  AND 
    source.oct_report IS NOT NULL AND source.oct_report !='/null/' THEN 
    CONCAT('Interpretation:',REPLACE(source.oct_interpretation,'\\n','\n'),'; Report:',source.oct_report)
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND
   (source.oct_interpretation IS NULL OR source.oct_interpretation='/null/') AND 
    source.oct_report IS NOT NULL AND source.oct_report !='/null/'   THEN 
    CONCAT('Report:',source.oct_report)
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND 
    source.oct_interpretation IS NOT NULL AND source.oct_interpretation !='/null/'  AND 
    (source.oct_report IS NULL OR source.oct_report='/null/' ) THEN 
    CONCAT('Interpretation:',REPLACE(source.oct_interpretation,'\\n','\n'))
        ELSE NULL
         END,'retina_od_interpretationnotes', target.retina_od_interpretationnotes, null),
('oct_thickness_os', source.oct_thickness_os, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92134' AND source.oct_thickness_os !='/null/' THEN source.oct_thickness_os
         WHEN source.oct_thickness_os = '/null/' OR source.oct_thickness_os IS NULL THEN ''
         ELSE NULL
         END,'os_cst', target.os_cst, null),
('vf_is_normal_od', source.vf_is_normal_od, CASE 
         WHEN  source.vf_is_normal_od = 'TRUE' AND source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' THEN 'True'
         WHEN  source.vf_is_normal_od = 'FALSE' AND source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' THEN 'False'
    ELSE NULL
         END,'od_normal', target.od_normal, null),
('vf_test_type_cpt', CONCAT(source.vf_test_type,',',source.cpt), CASE 
         WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' AND source.vf_test_type IS NOT NULL AND source.cpt IS NOT NULL THEN 
    CONCAT('Humphrey ',source.vf_test_type,' ',source.cpt)
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' AND source.vf_test_type IS NULL AND source.cpt IS NOT NULL THEN 
    source.cpt
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' AND source.vf_test_type IS NOT NULL AND source.cpt IS NULL THEN 
    CONCAT('Humphrey ',source.vf_test_type)
        ELSE NULL
    END,'test', target.test, null),
('photo_description_od', source.photo_description_od, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt='92250' AND
    source.photo_description_od !='/null/' THEN  REPLACE(source.photo_description_od,'\\n','\n')
         WHEN source.photo_description_od ='/null/' THEN ''
         ELSE NULL
         END,'od_notes', target.od_notes, null),
('photo_description_os', source.photo_description_os, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt='92250' AND
    source.photo_description_os !='/null/' THEN REPLACE(source.photo_description_os,'\\n','\n')
         WHEN source.photo_description_os ='/null/' THEN ''
         ELSE NULL
         END,'os_notes', target.os_notes, null),
('oct_interpretation_oct_report', CONCAT(source.oct_interpretation,',',source.oct_report), CASE 
        WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133' AND
    source.oct_interpretation IS NOT NULL AND source.oct_report IS NOT NULL AND 
    source.oct_interpretation !='/null/' AND source.oct_report !='/null/' THEN 
    CONCAT('Interpretation:',REPLACE(source.oct_interpretation,'\\n','\n'),'; Report:',source.oct_report)
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133'AND 
    source.oct_report IS NOT NULL AND source.oct_report !='/null/' THEN 
    CONCAT('Report:',source.oct_report)
    WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133'AND
    source.oct_interpretation IS NOT NULL AND source.oct_interpretation !='/null/' THEN 
    CONCAT('Interpretation:',REPLACE(source.oct_interpretation,'\\n','\n'))
        ELSE NULL
    END,'octoptic_od_notes', target.octoptic_od_notes, null),
('oct_thickness_od', source.oct_thickness_od, CASE 
         WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133' AND source.oct_thickness_od != '/null/' THEN source.oct_thickness_od
         WHEN source.oct_thickness_od = '/null/' THEN ''
    ELSE NULL
         END,'od_averagethickness', target.od_averagethickness, null),
('oct_thickness_os', source.oct_thickness_os, CASE 
         WHEN source.type = 'com.foxparksoftware.growemr.examsheet.clarkson.OCTSheet' AND source.cpt='92133' AND source.oct_thickness_os !='/null/' THEN source.oct_thickness_os
         WHEN source.oct_thickness_os = '/null/' THEN ''
    ELSE NULL
         END,'os_averagethickness', target.os_averagethickness, null),
('photo_description_od', source.photo_description_od, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt='92285' THEN source.photo_description_od
    WHEN source.photo_description_od = '/null/' THEN ''
         ELSE NULL
         END,'od_interpretationnotes', target.od_interpretationnotes, null),
('photo_description_os', source.photo_description_os, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.PhotosSheet' AND source.cpt='92285' THEN source.photo_description_os
         WHEN source.photo_description_os = '/null/' THEN ''
    ELSE NULL
         END,'os_interpretationnotes', target.os_interpretationnotes, null),
('oct_interpretation', source.oct_interpretation, CASE 
 WHEN source.oct_interpretation ='/null/' THEN NULL
 ELSE source.oct_interpretation
 END,'doctorinterpretation', target.doctorinterpretation, null),
('assessment_od', source.assessment_od, CASE 
         WHEN source.assessment_od ='/null/' THEN NULL
         ELSE source.assessment_od
         END,'assessment_od', target.assessment_od, null),
('assessment_os', source.assessment_os, CASE 
         WHEN source.assessment_os ='/null/' THEN NULL
         ELSE REPLACE (source.assessment_os,'\\n','\n')
         END,'assessment_os', target.assessment_os, null),
('add_reason', source.add_reason, REPLACE(source.add_reason,'\\n','\n'),'assessment_notes', target.assessment_notes, null),
('vf_test_reliability_od', source.vf_test_reliability_od, CASE
        WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' THEN source.vf_test_reliability_od
    WHEN source.vf_test_reliability_od ='/null/'  THEN NULL
         ELSE NULL
         END,'testreliability_od', target.testreliability_od, null),
('vf_test_reliability_os', source.vf_test_reliability_os, CASE
        WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.VisualFieldsSheet' THEN source.vf_test_reliability_os
         WHEN source.vf_test_reliability_os ='/null/'  THEN NULL
         ELSE NULL
         END,'testreliability_os', target.testreliability_os, null),                                        
('ct_notes_od', source.ct_notes_od, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.CornealTopographySheet' THEN source.ct_notes_od
         ELSE NULL
         END,'cornealtopography_od_notes', CASE 
         WHEN target.cornealtopography_od_notes::text ='""' THEN NULL
         ELSE target.cornealtopography_od_notes::text
         END, null),
('ct_notes_os', source.ct_notes_os, CASE 
         WHEN source.type ='com.foxparksoftware.growemr.examsheet.clarkson.CornealTopographySheet' THEN source.ct_notes_os
         ELSE NULL
         END,'cornealtopography_os_notes',  CASE 
         WHEN target.cornealtopography_os_notes::text ='""' THEN NULL
         ELSE target.cornealtopography_os_notes::text
         END,null)                                        
                                        
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;                                        