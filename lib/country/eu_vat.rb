class Country
  class EUVAT
    DEFAULT_RATE = 0
    def initialize(country)
      @country = country
    end

    attr_reader :country, :rates

    def to_i
      (country.vat_rates || {'standard' => DEFAULT_RATE})['standard']
    end

    def to_f
      to_i / 100.0
    end

    def to_s
      "%d%" % to_i
    end

    def *(n)
      to_f * n
    end

  end
end
