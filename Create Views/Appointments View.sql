-- View: public.v_migrated_appointments

-- DROP VIEW public.v_migrated_appointments;

CREATE OR REPLACE VIEW public.v_migrated_appointments
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    (o.target_model ->> '_id'::text) AS _id,
    (o.target_model -> 'appointmentType'::text) AS appointmenttype,
    ((o.target_model -> 'patient'::text) ->> '_id'::text) AS patient_id,
    ((o.target_model -> 'provider'::text) ->> '_id'::text) AS provider_id,
    ((o.target_model -> 'office'::text) ->> '_id'::text) AS office_id,
    ((o.target_model -> 'providerTemplate'::text) ->> '_id'::text) AS providertemplate_id,
    ((o.target_model ->> 'appointmentDate'::text))::date AS appointmentdate,
    ((o.target_model ->> 'appointmentTime'::text))::time without time zone AS appointmenttime,
    ((o.target_model ->> 'appointmentEndTime'::text))::time without time zone AS appointmentendtime,
    ((o.target_model ->> 'appointmentLength'::text))::integer AS appointmentlength,
    (o.target_model -> 'appointmentSlots'::text) AS appointmentslots,
    (o.target_model -> 'notes'::text) AS notes,
    ((o.target_model ->> 'isConfirmed'::text))::boolean AS isconfirmed,
    (o.target_model -> 'confirmationDetail'::text) AS confirmationdetail,
    ((o.target_model -> 'guarantor'::text) ->> '_id'::text) AS guarantor_id,
    (o.target_model ->> 'room'::text) AS room,
    (o.target_model ->> 'cancellationReason'::text) AS cancellationreason,
    (o.target_model ->> 'cancellationCode'::text) AS cancellationcode,
    ((o.target_model ->> 'newPatient'::text))::boolean AS newpatient,
    ((o.target_model ->> 'patientDob'::text))::date AS patientdob,
    (o.target_model -> 'insurancePayers'::text) AS insurancepayers,
    ((o.target_model -> 'rule'::text) ->> '_id'::text) AS rule_id,
    ((o.target_model ->> 'override'::text))::boolean AS override,
    (o.target_model ->> 'overrideCode'::text) AS overridecode,
    (o.target_model ->> 'overrideReason'::text) AS overridereason,
    ((o.target_model -> 'officeDataSet'::text) ->> '_id'::text) AS officedataset_id,
    ((o.target_model -> 'brand'::text) ->> '_id'::text) AS brand_id,
    (o.target_model ->> 'quickAppointmentflag'::text) AS quickappointmentflag,
    (o.target_model ->> 'referralUid'::text) AS referraluid,
    (o.target_model ->> 'isPrimaryMember'::text) AS isprimarymember,
    (o.target_model -> 'paymentMethod'::text) AS paymentmethod
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'appointments'::text);

ALTER TABLE public.v_migrated_appointments
    OWNER TO postgres;

