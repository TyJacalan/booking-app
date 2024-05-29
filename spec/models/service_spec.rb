# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Service, type: :model do
  let(:freelancer) { create(:user, :freelancer) }
  let(:service) { create(:service, user: freelancer, categories: %w[photographer videographer]) }

  it 'is valid with valid attributes' do
    expect(service).to be_valid
  end

  it 'belongs to a user' do
    expect(service.user).to eq(freelancer)
  end

  it 'has categories as an array of strings' do
    expect(service.categories).to be_an(Array)
    expect(service.categories).to all(be_a(String))
  end
end
