require "rails_helper"

RSpec.describe FreelancerAppointmentMailer, type: :mailer do
  describe "freelancer_new_appointment_email" do
    let(:mail) { FreelancerAppointmentMailer.freelancer_new_appointment_email }

    it "renders the headers" do
      expect(mail.subject).to eq("Freelancer new appointment email")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
