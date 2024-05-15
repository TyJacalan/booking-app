require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_freelancer) { users(:valid_freelancer) }

  context 'geocoding' do
    it 'sets the address before validation' do
      valid_freelancer.valid?
      expect(valid_freelancer.address).to eq('Makati, Philippines')
    end

    it 'geocodes the user after validation' do
      valid_freelancer.save
      expect(valid_freelancer.latitude).to be_present
      expect(valid_freelancer.longitude).to be_present
    end
  end
end
