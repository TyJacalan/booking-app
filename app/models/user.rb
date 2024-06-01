class User < ApplicationRecord
  has_many :appointments, dependent: :destroy
  has_many :blocked_dates, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :services, dependent: :destroy

  belongs_to :role

  def self.ransackable_attributes(_auth_object = nil)
    %w[full_name city]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[services]
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # :omniauthable, omniauth_providers: [:google_oauth2]

  geocoded_by :address

  before_validation :set_address
  before_validation :set_fullname
  before_validation :set_default_role, on: :create

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :biography, presence: true, length: { minimum: 10, maximum: 500 }, if: :freelancer_registering?
  validates :skills, presence: true, if: :freelancer_registering?
  validates :city, presence: true, if: :freelancer_registering?
  validates :country, presence: true, if: :freelancer_registering?
  validates :role_id, presence: true
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

  def set_default_role
    self.role ||= Role.find_by(name: 'client')
  end

  def freelancer_registering?
    role&.name == 'freelancer'
  end

  def password_complexity
    return unless password.present?

    errors.add(:password, 'cannot be longer than 128 characters') unless password.length <= 128
    errors.add(:password, 'must contain at least one letter') unless password.match?(/[a-zA-Z]/)
    errors.add(:password, 'must contain at least one number') unless password.match?(/\d/)
    return if password.match?(/[!@#$%^&*]/)

    errors.add(:password, 'must contain at least one special character')
  end

  def set_address
    return unless city.present? && country.present?

    self.address = "#{city}, #{country}"
    errors.add(:city, 'must correspond to a real city') unless Geocoder.search(city).first
  end

  def set_fullname
    return unless first_name.present? && last_name.present?

    self.full_name = "#{first_name} #{last_name}"
  end
end
