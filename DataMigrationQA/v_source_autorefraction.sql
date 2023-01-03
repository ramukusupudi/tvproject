-- View: public.v_source_autorefraction

-- DROP VIEW public.v_source_autorefraction;

CREATE OR REPLACE VIEW public.v_source_autorefraction
 AS
 SELECT exams.uid,
    exams.patient,
    exams.date,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="r_axis"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_r_axis,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="r_sph"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_r_sph,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="r_cyl"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_r_cyl,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="l_axis"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_l_axis,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="l_sph"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_l_sph,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="l_cyl"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_l_cyl,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS auto_notes,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_acuity_d_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_acuity_d_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_sph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_sph_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_cyl_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_cyl_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_acuity_d_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_acuity_d_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_sph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_sph_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="retino_cyl_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS retino_cyl_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry_dk_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry_dk_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry_dk_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry_dk_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry2_dk_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry2_dk_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry2_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry2_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry2_dk_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry2_dk_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="keratometry2_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS keratometry2_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_sph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_sph_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_cyl_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_cyl_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_sph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_sph_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="cyclo_cyl_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS cyclo_cyl_os
   FROM exams
  ORDER BY exams.uid, exams.date DESC;

ALTER TABLE public.v_source_autorefraction
    OWNER TO postgres;

