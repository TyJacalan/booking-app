class User < ApplicationRecord
  has_many :client_reviews, class_name: 'Review', foreign_key: 'client_id', dependent: :destroy
  has_many :client_comments, class_name: 'Comment', foreign_key: 'client_id', dependent: :destroy
  has_many :freelancer_reviews, class_name: 'Review', foreign_key: 'freelancer_id', dependent: :destroy
  has_many :client_comments, class_name: 'Comment', foreign_key: 'freelancer_id', dependent: :destroy
  has_many :client_appointments, class_name: 'Appointment', foreign_key: 'client_id', dependent: :destroy
  has_many :freelancer_appointments, class_name: 'Appointment', foreign_key: 'freelancer_id', dependent: :destroy
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
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  geocoded_by :address

  before_validation :set_address
  before_validation :set_fullname
  before_validation :set_default_role, on: :create

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :biography, presence: true, length: { minimum: 10, maximum: 500 }, if: :freelancer_registering?
  validates :birthdate, :skills, :city, :mobile, presence: true, if: :freelancer_registering?
  validate :password_complexity

  after_validation :geocode, if: -> { address.present? && address_changed? }

  def self.from_omniauth(auth)
    where(provider: auth[:provider], uid: auth[:uid]).first_or_initialize.tap do |user|
      user.email = auth[:email]
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth[:name]
      user.first_name, user.last_name = split_name(auth[:name])
      user.avatar_url = auth[:image]
      user.uid = auth[:uid]
      user.provider = auth[:provider]

      user.role = Role.find_by(name: 'client')

      if user.new_record?
        unless user.save(validate: false)
          Rails.logger.error("Error saving user: #{user.errors.full_messages.join(', ')}")
        end
      end
    end
  end

  def self.split_name(full_name)
    name_parts = full_name.split
    first_name = name_parts.first || 'Unknown'
    last_name = name_parts[1..].join(' ') || 'User'
    [first_name, last_name]
  end

  def freelancer?
    role.name == 'freelancer'
  end

  def registered_freelancer?
    [biography, birthdate, skills, mobile, address].all?(&:present?)
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

    city_without_prefix = city.gsub(/^city of /i, '') # Remove 'city of' prefix (case-insensitive)
    city_without_suffix = city_without_prefix.gsub(/\s*\([^)]+\)$/, '').strip.downcase
    city = city_without_suffix

    self.address = "#{city}, #{country}"
    self.city = city
  end

  def set_fullname
    return unless first_name.present? && last_name.present?

    self.full_name = "#{first_name} #{last_name}"
  end
end
