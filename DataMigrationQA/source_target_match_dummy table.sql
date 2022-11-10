-- Table: public.source_target_match_dummy

-- DROP TABLE IF EXISTS public.source_target_match_dummy;

CREATE TABLE IF NOT EXISTS public.source_target_match_dummy
(
    source_datasetid text COLLATE pg_catalog."default",
    source_id text COLLATE pg_catalog."default",
    source_field text COLLATE pg_catalog."default",
    source_value text COLLATE pg_catalog."default",
    expected_mapped_value text COLLATE pg_catalog."default",
    target_id text COLLATE pg_catalog."default",
    target_field text COLLATE pg_catalog."default",
    target_value text COLLATE pg_catalog."default",
    notes text COLLATE pg_catalog."default",
    matched boolean NOT NULL
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.source_target_match_dummy
    OWNER to postgres;