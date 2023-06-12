Delete from source_target_match where source_datasetId='ContactOrder';
INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'ContactOrder' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,
  match_tests.notes
FROM v_source_contacts as source
FULL JOIN v_migrated_contact_order as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
					
('uid', source.uid, source.uid, 'source_instanceId1', target.source_instanceId, null),
('patient_id', target.patient_id, target.patient_id, 'patient_mdl_id', target.patient_mdl_id, null),
('provider_id', target.provider_id, target.provider_id, 'provider_mdl_id', target.provider_mdl_id, null),					
('patient_src', source.patient_src, source.patient_src, 'patient_src_id', target.patient_src_id, null),
('provider_src', source.provider_src, source.provider_src, 'provider_src_id', target.provider_src_id, null),
--('location_src', source.location_src, source.location_src, 'office_id1', target.office_id, null),
('NS_itemType', '', 'CONTACT', 'itemType', target.itemType, null),
('sku_src', source.sku_src::text, source.sku_src::text, 'sku', target.sku, null),
('eye', source.eye::text , CASE 
 	WHEN source.eye='1' THEN 'OD1'
 	WHEN source.eye='2' THEN 'OS1'
 END, 'eyeType', target.eyeType, null),
('contactnotes', source.contactnotes, source.contactnotes, 'sku_notes', target.sku_notes, null),
('order_number', source.order_number, source.order_number, 'ordernumber', target.ordernumber::text, null),
('order_status_name', source.order_status_name, source.order_status_name, 'orderStatus', target.orderStatus::text, null),
('order_type', source.order_type::text, CASE
 	WHEN source.order_type='40' THEN 'CONTACT'
 END, 'orderType', target.orderType::text, null),
('ordersPatient', source.ordersPatient, CASE
	 WHEN source.ordersPatient IS NULL THEN 'TFS'
	 ELSE 'SO'
 END, 'itemSource', target.itemSource::text, null),
('l_bc', source.l_bc, CASE 
 	WHEN source.eye='2' THEN source.l_bc
 	ELSE NULL
 END, 'os_bc', target.os_bc, null),
('cp_uid', source.cp_uid, CASE 
 	WHEN source.eye='2' THEN source.cp_uid
 	ELSE NULL
 END, 'OS1_id', target.OS1_id, null),
('l_dn', source.l_dn, CASE 
 	WHEN source.eye='2' THEN source.l_dn
 	ELSE NULL
 END, 'os_dn', target.os_dn, null),
('l_add', source.l_add, CASE 
 	WHEN source.eye='2' THEN source.l_add
 	ELSE NULL
 END, 'os_add', target.os_add, null),
('l_bc2', source.l_bc2, CASE 
 	WHEN source.eye='2' THEN source.l_bc2
 	ELSE NULL
 END, 'os_bc2', target.os_bc2, null),
('l_axis', source.l_axis, CASE 
 	WHEN source.eye='2' THEN source.l_axis
 	ELSE NULL
 END, 'os_axis', target.os_axis, null),
('l_diameter', source.l_diameter::text, CASE 
 	WHEN source.eye='2' THEN source.l_diameter::text
 	ELSE NULL
 END, 'os_diam', target.os_diam, null),
('contactsku', source.contactsku::text, CASE 
 	WHEN source.eye='2' THEN source.contactsku::text
 	ELSE NULL
 END, 'os_lens_sku', RTRIM(target.os_lens_sku,'.0'), null),
('contactsname', source.contactsname, CASE 
 	WHEN source.eye='2' THEN source.contactsname::text
 	ELSE NULL
 END, 'os_lens_name', target.os_lens_name, null),
('cl_stylename', source.cl_stylename, CASE 
 	WHEN source.eye='2' THEN source.cl_stylename::text
 	ELSE NULL
 END, 'os_lens_style', target.os_lens_style, null),
