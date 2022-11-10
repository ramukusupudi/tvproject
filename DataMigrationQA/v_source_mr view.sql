select * from v_source_mr
CREATE OR REPLACE VIEW public.v_source_mr
 AS
 SELECT 
  exams.uid, exams.patient, exams.date,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_d_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_acuity_d_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_axis_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_axis_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_sph_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_sph_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_cyl_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_cyl_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_d_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_acuity_d_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_axis_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_axis_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_sph_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_sph_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_cyl_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_cyl_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_add_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_add_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_add_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_add_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_n_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_acuity_n_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_n_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_acuity_n_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="amp"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as amp,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="nra"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as nra,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="pra"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as pra,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_notes"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_notes,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_prism_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_prism_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_prism_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as manifest_prism_os
FROM exams
ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_mr
    OWNER TO postgres;