@REM to get your current Project ID
@REM gcloud config list project

@set PROJECT_ID=replace_with_your_project_id
@set REGION=us-central1
@set SERVICE_NAME=sample-flask-example
@set IMAGE_NAME=sample-flask-example

@REM This code gets the Project ID from gcloud
call gcloud config get-value project > project.tmp
for /f "delims=" %%x in (project.tmp) do set PROJECT_ID=%%x
echo Project ID: %PROJECT_ID%
