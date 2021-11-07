require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "account_activation" do
    # メールオブジェクトを作る
    user = users(:michael)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    # 作ったメールオブジェクトを精査する
    assert_equal "アカウント本登録", mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['GMAIL_SMTP_LOGIN']], mail.from
    assert_match user.name,                    mail.html_part.body.encoded
    assert_match user.name,                    mail.text_part.body.encoded
    assert_match user.activation_token,    mail.html_part.body.encoded
    assert_match user.activation_token,    mail.text_part.body.encoded
    assert_match CGI.escape(user.email),  mail.html_part.body.encoded
    assert_match CGI.escape(user.email),  mail.text_part.body.encoded
  end

  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    # 作ったメールオブジェクトを精査する
    assert_equal "パスワード再設定", mail.subject
    assert_equal [user.email], mail.to
    assert_equal [ENV['GMAIL_SMTP_LOGIN']], mail.from
    assert_match user.reset_token,           mail.html_part.body.encoded
    assert_match user.reset_token,           mail.text_part.body.encoded
    assert_match CGI.escape(user.email),  mail.html_part.body.encoded
    assert_match CGI.escape(user.email),  mail.text_part.body.encoded
  end
end
