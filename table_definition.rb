# frozen_string_literal: true

require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  host: 'localhost',
  port: 5432,
  sslmode: 'disable'
)

# テーブルを作成
conn.exec('CREATE TABLE IF NOT EXISTS users (id serial PRIMARY KEY, title varchar, memo varchar)')

conn.close
