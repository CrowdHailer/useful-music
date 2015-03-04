require_relative './discount/record'

class Discounts < Errol::Repository
  require_relative './discounts/query'
  
  record_class ::Discount::Record
  entity_class ::Discount
  query_class Query
end
