::Run SQL verification scripts for Windows

@echo off
setlocal enableextensions enabledelayedexpansion

SET host="e360demopostgres.ccm4b2ghgpmx.us-east-1.rds.amazonaws.com"
SET port=5432
SET databaseName="e360DemoPostgres"
SET username="postgres"
SET password="postgres_123"
SET psql="C:\Program Files\pgAdmin 4\v6\runtime\psql.exe"

:: clear all previous matching results
echo Truncating table: source_target_match
%psql% -c "TRUNCATE TABLE source_target_match" postgresql://%username%:%password%@%host%:%port%/%databasename%?sslmode=require 

for %%f in ("*.sql") do (
    echo Running file: %%f
    %psql% --file "%%f" postgresql://%username%:%password%@%host%:%port%/%databasename%?sslmode=require 
)

echo All SQL files in current path have been executed.
