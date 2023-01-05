-- View: public.v_migrated_appointments

-- DROP VIEW public.v_migrated_appointments;

CREATE OR REPLACE VIEW public.v_migrated_appointments
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.model,
    o.sources,
    o.target_model,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'appointmentType'::text) ->> 'code'::text AS appointmentcode,
    (o.target_model -> 'patient'::text) ->> '_id'::text AS patient_id,
    p.source_instanceid AS patient_source_instanceid,
    office.source_instanceid AS office_source_instanceid,
    p.firstname AS patient_firstname,
    p.lastname AS patient_lastname,
    p.dob AS patient_dob,
    (o.target_model -> 'provider'::text) ->> '_id'::text AS provider_id,
    provider.source_instanceid AS provider_source_instanceid,
    (o.target_model -> 'office'::text) ->> '_id'::text AS office_id,
    (o.target_model -> 'providerTemplate'::text) ->> '_id'::text AS providertemplate_id,
    (o.target_model ->> 'appointmentDate'::text)::date AS appointmentdate,
    (o.target_model ->> 'appointmentTime'::text)::time without time zone AS appointmenttime,
    (o.target_model ->> 'appointmentEndTime'::text)::time without time zone AS appointmentendtime,
    (o.target_model ->> 'appointmentLength'::text)::integer AS appointmentlength,
    o.target_model -> 'appointmentSlots'::text AS appointmentslots,
    btrim(((((o.target_model -> 'notes'::text) ->> 0)::json) -> 'text'::text)::text, '"'::text) AS notes,
    (o.target_model ->> 'isConfirmed'::text)::boolean AS isconfirmed,
    btrim(((o.target_model -> 'confirmationDetail'::text) -> 'confirmationBy'::text)::text, '"'::text) AS confirmationby,
    btrim(((o.target_model -> 'confirmationDetail'::text) -> 'confirmationDate'::text)::text, '"'::text) AS confirmationdate,
    btrim(((o.target_model -> 'confirmationDetail'::text) -> 'confirmationTime'::text)::text, '"'::text) AS confirmationtime,
    (o.target_model -> 'guarantor'::text) ->> '_id'::text AS guarantor_id,
    o.target_model ->> 'room'::text AS room,
    o.target_model ->> 'cancellationReason'::text AS cancellationreason,
    o.target_model ->> 'cancellationCode'::text AS cancellationcode,
    p.patientdetails_isflagnew::boolean AS newpatient,
    (o.target_model ->> 'dob'::text)::date AS patientdob,
    o.target_model -> 'insurancePayers'::text AS insurancepayers,
    (o.target_model -> 'rule'::text) ->> '_id'::text AS rule_id,
    (o.target_model ->> 'override'::text)::boolean AS override,
    o.target_model ->> 'overrideCode'::text AS overridecode,
    o.target_model ->> 'overrideReason'::text AS overridereason,
    (o.target_model -> 'officeDataSet'::text) ->> '_id'::text AS officedataset_id,
    (o.target_model -> 'brand'::text) ->> '_id'::text AS brand_id,
    o.target_model ->> 'quickAppointmentflag'::text AS quickappointmentflag,
    o.target_model ->> 'referralUid'::text AS referraluid,
    o.target_model ->> 'isPrimaryMember'::text AS isprimarymember,
    o.target_model -> 'paymentMethod'::text AS paymentmethod,
    exmsheet.uid AS exam_sheet_id
   FROM v_migrated_objects o
     LEFT JOIN v_migrated_patients p ON p._id = ((o.target_model -> 'patient'::text) ->> '_id'::text)
     LEFT JOIN v_migrated_offices office ON office._id = ((o.target_model -> 'office'::text) ->> '_id'::text)
     LEFT JOIN v_migrated_providers provider ON provider._id = ((o.target_model -> 'provider'::text) ->> '_id'::text)
     LEFT JOIN created_exam_sheet exmsheet ON exmsheet.uid::text = (o.target_model ->> '_id'::text)
  WHERE o.model::text = 'appointments'::text;

ALTER TABLE public.v_migrated_appointments
    OWNER TO postgres;

