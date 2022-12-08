CREATE OR REPLACE VIEW public.v_source_digitalAssets
 AS
 select uid,patient,insurance,front,back from insurance_cards ic;
 
 ALTER TABLE public.v_source_digitalAssets
    OWNER TO postgres;
	
	
	
