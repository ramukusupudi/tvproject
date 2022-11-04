-- View: public.v_migrated_patient_documents

-- DROP VIEW public.v_migrated_patient_documents;

CREATE OR REPLACE VIEW public.v_migrated_patient_documents
 AS
 SELECT (o.target_model ->> '_id'::text) AS _id,
    (o.target_model ->> 'patientId'::text) AS patientid,
    ((o.target_model ->> 'date'::text))::date AS date,
    (o.target_model ->> 'name'::text) AS filename,
    (o.target_model ->> 'category'::text) AS category,
    (o.target_model ->> 'documentType'::text) AS documenttype,
    ((o.target_model -> 'digital_assets'::text) ->> '_id'::text) AS digital_assets_id,
    o.source_datasetid,
    o.source_instanceid,
    o.model,
    o.sources,
    o.target_model
   FROM v_migrated_objects o
  WHERE ((o.model)::text = 'patient_document'::text);

ALTER TABLE public.v_migrated_patient_documents
    OWNER TO postgres;

