class Piece
  class Create
    class Validator
      # TODO untested because admin control
      include Veto.validator

      validates :title, :presence => true
    end
  end
end
