@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"
title 小遊戲大廳 - 一鍵部署到 GitHub Pages
echo ==============================================
echo    小遊戲大廳  一鍵部署到 GitHub Pages
echo ==============================================
echo.
where git >nul 2>nul
if errorlevel 1 goto nogit

echo 請先到 GitHub 建立一個新的 repository，然後把網址貼在下面。
echo 例如： https://github.com/你的帳號/game-hub
echo.
set "URL="
set /p URL=請貼上 repository 網址後按 Enter： 
if not defined URL goto nourl
set "URL=%URL:"=%"
set "URL=%URL: =%"

set "P=%URL:https://github.com/=%"
set "OWNER="
set "REPO="
for /f "tokens=1,2 delims=/" %%a in ("%P%") do (set "OWNER=%%a"&set "REPO=%%b")
if /i "%REPO:~-4%"==".git" set "REPO=%REPO:~0,-4%"

echo.
echo [1/4] 準備本機 git ...
if not exist ".git" git init
git config user.name >nul 2>nul || git config user.name "game-hub"
git config user.email >nul 2>nul || git config user.email "game-hub@users.noreply.github.com"
git add -A
git commit -m "deploy game hub" >nul 2>nul
git branch -M main
git remote remove origin >nul 2>nul
git remote add origin "%URL%"

echo.
echo [2/4] 上傳到 GitHub ... 如果跳出登入視窗，請依指示登入。
git push -u origin main
if errorlevel 1 goto pushfail
goto pushok

:pushfail
echo.
echo 上傳失敗。常見原因是這個 repository 裡已經有內容（例如建立時勾了 README）。
set "F="
set /p F=要用目前這個資料夾強制覆蓋嗎？輸入 Y 覆蓋，其他鍵取消： 
if /i not "%F%"=="Y" goto cancel
git push -u origin main --force
if errorlevel 1 goto fail

:pushok
echo.
echo [3/4] 上傳完成。
if not defined OWNER goto nopages
if not defined REPO goto nopages

echo [4/4] 嘗試自動開啟 GitHub Pages ...
where gh >nul 2>nul
if errorlevel 1 goto manual
gh api -X POST repos/%OWNER%/%REPO%/pages -f build_type=workflow >nul 2>nul
if errorlevel 1 goto manual
gh workflow run deploy.yml -R %OWNER%/%REPO% >nul 2>nul
echo 已自動啟用 GitHub Pages。
goto finish

:manual
echo.
echo 還差最後一步，只需要做一次：
echo   1. 在剛打開的設定頁，把 Source 選成 GitHub Actions
echo   2. 到 Actions 頁面，對失敗的那一筆按 Re-run all jobs
start "" "https://github.com/%OWNER%/%REPO%/settings/pages"
timeout /t 2 >nul

:finish
echo.
echo ==============================================
echo  完成！約 1 到 2 分鐘後，你的遊戲網站網址是：
echo.
echo    https://%OWNER%.github.io/%REPO%/
echo.
echo ==============================================
start "" "https://github.com/%OWNER%/%REPO%/actions"
goto end

:nopages
echo.
echo 無法從網址判斷帳號與 repository 名稱，請到 GitHub 的 Settings 的 Pages，把 Source 選成 GitHub Actions。
goto end

:nogit
echo 找不到 git，請先安裝： https://git-scm.com/download/win
echo 安裝完成後重新執行這個檔案。
goto end

:nourl
echo 沒有輸入網址，已取消。
goto end

:cancel
echo 已取消，沒有覆蓋任何內容。
goto end

:fail
echo.
echo 部署失敗，請確認網址正確，而且你的帳號有這個 repository 的寫入權限。

:end
echo.
pause
endlocal
