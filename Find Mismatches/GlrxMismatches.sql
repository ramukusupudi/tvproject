DELETE FROM source_target_match
WHERE  source_datasetId = 'prescriptions';

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
								 target_field, target_value, matched, notes)
SELECT 
  'prescriptions' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM prescriptions as source
FULL JOIN v_migrated_glrx as target ON source.uid = target.instanceid
CROSS JOIN LATERAL (VALUES
					
	('systemCode','e360'::text,'e360'::text,'systemCode', target.systemCode, null),
    ('datasetType','table'::text,'table'::text,'datasetType', target.datasetType, null),
    ('datasetId','prescriptions'::text,'prescriptions'::text,'datasetId', target.datasetId, null),
    ('sourceUid',source.uid::text,source.uid::text,'targetUid', target.instanceid, null),
    ('sourceDate',source.date::text,source.date::text,'targetDate', target.appointmentdate::text, null),
    ('sourceR_add',source.r_add::text,source.r_add::text,'targetR_add', target.odadd, null),
    ('sourceR_axis',source.r_axis::text,source.r_axis::text,'targetR_axis', target.odaxis, null),
    ('sourceR_sph',source.r_sph::text,source.r_sph::text,'targetR_sph', target.odsph, null),
    ('sourceR_cyl',source.r_cyl::text,source.r_cyl::text,'targetR_cyl', target.odcyl, null),
    ('sourceL_add',source.l_add::text,source.l_add::text,'targetL_add', target.osadd, null),
    ('sourceL_axis',source.l_axis::text,source.l_axis::text,'targetL_axis', target.osaxis, null),
    ('sourceL_sph',source.l_sph::text,source.l_sph::text,'targetL_sph', target.ossph, null),
    ('sourceL_cyl',source.l_cyl::text,source.l_cyl::text,'targetL_cyl', target.oscyl, null),
    ('sourceType',source.type::text,source.type::text,'targetType', target.type, null),
    ('sourceNotes',source.notes::text,source.notes::text,'targetNotes', target.notes, null),
    ('sourceR_prism1',source.r_prism::text,source.r_prism::text,'targetR_prism1', target.odprism1, null),
    ('sourceL_prism1',source.l_prism::text,source.l_prism::text,'targetL_prism1', target.osprism1, null),
    ('sourceStartdate',source.date::text,source.date::text,'targetStartdate', target.startdate::text, null),
	('sourceExpiration_reason',source.expiration_reason::text,source.expiration_reason::text,'targetExpiration_reason', target.changereason, null),			
    ('sourceExpiration_date',source.expiration_date::text,source.expiration_date::text,'targetExpiration_date', target.expirationdate::text, null)

				
					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
where  target.instanceid is not null
;
/*
select source_datasetId, source_field, target_field, matched, notes, count(*)
from source_target_match
WHERE  source_datasetId = 'prescriptions'
group by source_datasetId, source_field, target_field, matched, notes
order by source_field, matched

select * from source_target_match
where source_field = 'sourceExpiration_reason'
and source_datasetid = 'prescriptions'

and matched is false

*/
