-- View: public.v_migrated_coverage

-- DROP VIEW public.v_migrated_coverage;

CREATE OR REPLACE VIEW public.v_migrated_coverage
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    (o.target_model ->> '_id'::text) AS _id,
    ((o.target_model -> 'beneficiary'::text) ->> '_id'::text) AS beneficiary_id,
    (o.target_model ->> 'subscriberRelation'::text) AS subscriberrelation,
    (o.target_model ->> 'isPatientSubscriber'::text) AS ispatientsubscriber,
    ((o.target_model -> 'subscriber'::text) ->> '_id'::text) AS subscriber_id,
    ((o.target_model -> 'subscriber'::text) ->> 'firstName'::text) AS subscriber_firstname,
    ((o.target_model -> 'subscriber'::text) ->> 'lastName'::text) AS subscriber_lastname,
    ((o.target_model -> 'subscriber'::text) ->> 'dob'::text) AS subscriber_dob,
    ((o.target_model -> 'subscriber'::text) ->> 'ssn'::text) AS subscriber_ssn,
    ((o.target_model -> 'subscriber'::text) ->> 'notes'::text) AS subscriber_notes,
    (((o.target_model -> 'subscriber'::text) -> 'address'::text) ->> 'addressLine1'::text) AS subscriber_addressline1,
    (((o.target_model -> 'subscriber'::text) -> 'address'::text) ->> 'city'::text) AS subscriber_city,
    (((o.target_model -> 'subscriber'::text) -> 'address'::text) ->> 'state'::text) AS subscriber_state,
    (((o.target_model -> 'subscriber'::text) -> 'address'::text) ->> 'zip'::text) AS subscriber_zip,
    (((((o.target_model -> 'subscriber'::text) -> 'contactInformation'::text) -> 'phone'::text) -> 0) ->> 'number'::text) AS subscriber_number0,
    (((((o.target_model -> 'subscriber'::text) -> 'contactInformation'::text) -> 'phone'::text) -> 1) ->> 'number'::text) AS subscriber_number1,
    (((((o.target_model -> 'subscriber'::text) -> 'contactInformation'::text) -> 'phone'::text) -> 2) ->> 'number'::text) AS subscriber_number2,
    (((((o.target_model -> 'subscriber'::text) -> 'contactInformation'::text) -> 'email'::text) -> 0) ->> 'email'::text) AS subscriber_email,
    (o.target_model ->> 'insuranceType'::text) AS insurancetype,
    ((o.target_model -> 'payer'::text) ->> '_id'::text) AS payer_id,
    ((o.target_model -> 'plan'::text) ->> '_id'::text) AS plan_id,
    (o.target_model ->> 'expirationDate'::text) AS expirationdate,
    (o.target_model ->> 'policyNumber'::text) AS policynumber,
    (o.target_model ->> 'insuranceId'::text) AS insuranceid,
    (o.target_model ->> 'planName'::text) AS planname,
    (o.target_model ->> 'planPhone'::text) AS planphone,
    (o.target_model ->> 'planAddress'::text) AS planaddress,
    (o.target_model ->> 'planState'::text) AS planstate,
    (o.target_model ->> 'planCity'::text) AS plancity,
    (o.target_model ->> 'planZip'::text) AS planzip,
    (o.target_model ->> 'active'::text) AS active,
    (o.target_model ->> 'status'::text) AS status,
    (o.target_model ->> 'priority'::text) AS priority,
    (o.target_model ->> 'archive'::text) AS archive,
    (o.target_model ->> 'selected'::text) AS selected,
    (o.target_model ->> 'group'::text) AS "group",
    (o.target_model ->> 'insPhone'::text) AS insphone,
    (o.target_model ->> 'financialClass'::text) AS financialclass,
    (((o.target_model -> 'financialClassBasedInformation'::text) -> 'autoDetails'::text) ->> 'accidentType'::text) AS accidenttype,
    (((o.target_model -> 'financialClassBasedInformation'::text) -> 'autoDetails'::text) ->> 'accidentState'::text) AS accidentstate,
    (((o.target_model -> 'financialClassBasedInformation'::text) -> 'autoDetails'::text) ->> 'accidentDate'::text) AS accidentdate,
    (((o.target_model -> 'digitalAssets'::text) -> 'view_back'::text) ->> 'uid'::text) AS digitalassetsviewbackuid,
    (((o.target_model -> 'digitalAssets'::text) -> 'view_back'::text) ->> 'fileName'::text) AS digitalassetsviewbackfilename,
    (((o.target_model -> 'digitalAssets'::text) -> 'view_front'::text) ->> 'uid'::text) AS digitalassetsviewfrontuid,
    (((o.target_model -> 'digitalAssets'::text) -> 'view_front'::text) ->> 'fileName'::text) AS digitalassetsviewfrontfilename,
    (((o.target_model -> 'digitalAssets'::text) -> 'master_back'::text) ->> 'uid'::text) AS digitalassetsmasterbackuid,
    (((o.target_model -> 'digitalAssets'::text) -> 'master_back'::text) ->> 'fileName'::text) AS digitalassetsmasterbackfilename,
    (((o.target_model -> 'digitalAssets'::text) -> 'master_front'::text) ->> 'uid'::text) AS digitalassetsmasterfrontuid,
    (((o.target_model -> 'digitalAssets'::text) -> 'master_front'::text) ->> 'fileName'::text) AS digitalassetsmasterfrontfilename,
    (o.target_model ->> '_created'::text) AS created,
    (o.target_model ->> '_updated'::text) AS updated,
    o.target_model
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'coverage'::text);

ALTER TABLE public.v_migrated_coverage
    OWNER TO postgres;

