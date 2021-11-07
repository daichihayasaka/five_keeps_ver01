require "test_helper"

class GuestLoginTest < ActionDispatch::IntegrationTest

  test "guest successfully created" do
    assert_difference 'User.count', 1 do
      post guest_path, params: { user: { name: "Guest User",
                                                        email: "random@example.com",
                                                        password: "random",
                                                        guest: 1 } }
    end
    follow_redirect!
    assert_template 'static_pages/guest'
    assert_not flash.empty?
    assert is_logged_in?
  end
end
