class Orders
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 15
    default :succeded, nil
    default :customer, nil
    default :discount, nil
  end
end
