class Discounts
  class Inquiry < Errol::Inquiry
    default :order, :code
    default :page, 1
    default :page_size, 15
    default :available, false
    default :code, nil
  end
end
