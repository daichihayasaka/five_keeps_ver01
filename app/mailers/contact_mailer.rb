class ContactMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact_mail.subject
  #
  def contact_email(contact)
    @contact = contact
    mail to: ENV['GMAIL_SMTP_LOGIN'],
          subject: t('.subject', user: @contact.name)
  end
end
