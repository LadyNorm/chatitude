require 'pg'
require 'securerandom'

module Chatserver
  def self.create_db_connection(dbname)
    PG.connect(host: 'localhost', dbname: dbname)
  end

  def self.clear_db(db)
    db.exec <<-SQL
      DELETE FROM users;
    SQL
  end

  def self.create_tables(db)
    db.exec <<-SQL
      CREATE TABLE IF NOT EXISTS users(
        id SERIAL PRIMARY KEY,
        username VARCHAR,
        password VARCHAR
      );
      CREATE TABLE IF NOT EXISTS tokens(
        user_id INTEGER references users(id),
        token VARCHAR
      );
    SQL
  end

  def self.seed_db(db)
    db.exec <<-SQL 
      INSERT INTO users (username, password) values ('anonymous', 'anonymous')
    SQL
  end

  def self.new_user(user_data)

  end

  def self.drop_tables(db)
    db.exec <<-SQL 
      DROP TABLE users CASCADE;
      DROP TABLE tokens CASCADE;
    SQL
  end
end