require "test_helper"

class LinkGroupsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @link_group = link_groups(:rails)
  end

  test "should redirect show when not logged in" do
    get link_group_path(@link_group,  locale: I18n.locale)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'LinkGroup.count' do
      post link_groups_path, params: { link_group: { name: "hoge" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch link_group_path(@link_group,  locale: I18n.locale),
              params: { link_group: { name: "hoge" } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'LinkGroup.count' do
      delete link_group_path(@link_group, locale: I18n.locale)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong link_group" do
    log_in_as(users(:michael))
    link_group = link_groups(:javascript)
    assert_no_difference 'LinkGroup.count' do
      delete link_group_path(link_group, locale: I18n.locale)
    end
    assert_redirected_to root_url
  end
end
