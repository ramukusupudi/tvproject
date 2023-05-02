-- View: public.v_migrated_iopdilation

-- DROP VIEW public.v_migrated_iopdilation;

CREATE OR REPLACE VIEW public.v_migrated_iopdilation
 AS
 SELECT o.source_datasetid,
    o.source_instanceid,
    o.target_model ->> '_id'::text AS _id,
    (o.target_model -> 'patient'::text) ->> 'id'::text AS patient_id,
    o.target_model ->> 'appointmentDate'::text AS appointmentdate,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'od'::text AS iopdilation_iop_values_od,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'od'::text AS iopdilation_iop_values_od1,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'os'::text AS iopdilation_iop_values_os,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'os'::text AS iopdilation_iop_values_os1,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'date'::text AS iopdilation_iop_values_date,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'time'::text AS iopdilation_iop_values_time,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'date'::text AS iopdilation_iop_values_date1,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'time'::text AS iopdilation_iop_values_time1,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'notes'::text AS iopdilation_iop_values_notes,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'notes'::text AS iopdilation_iop_values_notes1,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 0) ->> 'method'::text AS iopdilation_iop_values_method,
    (((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'values'::text) -> 1) ->> 'method'::text AS iopdilation_iop_values_method1,
    ((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'pachymetry'::text) ->> 'date'::text AS iopdilation_iop_pachymetry_date,
    ((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'pachymetry'::text) ->> 'od'::text AS iopdilation_iop_pachymetry_od,
    ((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'pachymetry'::text) ->> 'os'::text AS iopdilation_iop_pachymetry_os,
    ((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'adjustedIop'::text) ->> 'od'::text AS iopdilation_iop_adjustediop_od,
    ((((o.target_model -> 'data'::text) -> 'iopDilation'::text) -> 'iop'::text) -> 'adjustedIop'::text) ->> 'os'::text AS iopdilation_iop_adjustediop_os
   FROM v_migrated_objects o
  WHERE o.model::text = 'iopdilation'::text;

ALTER TABLE public.v_migrated_iopdilation
    OWNER TO postgres;

