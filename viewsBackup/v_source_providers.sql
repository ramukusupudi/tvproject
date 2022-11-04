-- View: public.v_source_providers

-- DROP VIEW public.v_source_providers;

CREATE OR REPLACE VIEW public.v_source_providers
 AS
 SELECT employees.uid,
    employees.designation,
    employees.firstname,
    employees.lastname,
    employees.sex AS sexs,
    providers.location_list,
    employees.employee_number,
    employees.available,
    employees.birthday,
    employees.notes,
    employees.home_address,
    employees.home_city,
    employees.home_state,
    employees.home_zip,
    employees.homephone,
    employees.officephone,
    employees.cell,
    employees.email,
    employees.provider,
    employees.direct_address,
    provider_signons.username,
    provider_signons.password,
    provider_signons.signature,
    providers.npi_number,
    providers.professional_eq,
    providers.optical_eq,
    providers.surgical_eq,
    providers.contact_eq,
    providers.on_line,
    providers.uid AS prov_id,
    provider_ids.id,
    provider_ids.scope,
    ( SELECT provider_ids_1.id
           FROM provider_ids provider_ids_1
          WHERE ((provider_ids_1.type = 0) AND ((provider_ids_1.provider)::text = (providers.uid)::text))) AS license_ids,
    ( SELECT provider_ids_1.id
           FROM provider_ids provider_ids_1
          WHERE ((provider_ids_1.type = 1) AND ((provider_ids_1.provider)::text = (providers.uid)::text))) AS dea_ids,
    ( SELECT provider_ids_1.scope
           FROM provider_ids provider_ids_1
          WHERE ((provider_ids_1.type = 1) AND ((provider_ids_1.provider)::text = (providers.uid)::text))) AS state
   FROM (((employees
     LEFT JOIN providers ON (((employees.provider)::text = (providers.uid)::text)))
     LEFT JOIN provider_signons ON ((((provider_signons.provider)::text = (providers.uid)::text) AND (provider_signons.signon_type = 1))))
     LEFT JOIN provider_ids ON ((((provider_ids.provider)::text = (providers.uid)::text) AND (provider_ids.type = 1))));

ALTER TABLE public.v_source_providers
    OWNER TO postgres;

