require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    let(:user_valid) { users(:valid_user) }
    let(:user_missing_first_name) { users(:missing_first_name_user) }
    let(:user_short_first_name) { users(:short_first_name_user) }
    let(:user_long_first_name) { users(:long_first_name_user) }
    let(:user_missing_last_name) { users(:missing_last_name_user) }
    let(:user_short_last_name) { users(:short_last_name_user) }
    let(:user_long_last_name) { users(:long_last_name_user) }
    let(:user_invalid_email) { users(:invalid_email_user) }

    context 'when the user is valid' do
      it 'is valid' do
        expect(user_valid).to be_valid
      end
    end

    context 'when first name is invalid' do 
      it 'is invalid without a first name' do
        expect(user_missing_first_name).to be_invalid
      end
      
      it 'is invalid with a short first name' do
        expect(user_short_first_name).to be_invalid
      end

      it 'is invalid with a long first name' do
        expect(user_long_first_name).to be_invalid
      end
    end

      context 'when last name is invalid' do
      it 'is invalid with a short last name' do
        expect(user_short_last_name).to be_invalid
      end

      it 'is invalid with a long last name' do
        expect(user_long_last_name).to be_invalid
      end
    end

    context 'when the email is invalid' do
      it 'is not a valid email' do
        expect(user_invalid_email).to be_invalid
      end
    end
  end
end
