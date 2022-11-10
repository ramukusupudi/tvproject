-- Table: public.migrated_objects

-- DROP TABLE IF EXISTS public.migrated_objects;

CREATE TABLE IF NOT EXISTS public.migrated_objects
(
    uid uuid NOT NULL DEFAULT uuid_generate_v4(),
    created timestamp(6) with time zone,
    model character varying COLLATE pg_catalog."default",
    action character varying COLLATE pg_catalog."default",
    domain_store_table character varying COLLATE pg_catalog."default",
    domain_store_id character varying COLLATE pg_catalog."default",
    sources jsonb,
    target_model jsonb,
    error jsonb,
    CONSTRAINT migrated_objects_pkey PRIMARY KEY (uid)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.migrated_objects
    OWNER to postgres;