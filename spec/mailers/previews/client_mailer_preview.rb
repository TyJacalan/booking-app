# Preview all emails at http://localhost:3000/rails/mailers/client_mailer
class ClientMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/client_mailer/new_client_email
  def new_client_email
    ClientMailer.new_client_email
  end
end
