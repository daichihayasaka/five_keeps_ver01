class ApplicationMailer < ActionMailer::Base
  default from: ENV['GMAIL_SMTP_LOGIN']
  layout 'mailer'
end
