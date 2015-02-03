require_relative './test_config'

class InterfaceTest < MiniTest::Test
  def empty_controller
    @empty_controller ||= Class.new(Scorched::Controller) do
      include Scorched::Rest
    end
  end

  def teardown
    @empty_controller = nil
  end

  def test_index_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).index
    end
  end

  def test_new_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).new
    end
  end

  def test_create_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).create
    end
  end

  def test_show_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).show(4)
    end
  end

  def test_edit_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).edit(4)
    end
  end

  def test_update_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).update(4)
    end
  end

  def test_destroy_action_interface
    assert_raises Scorched::Rest::ActionNotImplemented do
      empty_controller.new({}).destroy(4)
    end
  end
end
