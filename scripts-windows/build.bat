@call env.bat

cd ..

call gcloud builds submit ^
--tag gcr.io/%PROJECT_ID%/%IMAGE_NAME%
@if errorlevel 1 goto err_out

call gcloud beta run deploy %SERVICE_NAME% ^
--region %REGION% ^
--image gcr.io/%PROJECT_ID%/%IMAGE_NAME% ^
--allow-unauthenticated
@if errorlevel 1 goto err_out

goto end

:err_out
@echo ***************************************************************
@echo Build Failed     Build Failed     Build Failed     Build Failed
@echo ***************************************************************

:end
cd scripts-windows
