require "rails_helper"

RSpec.describe AppointmentMailer, type: :mailer do
  describe "new_appointment_email" do
    let(:mail) { AppointmentMailer.new_appointment_email }

    it "renders the headers" do
      expect(mail.subject).to eq("New appointment email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
