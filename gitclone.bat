@echo off
setlocal enabledelayedexpansion

echo Starting dataset download and extraction...

if not exist "handwritting_data_all" (
    echo Cloning repository...
    git clone https://github.com/chenkenanalytic/handwritting_data_all.git
) else (
    echo Repository already cloned.
)

cd handwritting_data_all
set OUTPUT=..\all_data.zip
if exist %OUTPUT% del %OUTPUT%
set FIRST=true
echo Combining ZIP parts...
for /f "delims=" %%f in ('dir /b /on all_data.zip.*') do (
    if !FIRST! == true (
        copy /b "%%f" %OUTPUT% >nul
        set FIRST=false
    ) else (
        copy /b %OUTPUT% + "%%f" %OUTPUT% >nul
    )
)
echo ZIP parts combined into %OUTPUT%.

cd ..
set EXTRACT_DIR=data
if not exist "%EXTRACT_DIR%" mkdir "%EXTRACT_DIR%"
echo Extracting ZIP (this may take 10-30 minutes)...
powershell -Command "Expand-Archive -Path all_data.zip -DestinationPath %EXTRACT_DIR% -Force"
echo Extraction complete. Data is in %EXTRACT_DIR%\cleaned_data\


pause