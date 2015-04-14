class Piece
  class Create
    class Validator
      # untested because admin control
      include Veto.validator

      validates :title, :presence => true
    end
  end
end
