-- View: public.v_source_clrx

-- DROP VIEW public.v_source_clrx;

CREATE OR REPLACE VIEW public.v_source_clrx
 AS
 SELECT exams.uid AS exam_uid,
    exams.patient,
    contact_prescription.uid,
    contact_prescription.patient AS cont_pre_patient,
    contact_prescription.date,
    contact_prescription.notes,
    contact_prescription.expiration_date,
    contact_prescription.expiration_reason,
    contact_prescription.r_bc,
    contact_prescription.r_add,
    contact_prescription.r_bc2,
    contact_prescription.r_axis,
    contact_prescription.r_diameter,
    contact_prescription.r_color,
    contact_prescription.r_seg,
    contact_prescription.r_sc,
    contact_prescription.r_addon,
    contact_prescription.r_power,
    contact_prescription.r_power2,
    contact_prescription.r_cyl,
    contact_prescription.r_material,
    contact_prescription.r_oz,
    contact_prescription.r_thickness,
    contact_prescription.r_intermediate,
    contact_prescription.r_periph,
    contact_prescription.l_bc,
    contact_prescription.l_add,
    contact_prescription.l_bc2,
    contact_prescription.l_axis,
    contact_prescription.l_diameter,
    contact_prescription.l_color,
    contact_prescription.l_seg,
    contact_prescription.l_sc,
    contact_prescription.l_addon,
    contact_prescription.l_power,
    contact_prescription.l_power2,
    contact_prescription.l_cyl,
    contact_prescription.l_material,
    contact_prescription.l_oz,
    contact_prescription.l_thickness,
    contact_prescription.l_intermediate,
    contact_prescription.l_periph,
    contacts.trial,
    contacts.sku,
    contacts.name,
    contacts.style,
    contacts.mfg,
    contacts.type,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_add_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_add_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_acuity_d_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_acuity_d_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_j_acuity_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_j_acuity_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_axis_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_axis_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_notes1,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_sph_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_sph_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_cyl_od"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_cyl_od,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_add_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_add_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_acuity_d_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_acuity_d_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_j_acuity_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_j_acuity_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_axis_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_axis_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_notes"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_notes,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_sph_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_sph_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="contact_cyl_os"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS contact_cyl_os,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="eye_dominance"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS eye_dominance,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="candm"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS candm,
    (xpath('//DATAHOLDER/FIELDS/FIELD[@name="candm_detail"]/text()'::text, XMLPARSE(DOCUMENT exams.exam_data STRIP WHITESPACE)))[1]::character varying AS candm_detail
   FROM exams
     LEFT JOIN contact_prescription ON exams.date = contact_prescription.date AND exams.patient::text = contact_prescription.patient::text
     LEFT JOIN contacts ON contact_prescription.contact = contacts.sku
  WHERE contact_prescription.uid IS NOT NULL
  ORDER BY exams.uid, exams.patient, exams.date DESC;

ALTER TABLE public.v_source_clrx
    OWNER TO postgres;

