class User < ApplicationRecord
  has_many :services
  has_many :reviews
  has_many :appointments
  has_many :notifications

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  geocoded_by :address

  before_validation :set_address

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity
  validate :address_format
  validate :validate_address_is_real_place

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
  end

  def address_format
    if address.blank?
      errors.add(:address, "can't be blank")
    else
      parts = address.split(',')
      if parts.length != 2 || parts.any?(&:blank?)
        errors.add(:address, 'must include a city and country separated by a comma')
      end
    end
  end

  def validate_address_is_real_place
    return unless address.present?

    geocode = Geocoder.search(address).first
    errors.add(:address, 'must correspond to a real place') unless geocode && geocode.coordinates.present?
  rescue StandardError => e
    errors.add(:address, 'could not be validated')
  end

  def set_fullname
    self.full_name = "#{first_name} #{last_name}" if first_name.present? && last_name.present?
  end
end
