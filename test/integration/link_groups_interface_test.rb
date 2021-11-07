require "test_helper"

class LinkGroupsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "link_group interface with Ajax" do
    log_in_as(@user)
    get root_path
    # Link groupを作成する(無効な送信①: グループ名が未入力)
    assert_no_difference 'LinkGroup.count' do
      post link_groups_path, params: { link_group: { name: "" } }, xhr: true
    end
    assert_not flash.empty?
    # Link groupを作成する(無効な送信②：グループ数が5つ)
    assert_no_difference '@user.link_groups.count' do
      post link_groups_path, params: { link_group: { name: "hoge" } }, xhr: true
    end
    assert_not flash.empty?
    # Link groupを削除する
    first_link_group = @user.link_groups.first
    assert_difference 'LinkGroup.count', -1 do
      delete link_group_path(first_link_group), xhr: true
    end
    # Link groupを作成する(有効な送信)
    name = "Rails"
    assert_difference 'LinkGroup.count', 1 do
      post link_groups_path, params: { link_group: { name: name } }, xhr: true
    end
    assert_match name, response.body
    # Link groupを編集する
    updated_name = "Rails 2"
    last_link_group = @user.link_groups.last
    assert_no_difference 'LinkGroup.count' do
      patch link_group_path(last_link_group),
                params: { link_group: { name: updated_name } },
                xhr: true
    end
    assert_match updated_name, response.body
  end
end
