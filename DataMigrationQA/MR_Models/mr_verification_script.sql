DELETE FROM source_target_match
WHERE  source_datasetId = 'MR';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'MR' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_mr as source
FULL JOIN v_migrated_mr as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('uid',source.uid,source.uid,'source_instanceId', target.source_instanceId,null),
('patient',source.patient,source.patient,'patient_id ', target.patient_id,null),
('date',source.date::text,source.date::text,'appointmentDate ', target.appointmentDate,null),
('manifest_acuity_d_od',source.manifest_acuity_d_od,source.manifest_acuity_d_od,'OD_va ', target.OD_va,null),
('manifest_axis_od',source.manifest_axis_od,source.manifest_axis_od,'OD_axis', target.OD_axis,null),
('manifest_sph_od',source.manifest_sph_od,source.manifest_sph_od,'OD_sphere', target.OD_sphere,null),
('manifest_cyl_od',source.manifest_cyl_od,source.manifest_cyl_od,'OD_cylindrical', target.OD_cylindrical,null),
('manifest_acuity_d_os',source.manifest_acuity_d_os,source.manifest_acuity_d_os,'OS_va', target.OS_va,null),
('manifest_axis_os',source.manifest_axis_os,source.manifest_axis_os,'OS_axis', target.OS_axis,null),
('manifest_sph_os',source.manifest_sph_os,source.manifest_sph_os,'OS_sphere', target.OS_sphere,null),
('manifest_cyl_os',source.manifest_cyl_os,source.manifest_cyl_os,'OS_cylindrical', target.OS_cylindrical,null),
--(' ',source.,source.,'OU_vad', target.OU_vad,null),
('amp',source.amp,source.amp,'amp', target.amp,null),
--(' ',source.,source.,'bxc', target.bxc,null),
('nra',source.nra,source.nra,'nra', target.nra,null),
('pra',source.pra,source.pra,'pra', target.pra,null),
('manifest_notes',source.manifest_notes,source.manifest_notes,'notes', target.notes,null)					
					
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