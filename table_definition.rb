require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  host: 'localhost',
  port: 5432,
  sslmode: 'disable'
)

# テーブルを作成
conn.exec('CREATE TABLE IF NOT EXISTS users (id serial PRIMARY KEY, title varchar, memo varchar)')

# データを挿入
conn.exec("INSERT INTO users (title, memo) VALUES ('Alice', 'Memo for Alice')")
conn.exec("INSERT INTO users (title, memo) VALUES ('Bob', 'Memo for Bob')")

# データを取得して表示
result = conn.exec('SELECT * FROM users')

result.each do |row|
  puts "ID: #{row['id']}, Title: #{row['title']}, Memo: #{row['memo']}"
end

# conn.exec('DROP TABLE IF EXISTS users')

conn.close
