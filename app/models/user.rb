class User < ApplicationRecord
  before_save {self.email = email.downcase!}
  validates :name, presence: true, length: {maximum: 50}

  #This helper validates that the attribute's value is unique right before the object gets saved.
  #It does not create a uniqueness constraint in the database, so it may happen that two different database connections
  #create two records with the same value for a column that you intend to be unique.
  #To avoid that, you must create a unique index on that column in your database.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i  # from rails docs
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX},
                    uniqueness: {case_sensitive: false}

  # api.rubyonrails.org - If password confirmation validation is not needed, simply leave out the value
  # for password_confirmation (i.e. don't provide a form field for it). When this attribute has a nil value,
  # the validation will not be triggered.
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true
end
