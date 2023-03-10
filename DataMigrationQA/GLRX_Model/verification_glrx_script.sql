--DELETE FROM source_target_match WHERE  source_datasetId = 'glrx';
select * FROM source_target_match WHERE  source_datasetId = 'glrx' and matched ='FALSE' and target_value is not null
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'glrx' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_exam_glrx as source
FULL JOIN v_migrated_glrx as target ON CONCAT(source.uid,'_glrx') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('patientsrc',source.patientsrc,source.patientsrc,'patient_id',target.patient_id,null),
--('date',source.date,source.date,'appointmentdate',target.appointmentdate,null),
('r_add',source.r_add, case 
 when source.r_add is null THEN ''
 when source.r_add is not null THEN source.r_add end::text,'glrx.od.add',target.glrx_od_add,null),
('r_axis',source.r_axis, case when source.r_axis is null THEN ''
 							  when source.r_axis is not null THEN source.r_axis end::text,'glrx.od.axis',target.glrx_od_axis,null),
('r_sph',source.r_sph, case when source.r_sph is not null THEN source.r_sph
 					        when source.r_sph is null THEN '' end::text,'glrx.od.sphere',target.glrx_od_sphere,null),
('r_cyl',source.r_cyl, case when source.r_cyl is not null THEN source.r_cyl
 							when source.r_cyl is null THEN '' end::text,'glrx.od.cylinder',target.glrx_od_cylinder,null),
('l_add',source.l_add, case when source.l_add is not null THEN source.l_add
 							when source.l_add is null THEN '' end::text,'glrx.os.add',target.glrx_os_add,null),
('l_axis',source.l_axis,case when source.l_axis is not null THEN source.l_axis
							 when source.l_axis is null THEN '' end::text,'glrx.os.axis',target.glrx_os_axis,null),
('l_sph',source.l_sph, case when source.l_sph is not null THEN source.l_sph
 							when source.l_sph is null THEN '' end::text,'glrx.os.sphere',target.glrx_os_sphere,null),
('l_cyl',source.l_cyl, case when source.l_cyl is not null THEN source.l_cyl
 						    when source.l_cyl is null THEN '' end::text,'glrx.os.cylinder',target.glrx_os_cylinder,null),
('type',source.type, case when source.type is not null THEN source.type
 						  when source.type is null THEN '' end::text,'glrx.type',target.glrx_type,null),	
('notes',source.notes,case when source.notes is not null THEN source.notes
 						 when source.notes is null THEN '' end::text,'glrx.notes',target.glrx_notes,null),
('r_prism',source.r_prism, case when source.r_prism is not null THEN source.r_prism 
 								when source.r_prism is null THEN '' end::text,'glrx.prism.od.p1',target.glrx_prism_od_p1,null),	
('l_prism',source.l_prism, case when source.l_prism is not null THEN source.l_prism
 								when source.l_prism is null THEN ''end::text,'glrx.prism.os.p1',target.glrx_prism_os_p1,null),
('expiration_reason',source.expiration_reason,case when source.expiration_reason is not null THEN source.expiration_reason
 													when source.expiration_reason is null THEN '' end::text,'glrx.changeReason',target.glrx_changereason,null),
('expiration_date',to_char(source.expiration_date, 'MM/DD/YYYY'),CASE 
 	WHEN source.expiration_date is null OR source.expiration_date::text = '/null/' THEN ''
 	else to_char(source.expiration_date, 'MM/DD/YYYY') end::text,'glrx.expirationDate',target.glrx_expirationdate,null)									
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;