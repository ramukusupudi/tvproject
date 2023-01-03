-- View: public.v_source_patients_notes

-- DROP VIEW public.v_source_patients_notes;

CREATE OR REPLACE VIEW public.v_source_patients_notes
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS notes
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_patients_notes
    OWNER TO postgres;

