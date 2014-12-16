require 'pg'
require 'securerandom'

module Chat
  class DB

    def self.create_db_connection
      PG.connect(host: 'localhost', dbname: 'chatitude')
    end

    def self.clear_db(db)
      db.exec <<-SQL
        DELETE FROM users;
        DELETE FROM api_tokens;
      SQL
    end

    def self.create_tables
      db.exec <<-SQL
        CREATE TABLE IF NOT EXISTS users(
          id SERIAL PRIMARY KEY,
          username VARCHAR,
          password VARCHAR
        ); 
        CREATE TABLE IF NOT EXISTS api_tokens(
          id          SERIAL PRIMARY KEY,
          user_id     INTEGER REFERENCES users(id),
          api_token   VARCHAR
        );
        CREATE TABLE IF NOT EXISTS chats(
          id        SERIAL PRIMARY KEY,
          username  VARCHAR,
          time      TIMESTAMP,
          message   VARCHAR
         );
       SQL
    end

    def self.drop_tables
      db.exec <<-SQL
        DROP TABLE users CASCADE;
        DROP TABLE api_tokens CASCADE;
        DROP TABLE chats CASCADE;
      SQL
    end

    def self.new_user(name, pword, db)
      sql = <<-SQL
        INSERT INTO users (username, password)
        values ($1, $2) returning *
        SQL
      db.exec(sql, [name, pword]).to_a.first    
    end

    def self.find_user_byname(username, db)
      db.exec("SELECT * FROM users where username = $1", [username]).to_a.first
    end

    def self.generate_apitoken
      SecureRandom.hex
    end

    def self.find_user_byapi(api_token, db)
      db.exec("SELECT username FROM users JOIN api_tokens ON users.id = api_tokens.user_id WHERE user_id = $1", [users.username]).to_a.first
    end

    def self.find_api_key(user_id, db)
      db.exec("SELECT api_token FROM api_tokens WHERE user_id = $1", [user_id]).entries.first
    end

    def self.new_message(message, api_token)
      db.exec <<-SQL
        INSERT INTO chats ()
      SQL
    end

    def self.all_chats()
      sql = <<-SQL
        SELECT * FROM chats
      SQL
      db.exec(sql)
    end

  end
end