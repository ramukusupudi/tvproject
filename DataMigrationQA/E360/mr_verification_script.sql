DELETE FROM source_target_match WHERE  source_datasetId = 'mr';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'mr' as source_datasetId,
  CONCAT(source.uid,'_mr') as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_exam_mr as source
FULL JOIN v_migrated_mr as target ON CONCAT(source.uid,'_mr') = target.source_instanceId
CROSS JOIN LATERAL (VALUES
--('uid',source.uid,source.uid,'source_instanceId', target.source_instanceId,null),
--('patient',source.patient,source.patient,'patient_id ', target.patient_id,null),
--('date',source.date::text,source.date::text,'appointmentDate ', target.appointmentDate,null),
('manifest_acuity_d_od',source.manifest_acuity_d_od,CASE 
 	WHEN source.manifest_acuity_d_od = '/null/' OR source.manifest_acuity_d_od is null THEN ''
    else source.manifest_acuity_d_od
 	end,'OD_va ', target.OD_va,null),
('manifest_axis_od',source.manifest_axis_od,CASE 
 	WHEN source.manifest_axis_od = '/null/' OR source.manifest_axis_od is null THEN ''
    else source.manifest_axis_od
 	end,'OD_axis', target.OD_axis,null),
('manifest_sph_od',source.manifest_sph_od,CASE 
 	WHEN source.manifest_sph_od = '/null/' OR source.manifest_sph_od is null THEN ''
    else source.manifest_sph_od
 	end,'OD_sphere', target.OD_sphere,null),
('manifest_cyl_od',source.manifest_cyl_od,CASE 
 	WHEN source.manifest_cyl_od = '/null/' OR source.manifest_cyl_od is null THEN ''
    else source.manifest_cyl_od
 	end,'OD_cylindrical', target.OD_cylindrical,null),
('manifest_acuity_d_os',source.manifest_acuity_d_os,CASE 
 	WHEN source.manifest_acuity_d_os = '/null/' OR source.manifest_acuity_d_os is null THEN ''
    else source.manifest_acuity_d_os
 	end,'OS_va', target.OS_va,null),
('manifest_axis_os',source.manifest_axis_os,CASE 
 	WHEN source.manifest_axis_os = '/null/' OR source.manifest_axis_os is null THEN ''
    else source.manifest_axis_os
 	end,'OS_axis', target.OS_axis,null),
('manifest_sph_os',source.manifest_sph_os,CASE 
 	WHEN source.manifest_sph_os = '/null/' OR source.manifest_sph_os is null THEN ''
    else source.manifest_sph_os
 	end,'OS_sphere', target.OS_sphere,null),
('manifest_cyl_os',source.manifest_cyl_os,CASE 
 	WHEN source.manifest_cyl_os = '/null/' OR source.manifest_cyl_os is null THEN ''
    else source.manifest_cyl_os
 	end,'OS_cylindrical', target.OS_cylindrical,null),
('amp',source.amp,CASE 
 	WHEN source.amp = '/null/' OR source.amp is null THEN ''
    else source.amp
 	end,'amp', target.amp,null),
('nra',source.nra,CASE 
 	WHEN source.nra = '/null/' OR source.nra is null THEN ''
    else source.nra
 	end,'nra', target.nra,null),
('pra',source.pra,CASE 
 	WHEN source.pra = '/null/' OR source.pra is null THEN ''
    else source.pra
 	end,'pra', target.pra,null),
('manifest_notes',source.manifest_notes,CASE 
 	WHEN source.manifest_notes = '/null/' OR source.manifest_notes is null THEN ''
    else source.manifest_notes
 	end,'notes', target.notes,null),
('manifest_prism_od',source.manifest_prism_od,CASE 
 	WHEN source.manifest_prism_od = '/null/' OR source.manifest_prism_od is null THEN ''
    else source.manifest_prism_od
 	end,'prism_od', target.prism_od,null),					
('manifest_prism_os',source.manifest_prism_os,CASE 
 	WHEN source.manifest_prism_os = '/null/' OR source.manifest_prism_os is null THEN ''
    else source.manifest_prism_os
 	end,'prism_os', target.prism_os,null)					
															
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;

/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
group by source_datasetId, source_field, target_field, matched, notes

select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
where matched = false
group by source_datasetId, source_field, target_field, matched, notes

select Distinct target_field from source_target_match where matched=false 
*/