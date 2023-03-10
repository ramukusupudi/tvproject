--DELETE FROM source_target_match WHERE  source_datasetId = 'fundus';
--select * FROM source_target_match WHERE  source_datasetId = 'fundus' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'fundus' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_fundus as source
FULL JOIN v_migrated_fundus as target ON CONCAT(source.uid,'_fundus') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('slx_antvit_od',source.slx_antvit_od, case 
                                        when source.slx_antvit_od ='/null/' THEN ''
 										when source.slx_antvit_od ='' THEN ''
 			                   			when source.slx_antvit_od is null THEN '' 
         								when source.slx_antvit_od is not null THEN source.slx_antvit_od end::text ,'vitreous.OD.notes',target.vitreous_od_notes,null),
('internal_cd_od',source.internal_cd_od,case 
          when source.internal_cd_od ='/null/' THEN ''
          when source.internal_cd_od is null THEN '' 
          when source.internal_cd_od = '' THEN '' 
          when source.internal_cd_od is not null THEN source.internal_cd_od end::text ,'vitreous.OD.cupDiscRatio.value1',target.vitreous_od_cupdiscratio,null),
('slx_antvit_os',source.slx_antvit_os, case
 										when source.slx_antvit_os ='/null/' THEN ''
 										when source.slx_antvit_os ='' THEN ''
 			                   			when source.slx_antvit_os is null THEN '' 
         								when source.slx_antvit_os is not null THEN source.slx_antvit_od end::text,'vitreous.OS.notes',target.vitreous_os_notes,null),
('internal_cd_os',source.internal_cd_os,case
       when source.internal_cd_os ='/null/' THEN '' 
       when source.internal_cd_os is null THEN '' 
       when source.internal_cd_os is not  null THEN source.internal_cd_os 
 end::text,'vitreous.OS.cupDiscRatio.value1',target.vitreous_os_cupdiscratio,null),
('internal_disc_od',source.internal_disc_od, case 
 											when source.internal_disc_od ='/null/' THEN ''
 											when source.internal_disc_od is null THEN  ''
                                            when source.internal_disc_od is not null THEN source.internal_disc_od 
 end::text,'opticNerve.OD.notes',target.opticnerve_od_notes,null),
('internal_disc_os',source.internal_disc_os, case 
 											when source.internal_disc_os ='/null/' THEN ''
 											when source.internal_disc_os is null THEN ''
  											when source.internal_disc_os is not  null THEN source.internal_disc_os 
 end::text,'opticNerve.OS.notes',target.opticnerve_os_notes,null),
