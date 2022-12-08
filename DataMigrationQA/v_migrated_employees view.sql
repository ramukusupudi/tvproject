-- View: public.v_migrated_employees

-- DROP VIEW public.v_migrated_employees;
--select licenseid from v_migrated_employees
CREATE OR REPLACE VIEW public.v_migrated_employees
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    o.target_model ->> 'designation'::text AS designation,
    o.target_model ->> 'firstName'::text AS firstname,
    o.target_model ->> 'lastName'::text AS lastname,
    o.target_model ->> 'employeeNumber'::text AS employeenumber,
    o.target_model ->> 'mi'::text AS mi,
    (o.target_model ->> 'dob')::date AS dob,
    o.target_model ->> 'email'::text AS email,
    o.target_model -> 'sex'->>'key'::text AS sex_key,
    o.target_model ->> 'available'::text AS available,
    o.target_model ->> 'note'::text AS note,
    o.target_model ->> 'age'::text AS age,
    o.target_model ->> 'homePhone'::text AS homephone,
    o.target_model ->> 'workPhone'::text AS workphone,
    o.target_model ->> 'cellPhone'::text AS cellphone,
    (o.target_model -> 'address'::text) ->> 'addressLine1'::text AS addressline1,
    (o.target_model -> 'address'::text) ->> 'city'::text AS city,
    (o.target_model -> 'address'::text) ->> 'state'::text AS address_state,
    (o.target_model -> 'address'::text) ->> 'zip'::text AS zip,
    (o.target_model -> 'providerDetails'::text) ->> 'isProvider'::text AS isprovider,
    (o.target_model -> 'providerDetails'::text) ->> 'directAddress'::text AS directaddress,
    (o.target_model -> 'providerDetails'::text) ->> 'npi'::text AS npi,
    (o.target_model -> 'providerDetails'::text) ->> 'professionalEq'::text AS professionaleq,
    (o.target_model -> 'providerDetails'::text) ->> 'opticalEq'::text AS opticaleq,
    (o.target_model -> 'providerDetails'::text) ->> 'surgicalEq'::text AS surgicaleq,
    (o.target_model -> 'providerDetails'::text) ->> 'contactEq'::text AS contacteq,
    (o.target_model -> 'providerDetails'::text) ->> 'onlineProvider'::text AS onlineprovider,
    (((o.target_model -> 'providerDetails'::text) -> 'license'::text) -> 0) ->> '_id'::text AS licenseid,
    (((o.target_model -> 'providerDetails'::text) -> 'license'::text) -> 0) ->> 'state'::text AS license_state,
    (((o.target_model -> 'providerDetails'::text) -> 'deaIds'::text) -> 0) ->> 'dea'::text AS dea,
    ((o.target_model -> 'offices'::text) -> 0) ->> '_id'::text AS offices_id1,
	((o.target_model -> 'offices'::text) -> 1) ->> '_id'::text AS offices_id2,
	((o.target_model -> 'offices'::text) -> 2) ->> '_id'::text AS offices_id3,
	((o.target_model -> 'offices'::text) -> 3) ->> '_id'::text AS offices_id4
   FROM v_migrated_objects o
  WHERE o.model::text = 'employees'::text;

ALTER TABLE public.v_migrated_employees
    OWNER TO postgres;

