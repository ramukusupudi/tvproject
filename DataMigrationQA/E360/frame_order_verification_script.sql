Delete from source_target_match where source_datasetId= 'FrameOrder';

INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'FrameOrder' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_frame as source
FULL JOIN v_migrated_frame_order as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES

('patient_src', source.patient_src, source.patient_src,'patient_src_id', target.Patient_src_id, null),
--('exam_provider', source.exam_provider, source.exam_provider,'provider_id', target.provider_id, null),					
('exam_provider_id', target.exam_provider_id, target.exam_provider_id,'provider_id', target.exam_provider_id, null),					
('location', source.location, source.location,'office_src_id', target.office_src_id, null),
('office', target.office_id, target.office_id,'office', target.office_mdl_id, null),					
('NS_itemtype', '', 'FRAME','frame_itemtype', target.itemtype, null),
('sku_src', source.sku_src::text, source.sku_src::text,'frame_sku', target.sku, null),
/*					
('rxable', source.rxable, source.rxable,'rxable', target.rxable, null),
('notes', source.notes, source.notes,'sku_notes', target.sku_notes, null),
('color', source.color, source.color,'color', target.color, null),
('gender', source.gender, source.gender,'gender', target.gender, null),
('available', source.available, source.available,'available', target.available, null),
('retail', source.retail, source.retail,'defaultretailprice', target.defaultretailprice, null),
('ycode', source.ycode, source.ycode,'ycode', target.ycode, null),
('fprice', source.fprice, source.fprice,'ffprice', target.ffprice, null),
('mfg_name', source.mfg_name, source.mfg_name,'manufacturer_name', target.manufacturer_name, null),
('backorder', source.backorder, source.backorder,'backorder', target.backorder, null),
('static', source.static, source.static,'staticflag', target.staticflag, null),
('vcode', source.vcode, source.vcode,'vcode', target.vcode, null),
('ed', source.ed, source.ed,'ed', target.ed, null),
('b', source.b, source.b,'b', target.b, null),
('cost', source.cost, source.cost,'cost', target.cost, null),
('cpt', source.cpt, source.cpt,'cpt', target.cpt, null),
('upc', source.upc, source.upc,'upc', target.upc, null),
('dynamic_frame', source.dynamic_frame, source.dynamic_frame,'dynamicframe', target.dynamicframe, null),
('do_not_order', source.do_not_order, source.do_not_order,'donotorder', target.donotorder, null),
('mfg_line', source.mfg_line, source.mfg_line,'collection', target.collection, null),
('category_name', source.category_name, source.category_name,'categorycode', target.categorycode, null),
('dbl', source.dbl, source.dbl,'dbi', target.dbi, null),
('frame_type', source.frame_type, source.frame_type,'typecode', target.typecode, null),
('eye_size', source.eye_size, source.eye_size,'size', target.size, null),
('frame_name', source.frame_name, source.frame_name,'name', target.name, null),
('temple', source.temple, source.temple,'temple', target.temple, null),
('retail', source.retail, source.retail,'retailprice', target.retailprice, null),

('frames_available', source. available, source. available,'defaultavailable', target.defaultavailable, null), */
					
('order_number', source.order_number, source.order_number,'frame_ordernumber', target.ordernumber, null),
('order_status_name', source.order_status_name, CASE
	 WHEN source.order_status_name = 'Canceled' THEN 'CANCELLED' 
 	 WHEN source.order_status_name = 'Received by patient' THEN 'RECEIVED_BY_PATIENT' 
 	 WHEN source.order_status_name = 'On order from distribution' THEN 'ON_ORDER_FROM_DISTRIBUTION'
     WHEN source.order_status_name = 'Received by Office' THEN 'RECEIVED_BY_OFFICE' 
	 WHEN source.order_status_name = 'On order from vendor' THEN 'ON_ORDER_FROM_VENDOR' 
	 WHEN source.order_status_name = 'Order Replaced' THEN 'LAB_REDO' 
	 WHEN source.order_status_name = 'Taken From Stock' THEN 'TAKEN_FROM_STOCK'
 	 ELSE 'ON_ORDER_FROM_DISTRIBUTION'
	 END,'frame_orderstatus', target.orderstatus, null),
('order_type', '', 'FRAME','frame_ordertype', target.ordertype, null),
---yet to confirm the src fld name					
('order_job_type', '', CASE 
	 WHEN source.job_type='E' THEN 'ETB'
	 WHEN source.job_type !='E' THEN 'SO'
 	 WHEN source.job_type IS NULL THEN 'SO'
	 END,'frame_itemsource', target.itemsource, null),					
('job_type', source.job_type, source.job_type,'frame_jobtype', target.jobtype, null),
('quantity', source.quantity::text, source.quantity::text,'frame_quantity', target.quantity, null),
         /*
('flags', source.flags, CASE
	 WHEN source.flags::text ='1000' THEN 'PROBLEM_ORDER'
	 WHEN source.flags::text ='0100' THEN 'ADDRESS_DIFFERENT'
	 WHEN source.flags::text ='0010' THEN 'OUTSIDE_LAB'
	 WHEN source.flags::text ='0001' THEN 'BACKORDER'
	 WHEN source.flags::text ='0000' THEN ''
 END,'frame_orderflags', target.orderflags, null),  */
--('job_flags', source.job_flags,'','frame_jobflags', target.jobflags, null),
--('notes', source.notes, source.notes,'notes', target.notes, null),
('auth', source.auth, CASE 
 	WHEN source.auth IS NULL OR source.auth ='' THEN NULL
 	ELSE
 	source.auth
 END,'frame_auth', target.auth, null)					
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					