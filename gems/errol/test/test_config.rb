require 'errol'
require 'minitest/autorun'
require 'minitest/reporters'
require 'sequel'

reporter_options = {color: true, slow_count: 5}
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

DB = Sequel.sqlite

DB.create_table :items do
  primary_key :id
  String :name
  TrueClass :discounted
  Float :price
end
DB.extension(:pagination)

class RecordTest < MiniTest::Test

  def run(*args, &block)
    result = nil
    Sequel::Model.db.transaction(:rollback=>:always, :auto_savepoint=>true){result = super}
    result
  end

end
