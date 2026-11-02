# 🎮 小遊戲大廳

純靜態網站（沒有建置步驟、沒有後端），包含：

| 遊戲 | 路徑 |
| --- | --- |
| 🧩 線上拼圖 | `games/jigsaw/` |
| 🧠 智慧闖關王 | `games/quiz/` |

首頁 `index.html` 是遊戲大廳，連到上面兩個遊戲。

## 一鍵部署（Windows）

先到 GitHub 建立一個新的 repository，然後雙擊 `deploy.bat`，貼上 repository 網址即可。需要先安裝 [Git](https://git-scm.com/download/win)；若有安裝 GitHub CLI（`gh`），連 Pages 也會自動開啟。

## 手動部署到 GitHub Pages

1. 在 GitHub 建立新 repository（例如 `game-hub`）。
2. 把這個資料夾的內容推上去（分支名稱為 `main`）：
   ```bash
   git init
   git add .
   git commit -m "init"
   git branch -M main
   git remote add origin https://github.com/<你的帳號>/game-hub.git
   git push -u origin main
   ```
3. 到 repository 的 **Settings → Pages**，把 **Source** 選為 **GitHub Actions**（只需要設定一次）。
4. 推送後 Actions 會自動部署，完成後網址是：
   `https://<你的帳號>.github.io/game-hub/`

之後每次推送到 `main` 都會自動重新部署。

## 本機預覽

```bash
python3 -m http.server 8000
```

開啟 http://localhost:8000 即可。

## 新增遊戲

在 `games/<名稱>/index.html` 放一個單檔遊戲，再到根目錄 `index.html` 複製一張 `<a class="g">` 卡片、改連結與文字。

## 備註

遊戲進度存在瀏覽器 localStorage（拼圖：`jigsaw-save-v1`，闖關王：`zhiwang`），換瀏覽器或清除網站資料就會消失。
