-- View: public.v_source_appointment

-- DROP VIEW public.v_source_appointment;

CREATE OR REPLACE VIEW public.v_source_appointments
 AS
 SELECT appointments.uid,
    appointments."time",
    appointments.date,
    appointments.patient,
    appointments.type,
    appointments.confirmed,
    appointments.location,
    appointments.provider,
    appointments.notes,
    appointments.provider_template,
    appointments.length
   FROM appointments;

ALTER TABLE public.v_source_appointments
    OWNER TO postgres;

