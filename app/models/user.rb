class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         authentication_keys: [:login],
         reset_password_keys: [:login]

  attr_writer :login

  validates_uniqueness_of :email
  validates_uniqueness_of :username
  validates_presence_of :first_name
  validates_presence_of :username
  validates_format_of :email, with: URI::MailTo::EMAIL_REGEXP,
                      message: "must be a valid email address"

  has_many :posts

  has_many :bonds

  has_many :followings,
           -> { Bond.following },
           through: :bonds,
           source: :friend

  has_many :follow_requests,
           -> { Bond.requesting },
           through: :bonds,
           source: :friend

  has_many :inward_bonds,
           class_name: "Bond",
           foreign_key: :friend_id

  has_many :followers,
           -> { Bond.following },
           through: :inward_bonds,
           source: :user

  before_save :ensure_proper_name_case

  def to_param
    username
  end

  def login
    @login || username || email
  end

  def name
    if last_name
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  def profile_picture_url
    @profile_picture_url ||= begin
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}?d=wavatar"
    end
  end

  def self.find_authenticatable(login)
    where("username = :value OR email = :value", value: login).first
  end

  def self.find_for_database_authentication(conditions)
    conditions = conditions.dup
    login = conditions.delete(:login).downcase
    find_authenticatable(login)
  end

  def self.send_reset_password_instructions(conditions)
    recoverable = find_recoverable_or_init_with_errors(conditions)

    if recoverable.persisted?
      recoverable.send_reset_password_instructions
    end

    recoverable
  end

  def self.find_recoverable_or_init_with_errors(conditions)
    conditions = conditions.dup
    login = conditions.delete(:login).downcase
    recoverable = find_authenticatable(login)

    unless recoverable
      recoverable = new(login: login)
      recoverable.errors.add(:login, login.present? ? :not_found : :blank)
    end

    recoverable
  end

  private

  def ensure_proper_name_case
    self.first_name = first_name.capitalize
  end

end