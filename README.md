# Sinatora勉強用リポジトリ
目的: Sinatraを用いて、簡単なメモアプリを作成すること

# 環境
ruby 3.2.2

# 再現方法
## 以下の順にコマンドを実行し、実行環境を作ります。
(1) コードをgithubから複製
```
git clone git@github.com:medyuya/Sinatra-practices.git -b my-sinatra-memo-app
```
(2)
```
cd Sinatra-practices
```
(3) ライブラリのインストール
```
bundle install
```
(4) リンターの実行
```
rubocop
```
(5) リンターの実行
```
bundle exec erblint --lint-all
```
(6) ローカルでアプリを起動
```
bundle exec ruby app.rb
```
