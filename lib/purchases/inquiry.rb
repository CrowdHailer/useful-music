class Purchases
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 15
    default :shopping_basket, nil
    default :item, nil
  end
end
