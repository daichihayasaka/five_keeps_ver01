require "test_helper"

class LinkTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    # buildだと「Link group must exist」のエラーになる
    @link_group = LinkGroup.create(name: "hogehoge", user_id: @user.id)
    @link = @link_group.links.build(title: "hogehoge",
                                                  url: "url",
                                                  user_id: @user.id,
                                                  link_group_id: @link_group.id)
  end

  test "should be valid" do
    assert @link.valid?
  end

  test "user id should be present" do
    @link.user_id = nil
    assert_not @link.valid?
  end

  test "link_group_id should be present" do
    @link.link_group_id = nil
    assert_not @link.valid?
  end

  test "title should be present" do
    @link.title = "   "
    assert_not @link.valid?
  end

  test "title should be at most 255 characters" do
    @link.title = "a" * 256
    assert_not @link.valid?
  end

  test "url should be present" do
    @link.url = "   "
    assert_not @link.valid?
  end

  test "order should be most recent first" do
    assert_equal links(:most_recent), Link.first
  end
end
