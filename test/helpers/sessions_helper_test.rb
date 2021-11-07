require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)
    # session[:user_id]が設定されない
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    # セッションID：なし、永続cookies：あり、の場合、@user = current_user
    assert_equal @user, current_user
    # 同様に、ログインをしているはず
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    #  セッションID：なし、新しい記憶ダイジェストを作成、の場合、current_user = nil
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
