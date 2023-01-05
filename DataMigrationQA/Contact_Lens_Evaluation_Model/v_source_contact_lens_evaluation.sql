-- View: public.v_source_contact_lens_evaluation

-- DROP VIEW public.v_source_contact_lens_evaluation;

CREATE OR REPLACE VIEW public.v_source_contact_lens_evaluation
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_add_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_add_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_acuity_d_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_acuity_d_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_j_acuity_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_j_acuity_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_notes,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_sph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_sph_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_cyl_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_cyl_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_add_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_add_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_acuity_d_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_acuity_d_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_j_acuity_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_j_acuity_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_sph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_sph_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_cyl_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_cyl_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="candm"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS candm,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="candm_detail"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS candm_detail
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_contact_lens_evaluation
    OWNER TO postgres;

