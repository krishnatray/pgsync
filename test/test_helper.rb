require "bundler/setup"
Bundler.require(:default)
require "minitest/autorun"
require "minitest/pride"
require "pg"
require "shellwords"
require "tmpdir"

conn1 = PG::Connection.open(dbname: "pgsync_test1")
conn1.exec <<-SQL
DROP TABLE IF EXISTS "Users";
DROP TYPE IF EXISTS mood;
CREATE TYPE mood AS ENUM ('sad', 'ok', 'happy');
CREATE TABLE "Users" (
  "Id" SERIAL PRIMARY KEY,
  zip_code TEXT,
  email TEXT,
  phone TEXT,
  token TEXT,
  attempts INT,
  created_on DATE,
  updated_at TIMESTAMP,
  ip TEXT,
  name TEXT,
  nonsense TEXT,
  untouchable TEXT,
  "column_with_punctuation?" BOOLEAN,
  current_mood mood
);

DROP SCHEMA IF EXISTS other CASCADE;
CREATE SCHEMA other;
CREATE TABLE other.posts (
  id SERIAL PRIMARY KEY
);
SQL
conn1.close

conn2 = PG::Connection.open(dbname: "pgsync_test2")
conn2.exec <<-SQL
DROP TABLE IF EXISTS "Users";
CREATE TABLE "Users" (
  "Id" SERIAL PRIMARY KEY,
  email TEXT,
  phone TEXT,
  token TEXT,
  attempts INT,
  created_on DATE,
  updated_at TIMESTAMP,
  ip TEXT,
  name TEXT,
  nonsense TEXT,
  untouchable TEXT,
  "column_with_punctuation?" BOOLEAN
);
SQL
conn2.close
