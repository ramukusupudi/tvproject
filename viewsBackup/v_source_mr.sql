-- View: public.v_source_mr

-- DROP VIEW public.v_source_mr;

CREATE OR REPLACE VIEW public.v_source_mr
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_d_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_acuity_d_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_axis_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_sph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_sph_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_cyl_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_cyl_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_d_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_acuity_d_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_axis_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_sph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_sph_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_cyl_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_cyl_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_add_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_add_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_add_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_add_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_n_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_acuity_n_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_acuity_n_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_acuity_n_os,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="amp"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS amp,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="nra"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS nra,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="pra"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS pra,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_notes,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_prism_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_prism_od,
    ((xpath('//DATAHOLDER/FIELDS/FIELD[@name="manifest_prism_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1])::character varying AS manifest_prism_os
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_mr
    OWNER TO postgres;

