class Discounts
  class Query < Errol::Repository::Query
    default :order, :code
    default :page, 1
    default :page_size, 15
  end
end
