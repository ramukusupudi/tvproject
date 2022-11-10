-- Table: public.source_target_match

-- DROP TABLE IF EXISTS public.source_target_match;

CREATE TABLE IF NOT EXISTS public.source_target_match
(
    source_datasetid text COLLATE pg_catalog."default" NOT NULL,
    source_id text COLLATE pg_catalog."default" NOT NULL,
    source_field text COLLATE pg_catalog."default",
    source_value text COLLATE pg_catalog."default",
    expected_mapped_value text COLLATE pg_catalog."default",
    target_id text COLLATE pg_catalog."default",
    target_field text COLLATE pg_catalog."default" NOT NULL,
    target_value text COLLATE pg_catalog."default",
    notes text COLLATE pg_catalog."default",
    matched boolean NOT NULL,
    CONSTRAINT source_target_match_pkey PRIMARY KEY (source_id, target_field)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.source_target_match
    OWNER to postgres;
-- Index: idx_match_source_dataset

-- DROP INDEX IF EXISTS public.idx_match_source_dataset;

CREATE INDEX IF NOT EXISTS idx_match_source_dataset
    ON public.source_target_match USING btree
    (source_datasetid COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_match_source_id

-- DROP INDEX IF EXISTS public.idx_match_source_id;

CREATE INDEX IF NOT EXISTS idx_match_source_id
    ON public.source_target_match USING btree
    (source_id COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_match_target_id_idx

-- DROP INDEX IF EXISTS public.idx_match_target_id_idx;

CREATE INDEX IF NOT EXISTS idx_match_target_id_idx
    ON public.source_target_match USING btree
    (target_id COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;