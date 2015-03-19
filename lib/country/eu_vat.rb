class Country
  class EUVAT
    DEFAULT_RATE = 0
    RATES = {
      Country.new('AT').alpha2 => 0.21,
      Country.new('BE').alpha2 => 0.21,
      Country.new('BG').alpha2 => 0.21,
      Country.new('HR').alpha2 => 0.21,
      Country.new('CY').alpha2 => 0.21,
      Country.new('CZ').alpha2 => 0.21,
      Country.new('DK').alpha2 => 0.21,
      Country.new('EE').alpha2 => 0.21,
      Country.new('FI').alpha2 => 0.21,
      Country.new('FR').alpha2 => 0.21,
      Country.new('DE').alpha2 => 0.21,
      Country.new('GR').alpha2 => 0.21,
      Country.new('HU').alpha2 => 0.21,
      Country.new('IE').alpha2 => 0.21,
      Country.new('IT').alpha2 => 0.21,
      Country.new('LV').alpha2 => 0.21,
      Country.new('LT').alpha2 => 0.21,
      Country.new('LU').alpha2 => 0.21,
      Country.new('MT').alpha2 => 0.21,
      Country.new('NL').alpha2 => 0.21,
      Country.new('PL').alpha2 => 0.21,
      Country.new('PT').alpha2 => 0.21,
      Country.new('RO').alpha2 => 0.21,
      Country.new('SK').alpha2 => 0.21,
      Country.new('SI').alpha2 => 0.21,
      Country.new('ES').alpha2 => 0.21,
      Country.new('SE').alpha2 => 0.21,
      Country.new('GB').alpha2 => 0.21
    }
    def initialize(country)
      @country = country
      @rates = Hash.new(DEFAULT_RATE).merge RATES
    end

    attr_reader :country, :rates

    def to_f
      rates[country.alpha2]
    end

    def *(n)
      to_f * n
    end

  end
end
