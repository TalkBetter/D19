@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ============================
echo   筆順讀音  部署到 GitHub Pages
echo ============================
echo.

git add -A
git commit -m "Update site %date% %time%"
git push origin main

echo.
if %errorlevel%==0 (
  echo === 部署完成！ ===
) else (
  echo === 沒有變更或推送失敗，請看上面訊息 ===
)
echo 網址: https://talkbetter.github.io/D19/w.html
echo.
pause
