require_relative '../test_config'

class Country
  class EUVATTest < MiniTest::Test
    def afghanistan
      Country.new('AF')
    end

    def test_afghanistan_uses_the_default_rate
      rate = EUVAT.new afghanistan
      assert_equal 0, rate.to_f
    end

  end
end
