CREATE OR REPLACE VIEW public.v_source_pupil
 AS
SELECT exams.uid, exams.patient, exams.date,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_lens_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_lens_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_lens_os "]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_lens_os ,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_cornea_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_cornea_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_cornea_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_cornea_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_iris_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_iris_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_iris_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_iris_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_a_c_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_a_c_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_a_c_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_a_c_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_conj_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_conj_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_conj_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_conj_os,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_sclera_od"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_sclera_od,
(xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_sclera_os"]/text()', XMLPARSE(DOCUMENT exams.exam_data)))[1]::VARCHAR as slx_sclera_os
FROM exams
ORDER BY exams.uid, exams.date DESC;
