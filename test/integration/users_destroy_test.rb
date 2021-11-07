require "test_helper"

class UsersDestroyTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "successful destroy" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select 'span', 'アカウントを削除される場合はこちら'
    assert_select 'a[href=?]', user_path(@user), text: '削除'
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
    assert_not flash.empty?
    assert_redirected_to root_url
  end
end
