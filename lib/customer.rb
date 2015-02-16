require_relative './base_entity'

class Customer < BaseEntity
  entry_accessor  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :country,
                  :last_login_at

  def correct_password?(candidate_password)
    password == candidate_password
  end

  def authenticate(candidate_password)
    self if correct_password?(candidate_password) && record_login
  end

  def name
    "#{first_name} #{last_name}"
  end

  def guest?
    false
  end

  def customer?
    true
  end

  def admin?
    false
  end

  private

  def record_login
    self.last_login_at = Time.now
  end
end