('maculaos_vesselsos_fundusos_periph',CONCAT(source.internal_macula_os::text,source.internal_vessels_os::text,source.internal_fundus_os::text,source.internal_periph_os::text),case 
when source.internal_macula_os ='/null/' and source.internal_vessels_os  ='/null/' and source.internal_fundus_os ='/null/' and source.internal_periph_os ='/null/' THEN '' 				
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os is null THEN '' 
when source.internal_macula_os ='/null/' and source.internal_vessels_os='/null' and source.internal_fundus_os ='/null'and source.internal_periph_os ='/null' THEN '' 
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os ='/null' and source.internal_periph_os ='/null' THEN '' 
when source.internal_macula_os is null and source.internal_vessels_os='/null' and source.internal_fundus_os is null and source.internal_periph_os ='/null' THEN '' 
when source.internal_macula_os ='/null/' and source.internal_vessels_os is null and source.internal_fundus_os ='/null' and source.internal_periph_os ='/null' THEN '' 										
when source.internal_macula_os ='/null/' and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os ='/null' THEN ''  
when source.internal_macula_os ='/null/' and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os is null THEN ''  
when source.internal_macula_os ='/null/' and source.internal_vessels_os='/null' and source.internal_fundus_os ='/null'and source.internal_periph_os is null THEN '' 
when source.internal_macula_os ='/null/' and source.internal_vessels_os='/null' and source.internal_fundus_os is null and source.internal_periph_os ='/null' THEN '' 
when source.internal_macula_os is not null and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os is null THEN CONCAT('Macula:',source.internal_macula_os::text)
when source.internal_macula_os is null and source.internal_vessels_os is not null and source.internal_fundus_os is null and source.internal_periph_os is null THEN CONCAT('Vessels:',source.internal_vessels_os::text)
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os is not null and source.internal_periph_os is null THEN CONCAT('Fundus:', source.internal_fundus_od::text)
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os is not null THEN CONCAT('Periph:',source.internal_periph_os::text)
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os is null and source.internal_periph_os is null THEN ''
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is null and source.internal_periph_os is null THEN CONCAT('Macula:',source.internal_macula_os::text,'Vessels:',source.internal_vessels_os::text)
when source.internal_macula_os is null and source.internal_vessels_os is null and source.internal_fundus_os is not null and source.internal_periph_os is not null THEN CONCAT('Fundus:',source.internal_fundus_os::text,'Periph:',source.internal_periph_os::text)
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is null and source.internal_periph_os is not null THEN CONCAT('Macula:',source.internal_macula_os::text,'Vessels:',source.internal_vessels_os::text,'Periph:',source.internal_periph_os::text)
when source.internal_macula_os is not null and source.internal_vessels_os is null and source.internal_fundus_os is not null and source.internal_periph_os is not null THEN CONCAT('Macula:',source.internal_macula_os::text,'Fundus:', source.internal_fundus_od::text,'Periph:',source.internal_periph_os::text) 
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is null and source.internal_periph_os is not null THEN CONCAT('Macula:',source.internal_macula_os::text,'; Vessels:',source.internal_vessels_os::text,'Periph:',source.internal_periph_os::text) 
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is not null and source.internal_periph_os is null THEN CONCAT('Macula:',source.internal_macula_os::text,'; Vessels:',source.internal_vessels_os::text,'; Fundus:', source.internal_fundus_od::text)
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is not null and source.internal_periph_os ='/null/' THEN CONCAT('Macula:',source.internal_macula_os::text,'; Vessels:',source.internal_vessels_os::text,'; Fundus:', source.internal_fundus_od::text) 
when source.internal_macula_os is not null and source.internal_vessels_os is not null and source.internal_fundus_os is not null and source.internal_periph_os is not null THEN CONCAT('Macula:',source.internal_macula_os::text,'; Vessels:',source.internal_vessels_os::text,'; Fundus:', source.internal_fundus_os::text,'; Periph:',source.internal_periph_os::text) end::text,'retina.OS.notes',target.retina_os_notes,null),
('maculaod_vesselsod_fundusod_periph', CONCAT(source.internal_macula_od::text,source.internal_vessels_od::text,source.internal_fundus_od::text,source.internal_periph_od::text),
 case when source.internal_macula_od::text ='/null/'and source.internal_vessels_od::text='/null/'and source.internal_fundus_od::text='/null/'and source.internal_periph_od::text='/null/'  THEN ''
       when source.internal_macula_od::text ='/null/'and source.internal_vessels_od::text='/null/'and source.internal_fundus_od::text='/null/'and source.internal_periph_od::text is null  THEN ''
       when source.internal_macula_od='' and source.internal_vessels_od =''and source.internal_fundus_od =''and source.internal_periph_od =''  THEN ''
       when source.internal_macula_od is null and source.internal_vessels_od is null and source.internal_fundus_od is null and source.internal_periph_od is null  THEN ''
       when source.internal_macula_od::text is not null and source.internal_vessels_od::text is not null and source.internal_fundus_od::text is not null and source.internal_periph_od::text is null THEN CONCAT('Macula:',source.internal_macula_od::text,'; Vessels:',source.internal_vessels_od::text,'; Fundus:',source.internal_fundus_od::text)
       when source.internal_macula_od::text is not null and source.internal_vessels_od::text is not null and source.internal_fundus_od::text is not null and source.internal_periph_od::text='/null/' THEN CONCAT('Macula:',source.internal_macula_od::text,'; Vessels:',source.internal_vessels_od::text,'; Fundus:',source.internal_fundus_od::text)
      when source.internal_macula_od::text is not null and source.internal_vessels_od::text is not null and source.internal_fundus_od::text is not null and source.internal_periph_od::text is not null THEN CONCAT('Macula:',source.internal_macula_od::text,'; Vessels:',source.internal_vessels_od::text,'; Fundus:',source.internal_fundus_od::text,'; Periph:',source.internal_periph_od::text)end::text,'retina.OD.notes',target.retina_od_notes,null)										
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;