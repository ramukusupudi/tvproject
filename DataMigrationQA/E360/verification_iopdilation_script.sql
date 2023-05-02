DELETE FROM source_target_match WHERE  source_datasetId = 'iopdilation';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'iopdilation' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_iop_dilation as source
FULL JOIN v_migrated_iopdilation as target ON CONCAT(source.uid,'_iopdilation') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('date',to_char(source.date,'MM/DD/YYYY'),case when source.date is null or source.date::text ='/null/' THEN '' else to_char(source.date,'MM/DD/YYYY') end::text,'iopdilation_iop_values_date',target.iopdilation_iop_values_date::text,null),
('date',to_char(source.date,'MM/DD/YYYY'),case when source.date is null or source.date::text ='/null/' THEN '' else to_char(source.date,'MM/DD/YYYY') end::text,'iopdilation_iop_values_date1',target.iopdilation_iop_values_date1::text,null),	
('date',to_char(source.date,'MM/DD/YYYY'),case when source.date is null or source.date::text ='/null/' THEN '' else to_char(source.date,'MM/DD/YYYY') end::text,'iopdilation_op_pachymetry_date',target.iopdilation_iop_pachymetry_date::text,null),										
('ta_od',source.ta_od, case when source.ta_od is null or source.ta_od::text='/null/' THEN '' else source.ta_od::text end::text ,'iopdilation_iop_values_od',target.iopdilation_iop_values_od::text,null),
('ta_od2',source.ta_od2,case when source.ta_od2 is null or source.ta_od2 ::text ='/null/' THEN '' else source.ta_od2::text end::text,'iopdilation_iop_values_od1',target.iopdilation_iop_values_od1::text,null),
('ta_os',source.ta_os,case when source.ta_os is null or source.ta_os::text='/null/' THEN '' else source.ta_os::text end::text ,'iopdilation_iop_values_os',target.iopdilation_iop_values_os,null),
('ta_os2',source.ta_os2,case when source.ta_os2 is null or source.ta_os2::text='/null/' THEN '' else source.ta_os2::text end::text,'iopdilation_iop_values_os1',target.iopdilation_iop_values_os1,null),
('ta_timestamp',source.ta_timestamp,case when source.ta_timestamp is null or source.ta_timestamp::text='/null/' THEN '' else source.ta_timestamp::text end::text,'iopdilation_iop_values_time',target.iopdilation_iop_values_time,null),
('ta_timestamp2',source.ta_timestamp2,case when source.ta_timestamp2 is null or source.ta_timestamp2::text='/null/' THEN '' else source.ta_timestamp2::text end::text ,'iopdilation_iop_values_time1',target.iopdilation_iop_values_time1,null),
('ta_notes',source.ta_notes,case when  source.ta_notes is null or source.ta_notes::text ='/null/' THEN '' else source.ta_notes::text end::text,'iopdilation_iop_values_notes',target.iopdilation_iop_values_notes,null),
('ta_notes2',source.ta_notes2,case when source.ta_notes2 is null or source.ta_notes2::text ='/null/' THEN '' else source.ta_notes2::text  end::text ,'iopdilation_iop_values_notes1',target.iopdilation_iop_values_notes1,null),
('ta_type',source.ta_type,case when source.ta_type is null or source.ta_type::text='/null/' THEN ''  
                               when source.ta_type::text ='Goldmann' THEN 'Applanation' 
 							   when source.ta_type::text ='Icare' THEN    'Pneumatic'
 							   when source.ta_type::text ='NCT' THEN      'Puff'
 							   when source.ta_type::text ='Palp' THEN     'Tactile'
 							   when source.ta_type::text ='Tonopen' THEN  'Tonopen'	
 end::text,'iopdilation_iop_values_method',target.iopdilation_iop_values_method,null),
('ta_type2',source.ta_type2,case when source.ta_type2 is null or source.ta_type2 ='/null/' THEN ''
                               when source.ta_type2::text ='Goldmann' THEN 'Applanation' 
 							   when source.ta_type2::text ='Icare' THEN    'Pneumatic'
 							   when source.ta_type2::text ='NCT' THEN      'Puff'
 							   when source.ta_type2::text ='Palp' THEN     'Tactile'
 							   when source.ta_type2::text ='Tonopen' THEN  'Tonopen'
 end::text,'iopdilation_iop_values_method1',target.iopdilation_iop_values_method1,null),					
('pach_od',source.pach_od,case when source.pach_od is null or source.pach_od::text ='/null/' THEN '' else source.pach_od end::text,'iopdilation_iop_pachymetry_od',target.iopdilation_iop_pachymetry_od,null),
('pach_os',source.pach_os,case when source.pach_os is null or source.pach_os::text ='/null/' THEN '' else source.pach_os end::text,'iopdilation_iop_pachymetry_os',target.iopdilation_iop_pachymetry_os,null),
('adj_od',source.adj_od, case when source.adj_od is null or source.adj_od::text ='/null/' THEN '' else source.adj_od::text end::text,'iopdilation_iop_adjustediop_od',target.iopdilation_iop_adjustediop_od,null),					
('adj_os',source.adj_os, case when source.adj_os is null or source.adj_os::text ='/null/' THEN '' else source.adj_os::text end::text,'iopdilation_iop_adjustediop_os',target.iopdilation_iop_adjustediop_os,null)
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;