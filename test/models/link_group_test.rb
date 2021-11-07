require "test_helper"

class LinkGroupTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @link_group = @user.link_groups.build(name: "hoge")
  end

  test "should be valid" do
    assert @link_group.valid?
  end

  test "user id should be present" do
    @link_group.user_id = nil
    assert_not @link_group.valid?
  end

  test "name should be present" do
    @link_group.name = "   "
    assert_not @link_group.valid?
  end

  test "name should be at most 50 characters" do
    @link_group.name = "a" * 51
    assert_not @link_group.valid?
  end
end
