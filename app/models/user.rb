class User < ApplicationRecord
  has_many :services
  has_many :reviews
  has_many :appointments
  has_many :notifications

  belongs_to :role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # :omniauthable, omniauth_providers: [:google_oauth2]

  geocoded_by :address

  before_validation :set_address
  before_validation do
    self.role ||= Role.find_by(name: 'client')
  end

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity

  after_validation :geocode, if: -> { address.present? && address_changed? }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image
    end
  end

  private

  def password_complexity
    return unless password.present?

    errors.add(:password, 'cannot be longer than 128 characters') unless password.length <= 128
    errors.add(:password, 'must contain at least one letter') unless password.match?(/[a-zA-Z]/)
    errors.add(:password, 'must contain at least one number') unless password.match?(/\d/)
    return if password.match?(/[!@#$%^&*]/)

    errors.add(:password, 'must contain at least one special character')
  end

  def set_address
    self.address = "#{city}, #{country}" if city.present? && country.present?
    errors.add(:city, 'must correspond to a real city') unless Geocoder.search(address).first
  end

  def set_fullname
    self.full_name = "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
