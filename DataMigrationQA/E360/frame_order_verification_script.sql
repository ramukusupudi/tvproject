--Delete from source_target_match where source_datasetId= 'Frame Order'
INSERT INTO source_target_match(source_datasetId, source_id, source_field, source_value, expected_mapped_value, target_id, target_field, target_value, matched, notes)
SELECT 
  'Frame Order' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value, 
  target._id as target_id, match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched, match_tests.notes
FROM v_source_frame_order as source
FULL JOIN v_migrated_frame_order as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES

('patient', source.patient, source.patient,'patient_id', target.patient_id, null),
('location', source.location, source.location,'office_id', target.office_id, null),
('itemtype', '', '','itemtype', target.itemtype, null),
('sku OR sku', source.sku OR sku, source.sku OR sku,'sku', target.sku, null),
('rxable', source.rxable, source.rxable,'rxable', target.rxable, null),
('notes', source.notes, source.notes,'sku_notes', target.sku_notes, null),
('color', source.color, source.color,'color', target.color, null),
('gender', source.gender, source.gender,'gender', target.gender, null),
('available', source.available, source.available,'available', target.available, null),
('retail', source.retail, source.retail,'defaultretailprice', target.defaultretailprice, null),
('ycode', source.ycode, source.ycode,'ycode', target.ycode, null),
('fprice', source.fprice, source.fprice,'ffprice', target.ffprice, null),
('mfg', source.mfg, source.mfg,'manufacturer_name', target.manufacturer_name, null),
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
('fcategory_name', source.fcategory_name, source.fcategory_name,'categorycode', target.categorycode, null),
('dbl', source.dbl, source.dbl,'dbi', target.dbi, null),
('ftype_name', source.ftype_name, source.ftype_name,'typecode', target.typecode, null),
('eye_size', source.eye_size, source.eye_size,'size', target.size, null),
('name', source.name, source.name,'name', target.name, null),
('temple', source.temple, source.temple,'temple', target.temple, null),
('retail', source.retail, source.retail,'retailprice', target.retailprice, null),
(' available', source. available, source. available,'defaultavailable', target.defaultavailable, null),
('order_number', source.order_number, source.order_number,'ordernumber', target.ordernumber, null),
('dfstatus_name', source.dfstatus_name, source.dfstatus_name,'orderstatus', target.orderstatus, null),
('order_type', source.order_type, source.order_type,'ordertype', target.ordertype, null),
('order.job_type + sku +order_status', source.order.job_type + sku +order_status, source.order.job_type + sku +order_status,'itemsource', target.itemsource, null),
('job_type', source.job_type, source.job_type,'jobtype', target.jobtype, null),
('quantity', source.quantity, source.quantity,'quantity', target.quantity, null),
('flags', source.flags, source.flags,'orderflags', target.orderflags, null),
('job_flags', source.job_flags, source.job_flags,'jobflags', target.jobflags, null),
('notes', source.notes, source.notes,'notes', target.notes, null)
) as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;					