class User < ApplicationRecord
  before_create :create_account_activation_token
  after_create :send_account_activation_email

  has_many :workshop_members, dependent: :destroy

  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  def create_account_activation_token
    self.account_activation_token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)

      break random_token unless User.exists?(account_activation_token: random_token)
    end
  end

  def send_account_activation_email
    UserMailer
    .activate_account(self)
    .deliver_now
  end
end
