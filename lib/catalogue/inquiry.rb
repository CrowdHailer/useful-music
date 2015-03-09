class Catalogue
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 15
    default :title, nil
    default :levels, []
    default :instruments, []
    default :categories, []
  end
end
