require 'sqlite3'
require 'mysql2'

module AmarokStats

  class Stats

    def initialize
      @ratings = Hash.new(0)
      @query_result = []
    end

    def run
      retrieve
      calculate
      save
    end

    def retrieve
      connection = Mysql2::Client.new host: 'localhost', username: 'amarok', password: 'amarok', database: 'amarokdb'

      @query_result = connection.query 'SELECT rating FROM statistics WHERE deleted = 0'
    end

    def calculate
      @query_result.each(as: :array) do |rating|
        @ratings[rating[0].to_s.to_sym] += 1
        @ratings[:all] += 1
      end
    end

    def save
      connection = Mysql2::Client.new host: 'localhost', username: 'amarok', password: 'amarok', database: 'amarok_stats'

      connection.query("SELECT `id`, `#{@ratings.keys.join('`, `')}` FROM counts ORDER BY id DESC LIMIT 1", symbolize_keys: true).each do |line|
        id = line.delete :id

        if @ratings == line
          connection.query "INSERT INTO count_doubles (count_id) VALUES (#{id})"
        else
          connection.query "INSERT INTO counts (`#{fields.join('`, `')}`) VALUES (#{values.join(', ')})"
        end
      end
    end

    def init_db
      mysql = Mysql2::Client.new host: 'localhost', username: 'amarok', password: 'amarok', database: 'amarok_stats'

      mysql.query 'CREATE TABLE IF NOT EXISTS counts (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
       `0` INTEGER NOT NULL DEFAULT 0,
       `1` INTEGER NOT NULL DEFAULT 0,
       `2` INTEGER NOT NULL DEFAULT 0,
       `3` INTEGER NOT NULL DEFAULT 0,
       `4` INTEGER NOT NULL DEFAULT 0,
       `5` INTEGER NOT NULL DEFAULT 0,
       `6` INTEGER NOT NULL DEFAULT 0,
       `7` INTEGER NOT NULL DEFAULT 0,
       `8` INTEGER NOT NULL DEFAULT 0,
       `9` INTEGER NOT NULL DEFAULT 0,
      `10` INTEGER NOT NULL DEFAULT 0,
      `all` INTEGER NOT NULL DEFAULT 0,
      `datetime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP)'

      mysql.query 'CREATE TABLE IF NOT EXISTS count_doubles (
        id INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
        `count_id` INTEGER NOT NULL,
        `datetime` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY(count_id) REFERENCES counts(id) )'
    end

  end

end
