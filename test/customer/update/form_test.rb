require_relative '../../test_config'

class Customer
  class Update
    class FormTest < MiniTest::Test
      def test_obtains_first_name
        form = Form.new :first_name => 'Will'
        assert_equal 'Will', form.first_name
      end

      def test_capitalises_first_name
        form = Form.new :first_name => 'will'
        assert_equal 'Will', form.first_name
      end

      def test_strips_whitespace_from_first_name
        form = Form.new :first_name => '   Mike  '
        assert_equal 'Mike', form.first_name
      end

      def test_silent_if_first_name_not_supplied
        form = Form.new
        assert_equal '', form.first_name
      end

      def test_obtains_last_name
        form = Form.new :last_name => 'Smith'
        assert_equal 'Smith', form.last_name
      end

      def test_capitalises_last_name
        form = Form.new :last_name => 'will'
        assert_equal 'Will', form.last_name
      end

      def test_strips_whitespace_from_last_name
        form = Form.new :last_name => '   Mike  '
        assert_equal 'Mike', form.last_name
      end

      def test_silent_if_last_name_not_supplied
        form = Form.new
        assert_equal '', form.last_name
      end

      def test_obtains_email
        form = Form.new :email => 'test@example.com'
        assert_equal 'test@example.com', form.email
      end

      def test_downcases_email
        form = Form.new :email => 'Test@ExamplE.com'
        assert_equal 'test@example.com', form.email
      end

      def test_strips_whitespace_from_email
        form = Form.new :email => '   test@example.com  '
        assert_equal 'test@example.com', form.email
      end

      def test_silent_if_email_not_supplied
        form = Form.new
        assert_equal '', form.email
      end

      def test_obtains_country_when_known
        form = Form.new :country => 'GB'
        assert_equal Country.new('gb'), form.country
      end

      def test_nil_country_when_unknown
        form = Form.new :country => 'ZZ'
        assert_nil form.country
      end

      def test_obtains_question_1
        form = Form.new :question_1 => 'Yes'
        assert_equal 'Yes', form.question_1
      end

      def test_strips_whitespace_from_question_1
        form = Form.new :question_1 => '   For sure  '
        assert_equal 'For sure', form.question_1
      end

      def test_silent_if_question_1_not_supplied
        form = Form.new
        assert_equal '', form.question_1
      end

      def test_obtains_question_2
        form = Form.new :question_2 => 'Yes'
        assert_equal 'Yes', form.question_2
      end

      def test_strips_whitespace_from_question_2
        form = Form.new :question_2 => '   For sure  '
        assert_equal 'For sure', form.question_2
      end

      def test_silent_if_question_2_not_supplied
        form = Form.new
        assert_equal '', form.question_2
      end

      def test_obtains_question_3
        form = Form.new :question_3 => 'Yes'
        assert_equal 'Yes', form.question_3
      end

      def test_strips_whitespace_from_question_3
        form = Form.new :question_3 => '   For sure  '
        assert_equal 'For sure', form.question_3
      end

      def test_silent_if_question_3_not_supplied
        form = Form.new
        assert_equal '', form.question_3
      end

    end
  end
end
