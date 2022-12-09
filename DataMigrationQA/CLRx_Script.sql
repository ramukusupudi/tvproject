--CLRx Script
--select * from v_source_CLRx
--select * from v_migrated_CLRx;
--Select * from source_target_match WHERE  source_datasetId = 'CLRx';
--DELETE FROM source_target_match WHERE  source_datasetId = 'CLRx';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'CLRx' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_CLRx as source
FULL JOIN v_migrated_CLRx as target ON CONCAT(source.patient,'_',source.insurance)  = target.source_instanceId
CROSS JOIN LATERAL (VALUES
('trial',source.trial,source.trial,'od_t',target.od_t,null),
('r_bc',source.r_bc,source.r_bc,'od_bc',target.od_bc,null),
('r_add',source.r_add,source.r_add,'od_add',target.od_add,null),
('r_bc2',source.r_bc2,source.r_bc2,'od_bc2',target.od_bc2,null),
('r_axis',source.r_axis,source.r_axis,'od_axis',target.od_axis,null),
('r_diameter',source.r_diameter,source.r_diameter,'od_diam',target.od_diam,null),
('contacts.sku',source.contacts.sku,source.contacts.sku,'od_lens_sku',target.od_lens_sku,null),
('contacts.name',source.contacts.name,source.contacts.name,'od_lens_name',target.od_lens_name,null),
('contacts.style',source.contacts.style,source.contacts.style,'od_lens_style',target.od_lens_style,null),
('contacts.mfg',source.contacts.mfg,source.contacts.mfg,'od_lens_manufacturer',target.od_lens_manufacturer,null),
('r_color',source.r_color,source.r_color,'od_color',target.od_color,null),
('r_seg',source.r_seg,source.r_seg,'od_segHt',target.od_segHt,null),
('r_addon',source.r_addon,source.r_addon,'od_addOns',target.od_addOns,null),
('r_power',source.r_power,source.r_power,'od_power1',target.od_power1,null),
('r_power2',source.r_power2,source.r_power2,'od_power2',target.od_power2,null),
('r_cyl',source.r_cyl,source.r_cyl,'od_cylinder',target.od_cylinder,null),
('r_material',source.r_material,source.r_material,'od_material',target.od_material,null),
('r_oz',source.r_oz,source.r_oz,'od_opticZone',target.od_opticZone,null),
('r_thickness',source.r_thickness,source.r_thickness,'od_thickness',target.od_thickness,null),
('r_intermediate',source.r_intermediate,source.r_intermediate,'od_intermCurve',target.od_intermCurve,null),
('r_periph',source.r_periph,source.r_periph,'od_periphCurve',target.od_periphCurve,null),
('l_bc',source.l_bc,source.l_bc,'os_bc',target.os_bc,null),
('l_add',source.l_add,source.l_add,'os_add',target.os_add,null),
('l_bc2',source.l_bc2,source.l_bc2,'os_bc2',target.os_bc2,null),
('l_axis',source.l_axis,source.l_axis,'os_axis',target.os_axis,null),
('l_diameter',source.l_diameter,source.l_diameter,'os_diam',target.os_diam,null),
('contacts.sku',source.contacts.sku,source.contacts.sku,'os_lens_sku',target.os_lens_sku,null),
('contacts.name',source.contacts.name,source.contacts.name,'os_lens_name',target.os_lens_name,null),
('contacts.style',source.contacts.style,source.contacts.style,'os_lens_style',target.os_lens_style,null),
('contacts.mfg',source.contacts.mfg,source.contacts.mfg,'os_lens_manufacturer',target.os_lens_manufacturer,null),
('l_color',source.l_color,source.l_color,'os_color',target.os_color,null),
('l_seg',source.l_seg,source.l_seg,'os_segHt',target.os_segHt,null),
('l_addon',source.l_addon,source.l_addon,'os_addOns',target.os_addOns,null),
('l_power',source.l_power,source.l_power,'os_power1',target.os_power1,null),
('l_power2',source.l_power2,source.l_power2,'os_power2',target.os_power2,null),
('l_oz',source.l_oz,source.l_oz,'os_opticZone',target.os_opticZone,null),
('l_thickness',source.l_thickness,source.l_thickness,'os_thickness',target.os_thickness,null),
('l_intermediate',source.l_intermediate,source.l_intermediate,'os_intermCurve',target.os_intermCurve,null),
('l_periph',source.l_periph,source.l_periph,'os_periphCurve',target.os_periphCurve,null),
('notes',source.notes,source.notes,'clrx_notes',target.clrx_notes,null),
('date',source.date,source.date,'clrx_startDate',target.clrx_startDate,null),
('expiration_date',source.expiration_date,source.expiration_date,'clrx_expirationDate',target.clrx_expirationDate,null),
('expiration_reason',source.expiration_reason,source.expiration_reason,'clrx_expiryChangeReason',target.clrx_expiryChangeReason,null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;