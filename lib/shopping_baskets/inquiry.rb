class ShoppingBaskets
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 15
    default :checked_out, false
    default :discount, nil
  end
end
