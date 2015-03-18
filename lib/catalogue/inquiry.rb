class Catalogue
  class Inquiry < Errol::Inquiry
    default :order, :id
    default :page, 1
    default :page_size, 12
    default :title, nil
    default :title_like, nil
    default :levels, []
    default :instruments, []
    default :categories, []
  end
end