('mfg', source.mfg, CASE 
 	WHEN source.eye='2' THEN source.mfg::text
 	ELSE NULL
 END, 'os_lens_manufacturer', target.os_lens_manufacturer, null),
('cl_typename', source.cl_typename, CASE
	 WHEN source.eye='2' THEN source.cl_typename
	 ELSE null
 END, 'os_type', target.os_type, null),
('l_color', source.l_color, CASE
	 WHEN source.eye='2' THEN source.l_color
	 ELSE null
 END, 'os_color', target.os_color, null),
('l_seg', source.l_seg, CASE
	 WHEN source.eye='2' THEN source.l_seg
	 ELSE null
 END, 'os_segHt', target.os_segHt, null),
('l_sc', source.l_sc, CASE
	 WHEN source.eye='2' THEN source.l_sc
	 ELSE null
 END, 'os_skirt', target.os_skirt, null),
('l_addon', source.l_addon, CASE
	 WHEN source.eye='2' THEN source.l_addon
	 ELSE null
 END, 'os_addOns', target.os_addOns, null),
('l_power', source.l_power, CASE
	 WHEN source.eye='2' THEN source.l_power
	 ELSE null
 END, 'os_power1', target.os_power1, null),
('l_power2', source.l_power2,  CASE
	 WHEN source.eye='2' THEN source.l_power2
	 ELSE null
 END, 'os_power2', target.os_power2, null),
('l_cyl', source.l_cyl, CASE
	 WHEN source.eye='2' THEN source.l_cyl
	 ELSE null
 END, 'os_cylinder', target.os_cylinder, null),
('l_edge_lift', source.l_edge_lift, CASE
	 WHEN source.eye='2' THEN source.l_edge_lift
	 ELSE null
 END, 'os_edgeLift', target.os_edgeLift, null),
('l_material', source.l_material, CASE
	 WHEN source.eye='2' THEN source.l_material
	 ELSE null
 END, 'os_material', target.os_material, null),
('l_oz', source.l_oz, CASE
	 WHEN source.eye='2' THEN source.l_oz
	 ELSE null
 END, 'os_opticZone', target.os_opticZone, null),
('l_thickness', source.l_thickness, CASE
	 WHEN source.eye='2' THEN source.l_thickness
	 ELSE null
 END, 'os_thickness', target.os_thickness, null),
('l_intermediate', source.l_intermediate, CASE
	 WHEN source.eye='2' THEN source.l_intermediate
	 ELSE null
 END, 'os_intermCurve', target.os_intermCurve, null),
('l_periph', source.l_periph, CASE
	 WHEN source.eye='2' THEN source.l_periph
	 ELSE null
 END, 'os_periphCurve', target.os_periphCurve, null),
('OS_provfirstname', source.provfirstname, CASE
	 WHEN source.eye='2' THEN source.provfirstname
	 ELSE null
 END, 'os_provider_firstName', target.os_provider_firstname, null),
('OS_provlastname', source.provlastname, CASE
	 WHEN source.eye='2' THEN source.provlastname
	 ELSE null
 END, 'os_provider_lastName', target.os_provider_lastname, null),

('cp_uid', source.cp_uid, source.cp_uid, 'OD1_id', target.OD1_id::text, null),
('r_bc', source.r_bc, CASE
	 WHEN source.eye='1' THEN source.r_bc
	 ELSE null
 END, 'od_bc', target.od_bc, null),
('r_dn', source.r_dn, CASE
	 WHEN source.eye='1' THEN source.r_dn
	 ELSE null
 END, 'od_dn', target.od_dn, null),
('r_add', source.r_add, CASE
	 WHEN source.eye='1' THEN source.r_add
	 ELSE null
 END, 'od_add', target.od_add, null),
('r_bc2', source.r_bc2, CASE
	 WHEN source.eye='1' THEN source.r_bc2
	 ELSE null
 END, 'od_bc2', target.od_bc2, null),
