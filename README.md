# README

にじさんじライバー天宮こころファンサイト「りすみゃ～広報」

# Version
Ruby 2.5.5
Rails 5.1.6
動作想定サーバー Heroku

# 簡単な内容
各ページはほぼ静的ページだが、表示データの一部で各種APIを使用している。

# 使用しているAPIとその利用法
- Google YouTube_v3([公式リファレンス](https://developers.google.com/youtube/v3?hl=ja))
    - lib/tasks/youtube_api.rakeで利用
        - トップページの再生数トップ動画を一定間隔で取得しDBを入れ替えている
- Google Sheets_v4([公式リファレンス](https://developers.google.com/sheets/api))
    - lib/tasks/sheets_api.rakeで利用
        - historyページの内容をGoogle Spreadsheetを使い共同管理(共同編集可能なDBとして利用)
- Twitter API([公式リファレンス](https://developer.twitter.com/en/docs/api-reference-index))
    - app/controllers/static_pages_controller.rbで利用
        - 表示上は「Illust」ページ。各種フィルター設定は[こちらを参照](https://gist.github.com/cucmberium/e687e88565b6a9ca7039)

## API KEYについて
Google/TwitterのAPI利用には各サイトに申請をし、KEYを取得する必要がある。取得方法はググって。
GoogleアカウントがあればYoutubeとSpreadsheetはそんなに難しくない。
Twitterは利用目的の英文を書くのが非常に面倒だが、日本語文をGoogle翻訳してコピペでいける。
KEYを書く場所は「config/secrets.yml」で書き方は[こちらを参照](https://qiita.com/biohuns/items/40c39e15804a6a28b7e1)
API KEYの命名は以下
- youtube_api_key → Spreadsheetと同じKEYを利用できる
- twitter_api_key
- twitter_secret_key

# Herokuについて
サーバーはHerokuの無料枠を利用している。
クレカの登録をすると無料枠が550→1000時間になり、スリープさせることなく利用可能。
※スリープすると次にアクセスがあった時に表示が非常に遅くなる。

## 利用しているAdd onについて
- Heroku Postgres 
    - Herokuで使うデータベース(DB)
- Heroku Scheduler
    - 設定時間に指定コマンドを送信してくれるアドオン。設定内容は以下
        - curl https://ama38556-fan.herokuapp.com/
            - 10分毎に指定URLにアクセスさせる → URLを自サイトにすることでサーバーのスリープ対策
        - rake sheets_api:update
            - Spreadsheetのデータを取得しDBを更新する(2,3日毎4:00頃)
        - rake youtube_api:playlist
            - Youtubeからデータを取得しDBを更新する(毎日5:00頃)

## デプロイ(サーバーに反映させる)方法
[ここ参照](https://qiita.com/kazukimatsumoto/items/a0daa7281a3948701c39)
場合によっては必要なコマンドが
```
rake db:migrate
```
だけだったりする。
