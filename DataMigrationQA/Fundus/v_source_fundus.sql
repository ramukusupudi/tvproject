-- View: public.v_source_fundus

-- DROP VIEW public.v_source_fundus;

CREATE OR REPLACE VIEW public.v_source_fundus
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_macula_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_macula_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_vessels_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_vessels_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_fundus_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_fundus_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_periph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_periph_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_macula_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_macula_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_vessels_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_vessels_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_fundus_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_fundus_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_periph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_periph_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_antvit_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS slx_antvit_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="slx_antvit_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS slx_antvit_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_cd_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_cd_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_cd_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_cd_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_disc_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_disc_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="internal_disc_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS internal_disc_os
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_fundus
    OWNER TO postgres;

