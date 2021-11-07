# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/contact_mailer/contact_email
  def contact_email
    contact = Contact.first
    ContactMailer.contact_email(contact)
  end

end
