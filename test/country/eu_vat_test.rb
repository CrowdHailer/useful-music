require_relative '../test_config'

class Country
  class EUVATTest < MiniTest::Test
    def afghanistan
      Country.new('AF')
    end

    def belgium
      Country.new('BE')
    end

    def test_afghanistan_uses_the_default_rate
      rate = EUVAT.new afghanistan
      assert_equal 0, rate.to_f
    end

    def test_can_access_country
      rate = EUVAT.new afghanistan
      assert_equal afghanistan, rate.country
    end

    def test_rate_can_multiply_number
      rate = EUVAT.new belgium
      assert_equal 0.21, rate * 1
    end

    def test_rate_can_multiply_with_number
      rate = EUVAT.new belgium
      assert_equal 0.21, 1 * rate.to_f
    end

    def test_can_multiply_money
      rate = EUVAT.new belgium
      assert_equal Money.new(21, 'EUR'), rate * Money.new(100, 'EUR')
    end

    def test_can_multiply_with_money
      rate = EUVAT.new belgium
      assert_equal Money.new(21, 'EUR'), Money.new(100, 'EUR') * rate.to_f
    end

  end
end