('r_axis', source.r_axis, CASE
	 WHEN source.eye='1' THEN source.r_axis
	 ELSE null
 END, 'od_axis', target.od_axis, null),
('r_diameter', source.r_diameter::text, CASE
	 WHEN source.eye='1' THEN source.r_diameter::text
	 ELSE null
 END, 'od_diam', target.od_diam, null),
('contactsku', source.contactsku::text, CASE
	 WHEN source.eye='1' THEN source.contactsku::text
	 ELSE null
 END, 'od_lens_sku', RTRIM(target.od_lens_sku,'.0'), null),
('contactsname', source.contactsname,CASE
	 WHEN source.eye='1' THEN source.contactsname::text
	 ELSE null
 END, 'od_lens_name', target.od_lens_name, null),
('cl_stylename', source.cl_stylename, CASE
	 WHEN source.eye='1' THEN source.cl_stylename::text
	 ELSE null
 END, 'od_lens_style', target.od_lens_style, null),
('mfg', source.mfg, CASE
	 WHEN source.eye='1' THEN source.mfg::text
	 ELSE null
 END, 'od_lens_manufacturer', target.od_lens_manufacturer, null),
('cl_typename', source.cl_typename, CASE
	 WHEN source.eye='1' THEN source.cl_typename::text
	 ELSE null
 END, 'od_type', target.od_type, null),
('r_color', source.r_color, CASE
	 WHEN source.eye='1' THEN source.r_color::text
	 ELSE null
 END, 'od_color', target.od_color, null),
('r_seg', source.r_seg, CASE
	 WHEN source.eye='1' THEN source.r_seg::text
	 ELSE null
 END, 'od_segHt', target.od_segHt, null),
('r_sc', source.r_sc, CASE
	 WHEN source.eye='1' THEN source.r_sc::text
	 ELSE null
 END, 'od_skirt', target.od_skirt, null),
('r_addon', source.r_addon, CASE
	 WHEN source.eye='1' THEN source.r_addon::text
	 ELSE null
 END, 'od_addOns', target.od_addOns, null),
('r_power', source.r_power,  CASE
	 WHEN source.eye='1' THEN source.r_power::text
	 ELSE null
 END, 'od_power1', target.od_power1, null),
('r_power2', source.r_power2,  CASE
	 WHEN source.eye='1' THEN source.r_power2::text
	 ELSE null
 END, 'od_power2', target.od_power2, null),
('r_cyl', source.r_cyl, CASE
	 WHEN source.eye='1' THEN source.r_cyl::text
	 ELSE null
 END, 'od_cylinder', target.od_cylinder, null),
('r_edge_lift', source.r_edge_lift,  CASE
	 WHEN source.eye='1' THEN source.r_edge_lift::text
	 ELSE null
 END, 'od_edgeLift', target.od_edgeLift, null),
('r_material', source.r_material,  CASE
	 WHEN source.eye='1' THEN source.r_material::text
	 ELSE null
 END, 'od_material', target.od_material, null),
('r_oz', source.r_oz,  CASE
	 WHEN source.eye='1' THEN source.r_oz::text
	 ELSE null
 END, 'od_opticZone', target.od_opticZone, null),
('r_thickness', source.r_thickness,  CASE
	 WHEN source.eye='1' THEN source.r_thickness::text
	 ELSE null
 END, 'od_thickness', target.od_thickness, null),
('r_intermediate', source.r_intermediate, CASE
	 WHEN source.eye='1' THEN source.r_intermediate::text
	 ELSE null
 END, 'od_intermCurve', target.od_intermCurve, null),
('r_periph', source.r_periph, CASE
	 WHEN source.eye='1' THEN source.r_periph::text
	 ELSE null
 END, 'od_periphCurve', target.od_periphCurve, null),
('OD_provfirstname', source.provfirstname, CASE
	 WHEN source.eye='1' THEN source.provfirstname::text
	 ELSE null
 END, 'od_provider_firstName', target.od_provider_firstName, null),
