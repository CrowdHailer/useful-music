require_relative './discount/record'
require_relative './discounts/query'

class Discounts < Errol::Repository
  record_class ::Discount::Record
  entity_class ::Discount
  query_class Query
end
