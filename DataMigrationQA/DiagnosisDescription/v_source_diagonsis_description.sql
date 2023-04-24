-- View: public.v_source_diagnosisdescription

-- DROP VIEW public.v_source_diagnosisdescription;

CREATE OR REPLACE VIEW public.v_source_diagnosisdescription
 AS
 SELECT d.exam_uid,
    d.patient_src,
    d.exam_date,
    d.notes,
    d.created_stamp,
    d.encounter_index,
    d.diagnosis,
    (d.diagnosis -> 0) ->> 'Plan_description'::text AS diagnosis1,
    (d.diagnosis -> 1) ->> 'Plan_description'::text AS diagnosis2,
    (d.diagnosis -> 2) ->> 'Plan_description'::text AS diagnosis3,
    (d.diagnosis -> 3) ->> 'Plan_description'::text AS diagnosis4,
    (d.diagnosis -> 4) ->> 'Plan_description'::text AS diagnosis5,
    (d.diagnosis -> 5) ->> 'Plan_description'::text AS diagnosis6,
    (d.diagnosis -> 6) ->> 'Plan_description'::text AS diagnosis7,
	(d.diagnosis -> 0) ->> 'Plan_uid'::text AS Plan_uid1,
    (d.diagnosis -> 1) ->> 'Plan_uid'::text AS Plan_uid2,
    (d.diagnosis -> 2) ->> 'Plan_uid'::text AS Plan_uid3,
    (d.diagnosis -> 3) ->> 'Plan_uid'::text AS Plan_uid4,
    (d.diagnosis -> 4) ->> 'Plan_uid'::text AS Plan_uid5,
    (d.diagnosis -> 5) ->> 'Plan_uid'::text AS Plan_uid6,
    (d.diagnosis -> 6) ->> 'Plan_uid'::text AS Plan_uid7
   FROM v_source_exam_diagnosis_description d;

ALTER TABLE public.v_source_diagnosisdescription
    OWNER TO postgres;

