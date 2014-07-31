require 'sqlite3'
require 'mysql2'

module AmarokStats

  class Stats

    def initialize
      @ratings = Hash.new(0)
      @count = 0
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
        @ratings[rating] += 1
        @count += 1
      end
    end

    def save
      connection = Mysql2::Client.new host: 'localhost', username: 'amarok', password: 'amarok', database: 'amarok_stats'

      fields = []
      values = []
      @ratings.each do |rating, count|
        fields += rating
        values.push count
      end

      query = "INSERT INTO counts (`#{fields.join('`, `')}`, `all`) VALUES (#{values.join(', ')}, #{@count})"
      connection.query query
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
    end

  end

end
