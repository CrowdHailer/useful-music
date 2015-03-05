require_relative './discount/record'
require_relative './errol/repository'

class Discounts < Errol::Repository
  require_relative './discounts/query'

  record_class ::Discount::Record
  entity_class ::Discount
  query_class Query

  def implant(record)
    Discount.new(record)
  end

  # dataset ::Discount::Record.dataset
  # query   Query
  # implant { |record| Discount.new record }
  # extract { |entity| entity.record }
end
