class Country
  def eu?
    EU_COUNTRIES.include?(self)
  end
  EU_COUNTRIES = [
    Country.new('AT'),
    Country.new('BE'),
    Country.new('BG'),
    Country.new('HR'),
    Country.new('CY'),
    Country.new('CZ'),
    Country.new('DK'),
    Country.new('EE'),
    Country.new('FI'),
    Country.new('FR'),
    Country.new('DE'),
    Country.new('GR'),
    Country.new('HU'),
    Country.new('IE'),
    Country.new('IT'),
    Country.new('LV'),
    Country.new('LT'),
    Country.new('LU'),
    Country.new('MT'),
    Country.new('NL'),
    Country.new('PL'),
    Country.new('PT'),
    Country.new('RO'),
    Country.new('SK'),
    Country.new('SI'),
    Country.new('ES'),
    Country.new('SE'),
    Country.new('GB')
  ]
end
