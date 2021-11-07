require "test_helper"

class ContactTest < ActiveSupport::TestCase
  def setup
    @contact = Contact.new(name: "Example User",
                                          email: "user@example.com",
                                          message: "Hi")
  end

  test "name should be present" do
    @contact.name = "     "
    assert_not @contact.valid?
  end

  test "name should not be too long" do
    @contact.name = "a" * 51
    assert_not @contact.valid?
  end

  test "email should be present" do
    @contact.email = "     "
    assert_not @contact.valid?
  end

  test "email should not be too long" do
    @contact.email = "a" * 244 + "@example.com" # 256文字
    assert_not @contact.valid?
  end


  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com
                                    USER@foo.COM A_US-ER@foo.bar.org
                                    first.last@foo.jp
                                    alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @contact.email = valid_address
      assert @contact.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com
                                        user_at_foo.org
                                        user.name@example.
                                        foo@bar_baz.com
                                        foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @contact.email = invalid_address
      assert_not @contact.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "message should be present" do
    @contact.message = "     "
    assert_not @contact.valid?
  end
end
