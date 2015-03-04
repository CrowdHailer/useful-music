class Catalogue
  class Query < Errol::Repository::Query
    default :order, :id
    default :page, 1
    default :page_size, 15
    default :title, nil
    default :levels, []
    default :instruments, []
    default :categories, []
  end
end
