-- View: public.v_source_binocular_vision_eval

-- DROP VIEW public.v_source_binocular_vision_eval;

CREATE OR REPLACE VIEW public.v_source_binocular_vision_eval
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    exams.cpt,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="npc"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS npc
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_binocular_vision_eval
    OWNER TO postgres;

