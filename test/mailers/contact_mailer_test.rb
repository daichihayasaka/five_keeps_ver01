require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "contact_mail" do
    contact = contacts(:sample1)
    mail = ContactMailer.contact_email(contact)

    assert_equal "Michael Example様からお問い合わせ", mail.subject
    assert_equal [ENV['GMAIL_SMTP_LOGIN']], mail.to
    assert_equal [ENV['GMAIL_SMTP_LOGIN']], mail.from
  end

end
