require 'sinatra'
require 'json'
require 'mysql2'
require 'slim'
require 'dotenv'

Dotenv.load

class AmarokData

  def initialize
    @connection = Mysql2::Client.new host: ENV['STAT_DB_HOST'], username: ENV['STAT_DB_USER'], password: ENV['STAT_DB_PASS'], database: ENV['STAT_DB_DBNAME']
  end

  def counts
    data :counts, (0..10).to_a.map { |x| "`#{x}`" } << '`all`'
  end

  def count_doubles
    data :count_doubles, [:count_id]
  end

  private

  def data(table, fields)
    # _fields = fields.join(', ') + datetime_fields.reduce('') { |acc, (key, val)| acc + ", #{val} AS #{key}" }
    _fields = [:id] + fields + [:datetime]
    data = @connection.query("SELECT #{_fields.join(', ')} FROM #{table} ORDER BY id").each(:as => :array)

    {headers: _fields, data: data}
  end

  # def datetime_fields
  #   field = 'datetime'
  #   { year: "YEAR(#{field})", month: "MONTH(#{field})", day: "DAY(#{field})", hour: "HOUR(#{field})", minute: "MINUTE(#{field})" }
  # end

end

get '/:period' do |period|
  amarok_data = AmarokData.new
  case period
    when 'all'
      content_type :json

      {counts: amarok_data.counts, count_doubles: amarok_data.count_doubles}.to_json
  end
end

get '/' do
  slim :index
end

