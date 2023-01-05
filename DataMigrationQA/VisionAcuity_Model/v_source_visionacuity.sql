-- View: public.v_source_visionacuity

-- DROP VIEW public.v_source_visionacuity;

CREATE OR REPLACE VIEW public.v_source_visionacuity
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_n_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_n_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_n_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_n_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_n_ou"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_n_ou,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_d_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_d_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_d_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_d_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_d_ou"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_d_ou,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="acuity_n_type"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS acuity_n_type
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_visionacuity
    OWNER TO postgres;

