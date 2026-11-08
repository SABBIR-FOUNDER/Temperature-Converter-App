@echo off
setlocal
set GRADLE_VERSION=8.14.3
if "%GRADLE_USER_HOME%"=="" set GRADLE_USER_HOME=%USERPROFILE%\.gradle
set GRADLE_HOME=%GRADLE_USER_HOME%\manual-wrapper\gradle-%GRADLE_VERSION%
if not exist "%GRADLE_HOME%\bin\gradle.bat" (
  if not exist "%GRADLE_USER_HOME%\manual-wrapper" mkdir "%GRADLE_USER_HOME%\manual-wrapper"
  set ZIP_FILE=%GRADLE_USER_HOME%\manual-wrapper\gradle-%GRADLE_VERSION%-bin.zip
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://services.gradle.org/distributions/gradle-%GRADLE_VERSION%-bin.zip' -OutFile '%GRADLE_USER_HOME%\manual-wrapper\gradle-%GRADLE_VERSION%-bin.zip'; Expand-Archive -Path '%GRADLE_USER_HOME%\manual-wrapper\gradle-%GRADLE_VERSION%-bin.zip' -DestinationPath '%GRADLE_USER_HOME%\manual-wrapper' -Force; Remove-Item '%GRADLE_USER_HOME%\manual-wrapper\gradle-%GRADLE_VERSION%-bin.zip'"
  if errorlevel 1 exit /b 1
)
call "%GRADLE_HOME%\bin\gradle.bat" -p "%~dp0." %*
endlocal
