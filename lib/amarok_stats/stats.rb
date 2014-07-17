require 'sqlite3'
require 'mysql2'

module AmarokStats

  class Stats

    def initialize
      @ratings = Hash.new(0)
      @query_result = []
    end

    def retrieve
      connection = Mysql2::Client.new host: 'localhost', username: 'amarok', password: 'amarok', database: 'amarokdb'

      @query_result = connection.query 'SELECT rating FROM statistics WHERE deleted = 0'
    end

    def calculate
      @query_result.each(as: :array) do |rating|
        @ratings[rating] += 1
      end

      puts @ratings
    end

  end

end
