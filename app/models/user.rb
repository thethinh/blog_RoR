# frozen_string_literal: true

class User < ApplicationRecord
  has_many :comment, dependent: :destroy
  has_many :microposts, dependent: :destroy
  has_many :reaction, dependent: :destroy
  has_many :active_relationships,
           class_name: 'Relationship',
           foreign_key: 'follower_id',
           dependent: :destroy
  has_many :passive_relationships,
           class_name: 'Relationship',
           foreign_key: 'followed_id',
           dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed do
    def users_following
      where('request_status=?', 1)
    end
  end
  has_many :followers, through: :passive_relationships, source: :follower do
    def users_follower
      where('request_status=?', 1)
    end
  end
  has_many :messages, dependent: :destroy
  has_many :conversations, foreign_key: 'sender_id', dependent: :destroy
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  scope :calculation_oneweek, ->(start_date, end_date) { where(created_at: start_date..end_date) }
  scope :csv_follow_1_month_recent, ->(start_date, end_date) { select(:created_at, :name).where(created_at: start_date..end_date) }

  def self.digest(string)
    cost =
      ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                       BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def self.send_auto_email
    User.all.find_each { |user| ScheduleMailer.auto_sendmail(user).deliver }
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    Micropost.order('created_at')
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  def self.from_omniauth(auth)
    user = User.find_by(email: auth.info.email)
    user = user.presence || User.new(
      name: auth.info.name,
      email: auth.info.email,
      password: auth.uid,
      password_confirmation: auth.uid,
      activated: true
    ) # activated account because it's authentication from google
  end

  def self.to_csv_follow
    # convert to csv file
    attributes = %w[created_at name]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  private

  # Converts email to all lower-case.
  def downcase_email
    self.email = email.downcase
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