('OD_provlastname', source.provlastname, CASE
	 WHEN source.eye='1' THEN source.provlastname::text
	 ELSE null
 END, 'od_provider_lastName', target.od_provider_lastName, null),

('drop_ship', source.drop_ship::text, source.drop_ship::text, 'dropShip', target.dropShip::text, null),
('address_different', source.address_different::text, CASE 
 	WHEN source.drop_ship::text ='false' THEN null
    ELSE source.address_different::text
 END, 'dropShipDetails_otherDropShip', target.dropShipDetails_otherDropShip, null),
('phone', source.phone::text, source.phone::text, 'dropShipDetails_phone', target.dropShipDetails_phone, null),
('order_address_street', source.order_address_street, CASE 
 	WHEN source.drop_ship::text ='true' AND source.order_address_street IS NULL THEN source.pataddrline1
    WHEN source.drop_ship::text ='true' AND source.order_address_street IS NOT NULL THEN source.order_address_street
 END, 'dropShipDetails_address1', target.dropShipDetails_address1, null),
('order_address_city', source.order_address_city, CASE 
	 WHEN source.drop_ship::text ='true' AND source.order_address_city  IS NULL THEN source.patcity
     WHEN source.drop_ship::text ='true' AND source.order_address_city  IS NOT NULL THEN source.order_address_city
 END, 'dropShipDetails_city', target.dropShipDetails_city, null),
('order_address_state', source.order_address_state, CASE 
 	WHEN source.drop_ship::text ='true' AND source.order_address_state IS NULL THEN source.patstate
    WHEN source.drop_ship::text ='true' AND source.order_address_state IS NOT NULL THEN source.order_address_state
 END, 'dropShipDetails_state', target.dropShipDetails_state, null),
('order_address_zip', source.order_address_zip::text, CASE
 WHEN source.drop_ship::text ='true' AND source.order_address_zip::text IS NULL THEN source.patzip::text
 WHEN source.drop_ship::text ='true' AND source.order_address_zip::text IS NOT NULL THEN source.order_address_zip::text
 END, 'dropShipDetails_zip', target.dropShipDetails_zip, null),
('flags', source.flags, CASE
	 WHEN source.flags::text ='1000' THEN 'PROBLEM_ORDER'
	 WHEN source.flags::text ='0100' THEN 'ADDRESS_DIFFERENT'
	 WHEN source.flags::text ='0010' THEN 'OUTSIDE_LAB'
	 WHEN source.flags::text ='0001' THEN 'BACKORDER'
	 WHEN source.flags::text ='0000' THEN NULL
 END, 'orderFlags', target.orderFlags, null),
('quantity', source.quantity::text, source.quantity::text, 'quantity', target.quantity::text, null),
('job_flags', source.job_flags, source.job_flags, 'jobFlags', target.jobFlags, null),
('job_type', source.job_type, source.job_type, 'jobType', target.jobType::text, null),
('ordernotes', source.ordernotes, source.ordernotes, 'notes', target.notes::text, null),
('auth', source.auth, CASE 
 	WHEN source.auth IS NULL OR source.auth ='' THEN NULL
 	ELSE
 	source.auth
 END, 'auth', target.auth::text, null),
('history', source.history, jsonb_build_object('stateHistory', source.history || '')::text , 'additionalProperties', target.additionalProperties::text, null),
('order_date_time','' , TO_CHAR(TO_TIMESTAMP(TO_CHAR(CONCAT(source.order_date,' ', source.order_time)::timestamp, 'Mon DD, YYYY, HH:MI:SS AM'),
				   'Mon DD, YYYY, HH:MI:SS AM') + INTERVAL
				'5 hours 51 minutes', 'Mon DD, YYYY, HH:MI:SS PM') ,'orderDate', target.orderDate::text, null)
	
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;