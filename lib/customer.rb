require_relative './base_entity'

class Customer < BaseEntity
  entry_accessor  :first_name,
                  :last_name,
                  :email,
                  :password,
                  :country,
                  :question_1,
                  :question_2,
                  :question_3,
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

  def orders
    record.order_records.map{ |r| Order.new r }
  end

  def survey_unanswered?
    (question_1.nil? || question_1.empty?) &&
    (question_2.nil? || question_2.empty?) &&
    (question_3.nil? || question_3.empty?)
  end

  private

  def record_login
    self.last_login_at = Time.now
  end
end
