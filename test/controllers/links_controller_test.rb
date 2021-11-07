require "test_helper"

class LinksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @link_group = link_groups(:rails)
    @link = links(:rails_tutorial)
  end

  test "should redirect search when not logged in" do
    get search_path
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'LinkGroup.count' do
      post links_path, params: { link: { title: "hoge",
                                                      url: "url",
                                                      link_group_id: @link_group.id } }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch link_path(@link,  locale: I18n.locale),
              params: { link: { title: "hoge",
                                      url: "url",
                                      link_group_id: @link_group.id } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'LinkGroup.count' do
      delete link_path(@link,  locale: I18n.locale)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong link" do
    log_in_as(users(:michael))
    link = links(:dom)
    assert_no_difference 'LinkGroup.count' do
      delete link_path(link,  locale: I18n.locale)
    end
    assert_redirected_to root_url
  end
end
