require_relative './base_entity'

class Customer < BaseEntity
  # TODO test all
  entry_accessor  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :country

  def check_password(candidate_password)
    password == candidate_password
  end

  def authenticate(candidate_password)
    check_password(candidate_password) && record_login
  end

  private

  def record_login
    self.last_login_at = Time.now
  end
end
