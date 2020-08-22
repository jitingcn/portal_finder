# frozen_string_literal: true

class User < ApplicationRecord
  enum role: { deleted: -1, member: 1, blocked: 2, vip: 3, maintainer: 90, admin: 99 }
  after_initialize :set_default_role, if: :new_record?

  LOGIN_FORMAT              = 'A-Za-z0-9\-\_\.'
  ALLOW_LOGIN_FORMAT_REGEXP = /\A[#{LOGIN_FORMAT}]+\z/

  has_many :ifs_search, dependent: :destroy
  validates :login, format: { with: ALLOW_LOGIN_FORMAT_REGEXP, message: "只允许数字、大小写字母、中横线、下划线" },
            length: { in: 2..20 },
            presence: true,
            uniqueness: { case_sensitive: false }

  def set_default_role
    self.role ||= :member
  end

  define_method :admin? do
    self.role.to_s == "admin" || Setting.admin_emails.include?(email)
  end

  # Include default devise modules. Others available are:
  # :confirmable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :timeoutable, :trackable

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["lower(login) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:login) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def soft_delete
    self.role = "deleted"
    save(validate: false)
  end
end
