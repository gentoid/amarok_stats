require 'amarok_stats/stats'

describe AmarokStats::Stats do

  before :each do
    @stats = AmarokStats::Stats.new
  end

  context 'testing' do
    subject(:zombie) { AmarokStats::Stats.new }

    it { is_expected.to be_instance_of AmarokStats::Stats }

    it 'should stub' do
      AmarokStats::Stats.stub(:original)
      AmarokStats::Stats.original
    end

    it_behaves_like 'one'
  end

  context '#retreive' do
    before do
      @connection = double
      mysql_stub = double
      allow(mysql_stub).to receive(:new).and_return(@connection)

      stub_const('Mysql2::Client', mysql_stub)
    end

    it 'makes a query' do
      allow(@connection).to receive(:query)

      expect(@connection).to receive(:query)

      @stats.retrieve
    end

    it 'query is a SELECT ... FROM ...' do
      allow(@connection).to receive(:query) do |query|
        expect(query).to match(/^SELECT.+FROM.+/)
      end

      @stats.retrieve
    end

  end

  it 'calculates stats for amarok collection and returns stats as a Hash' do
    class AmarokStats::Stats
      attr_accessor :query_result
    end
    @stats.query_result = [5, 7, 9, 6, 7, 7, 8, 8, 8, 9, 10]

    expect(@stats.calculate).to be_a Hash
  end

end
