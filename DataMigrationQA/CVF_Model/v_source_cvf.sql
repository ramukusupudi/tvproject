-- View: public.v_source_cvf

-- DROP VIEW public.v_source_cvf;

CREATE OR REPLACE VIEW public.v_source_cvf
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cvf"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cvf
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_cvf
    OWNER TO postgres;

