require 'pg'

conn = PG.connect(
  dbname: 'postgres',
  host: 'localhost',
  port: 5432,
  sslmode: 'disable'
)

conn.exec('CREATE TABLE IF NOT EXISTS users (id serial PRIMARY KEY, title varchar, memo varchar)')

conn.close
