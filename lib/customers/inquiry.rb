class Customers
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 15
  end
end
