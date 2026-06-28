@echo off
chcp 65001 >nul
setlocal

echo ==================================
echo   筆順讀音  安裝程式
echo   在這台電腦的桌面建立 App 捷徑
echo ==================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Continue'; $url='https://talkbetter.github.io/D19/w.html'; $icoUrl='https://talkbetter.github.io/D19/icon.ico'; $name=[string][char]0x7b46+[char]0x9806+[char]0x8b80+[char]0x97f3; $dir=Join-Path $env:LOCALAPPDATA 'BishunReading'; if(-not(Test-Path $dir)){New-Item -ItemType Directory -Path $dir | Out-Null}; $ico=Join-Path $dir 'icon.ico'; try{Invoke-WebRequest -Uri $icoUrl -OutFile $ico -UseBasicParsing}catch{Write-Host '圖示下載失敗，將用瀏覽器預設圖示'}; $cands=@(($env:ProgramFiles+'\Google\Chrome\Application\chrome.exe'),(${env:ProgramFiles(x86)}+'\Google\Chrome\Application\chrome.exe'),($env:LOCALAPPDATA+'\Google\Chrome\Application\chrome.exe'),($env:ProgramFiles+'\Microsoft\Edge\Application\msedge.exe'),(${env:ProgramFiles(x86)}+'\Microsoft\Edge\Application\msedge.exe')); $browser=$cands | Where-Object{Test-Path $_} | Select-Object -First 1; if(-not $browser){Write-Host '找不到 Chrome 或 Edge，安裝中止'; exit 1}; $desktop=[Environment]::GetFolderPath('Desktop'); $lnk=Join-Path $desktop ($name+'.lnk'); $w=New-Object -ComObject WScript.Shell; $s=$w.CreateShortcut($lnk); $s.TargetPath=$browser; $s.Arguments='--app='+$url; $s.Description='筆順讀音'; if(Test-Path $ico){$s.IconLocation=$ico+',0'}; $s.Save(); Write-Host ''; Write-Host ('完成！已在桌面建立捷徑：'+$lnk); Write-Host ('使用瀏覽器：'+$browser)"

echo.
pause
