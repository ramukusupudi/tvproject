
DELETE from source_target_match where source_datasetId ='documents'

INSERT INTO source_target_match (source_datasetId, source_id, source_field, source_value, expected_mapped_value, 
target_id,
target_field, target_value, matched, notes)
SELECT 
  'documents' as source_datasetId,
  source.uid as source_id, 
  match_tests.source_field, match_tests.source_value, match_tests.expected_mapped_value,target._id as target_id,
  match_tests.target_field, match_tests.target_value,
  match_tests.expected_mapped_value is not distinct from match_tests.target_value as matched,match_tests.notes
FROM v_source_patientdocuments as source
FULL JOIN v_migrated_patientdocuments as target ON source.uid = target.source_instanceId
CROSS JOIN LATERAL (VALUES
	('uid', '', CONCAT(source.uid::text,'_',source.patient::text,'_',source.date::text),'digital_assets_id',target.digital_assets_id::text,null),
 	('filename', source.filename::text, source.filename::text, 'name', target.name::text, null),				
	('filename', source.filename, case
when  split_part(source.filename::text,'.', 2 ) = 'aac'		THEN 'audio/aac'
when  split_part(source.filename::text,'.', 2 ) = 'abw'		THEN 'application/x-abiword'
when  split_part(source.filename::text,'.', 2 ) = 'arc'		THEN 'application/x-freearc'
when  split_part(source.filename::text,'.', 2 ) = 'avif'	THEN 'image/avif'
when  split_part(source.filename::text,'.', 2 ) = 'avi'		THEN 'video/x-msvideo'
when  split_part(source.filename::text,'.', 2 ) = 'azw'		THEN 'application/vnd.amazon.ebook'
when  split_part(source.filename::text,'.', 2 ) = 'bin'		THEN 'application/octet-stream'
when  split_part(source.filename::text,'.', 2 ) = 'bmp'		THEN 'image/bmp'
when  split_part(source.filename::text,'.', 2 ) = 'bz'	    THEN 'application/x-bzip'
when  split_part(source.filename::text,'.', 2 ) = 'bz2'		THEN 'application/x-bzip2'
when  split_part(source.filename::text,'.', 2 ) = 'cda'		THEN 'application/x-cdf'
when  split_part(source.filename::text,'.', 2 ) = 'csh'		THEN 'application/x-csh'
when  split_part(source.filename::text,'.', 2 ) = 'css'		THEN 'text/css'
when  split_part(source.filename::text,'.', 2 ) = 'csv'		THEN 'text/csv'
when  split_part(source.filename::text,'.', 2 ) = 'doc'		THEN 'application/msword'
when  split_part(source.filename::text,'.', 2 ) = 'docx'	THEN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
when  split_part(source.filename::text,'.', 2 ) = 'eot'		THEN 'application/vnd.ms-fontobject'
when  split_part(source.filename::text,'.', 2 ) = 'epub'	THEN 'application/epub+zip'
when  split_part(source.filename::text,'.', 2 ) = 'gz'	    THEN 'application/gzip'
when  split_part(source.filename::text,'.', 2 ) = 'gif'		THEN 'image/gif'
when  split_part(source.filename::text,'.', 2 ) = 'htm '	THEN 'text/html'
when  split_part(source.filename::text,'.', 2 ) = 'html'	THEN 'text/html'
when  split_part(source.filename::text,'.', 2 ) = 'ico'		THEN 'image/vnd.microsoft.icon'
when  split_part(source.filename::text,'.', 2 ) = 'ics'		THEN 'text/calendar'
when  split_part(source.filename::text,'.', 2 ) = 'jar'		THEN 'application/java-archive'
when  split_part(source.filename::text,'.', 2 ) = 'jpeg'	THEN 'image/jpeg'
when  split_part(source.filename::text,'.', 2 ) = 'jpg'		THEN 'image/jpeg'
when  split_part(source.filename::text,'.', 2 ) = 'js'	    THEN 'text/javascript'
when  split_part(source.filename::text,'.', 2 ) = 'json'	THEN 'application/json'
when  split_part(source.filename::text,'.', 2 ) = 'jsonld'	THEN 'application/ld+json'
when  split_part(source.filename::text,'.', 2 ) = 'mid'		THEN 'audio/midi audio/x-midi'
when  split_part(source.filename::text,'.', 2 ) = 'midi'	THEN 'audio/midi audio/x-midi'
when  split_part(source.filename::text,'.', 2 ) = 'mjs'		THEN 'text/javascript'
when  split_part(source.filename::text,'.', 2 ) = 'mp3'		THEN 'audio/mpeg'
when  split_part(source.filename::text,'.', 2 ) = 'mp4'		THEN 'video/mp4'
when  split_part(source.filename::text,'.', 2 ) = 'mpeg'	THEN 'video/mpeg'
when  split_part(source.filename::text,'.', 2 ) = 'mpkg'	THEN 'application/vnd.apple.installer+xml'
when  split_part(source.filename::text,'.', 2 ) = 'odp'		THEN 'application/vnd.oasis.opendocument.presentation'
when  split_part(source.filename::text,'.', 2 ) = 'ods'		THEN 'application/vnd.oasis.opendocument.spreadsheet'
when  split_part(source.filename::text,'.', 2 ) = 'odt'		THEN 'application/vnd.oasis.opendocument.text'
when  split_part(source.filename::text,'.', 2 ) = 'oga'		THEN 'audio/ogg'
when  split_part(source.filename::text,'.', 2 ) = 'ogv' 	THEN 'video/ogg'
when  split_part(source.filename::text,'.', 2 ) = 'ogx'	    THEN 'application/ogg'
when  split_part(source.filename::text,'.', 2 ) = 'opus'	THEN 'audio/opus'
when  split_part(source.filename::text,'.', 2 ) = 'otf'		THEN 'font/otf'
when  split_part(source.filename::text,'.', 2 ) = 'png'		THEN 'image/png'
when  split_part(source.filename::text,'.', 2 ) = 'pdf'		THEN 'application/pdf'
when  split_part(source.filename::text,'.', 2 ) = 'php'		THEN 'application/x-httpd-php'
when  split_part(source.filename::text,'.', 2 ) = 'ppt'		THEN 'application/vnd.ms-powerpoint'
when  split_part(source.filename::text,'.', 2 ) = 'pptx'	THEN 'application/vnd.openxmlformats-officedocument.presentationml.presentation'
when  split_part(source.filename::text,'.', 2 ) = 'rar'		THEN 'application/vnd.rar'
when  split_part(source.filename::text,'.', 2 ) = 'rtf'		THEN 'application/rtf'
when  split_part(source.filename::text,'.', 2 ) = 'sh'	    THEN 'application/x-sh'
when  split_part(source.filename::text,'.', 2 ) = 'svg'		THEN 'image/svg+xml'
when  split_part(source.filename::text,'.', 2 ) = 'tar'		THEN 'application/x-tar'
when  split_part(source.filename::text,'.', 2 ) = 'tiff'   	THEN 'image/tiff'
when  split_part(source.filename::text,'.', 2 ) = 'tif'   	THEN 'image/tiff'
when  split_part(source.filename::text,'.', 2 ) = 'ts'	    THEN 'video/mp2t'
when  split_part(source.filename::text,'.', 2 ) = 'ttf'		THEN 'font/ttf'
when  split_part(source.filename::text,'.', 2 ) = 'txt'		THEN 'text/plain'
when  split_part(source.filename::text,'.', 2 ) = 'vsd'		THEN 'application/vnd.visio'
when  split_part(source.filename::text,'.', 2 ) = 'wav'		THEN 'audio/wav'
when  split_part(source.filename::text,'.', 2 ) = 'weba'	THEN 'audio/webm'
when  split_part(source.filename::text,'.', 2 ) = 'webm'	THEN 'video/webm'
when  split_part(source.filename::text,'.', 2 ) = 'webp'	THEN 'image/webp'
when  split_part(source.filename::text,'.', 2 ) = 'woff'	THEN 'font/woff'
when  split_part(source.filename::text,'.', 2 ) = 'woff2'	THEN 'font/woff2'
when  split_part(source.filename::text,'.', 2 ) = 'xhtml'	THEN 'application/xhtml+xml'
when  split_part(source.filename::text,'.', 2 ) = 'xls'		THEN 'application/vnd.ms-excel'
when  split_part(source.filename::text,'.', 2 ) = 'xlsx'	THEN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
when  split_part(source.filename::text,'.', 2 ) = 'xml'		THEN 'application/xml' 
when  split_part(source.filename::text,'.', 2 ) = 'xul'		THEN 'application/vnd.mozilla.xul+xml'
when  split_part(source.filename::text,'.', 2 ) = 'zip'		THEN 'application/zip'
when  split_part(source.filename::text,'.', 2 ) = '3gp'		THEN 'video/3gpp'
when  split_part(source.filename::text,'.', 2 ) = '3g2'		THEN 'video/3gpp2'
when  split_part(source.filename::text,'.', 2 ) = '7z'		THEN 'application/x-7z-compressed'
end::text,'documenttype',target.documenttype::text, null)				
)as match_tests(source_field, source_value, expected_mapped_value, target_field, target_value, notes)
;
