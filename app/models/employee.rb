class Employee < ApplicationRecord
  belongs_to :user
  validates :cpf, presence: true, length: { is: 11}, numericality: { only_integer: true}
  validates :phone_number, presence: true

  validate :valid_brazilian_cpf
  validate :valid_brazilian_phone_number

  private

  def valid_brazilian_cpf
    return if cpf.blank? || cpf.length != 11 || !cpf.match?(/\A\d{11}\z/)
  
    numbers = cpf.chars.map(&:to_i)
    sum = 0
  
    (0..8).each do |i|
      sum += numbers[i] * (9 - i)
    end
  
    first_digit = (10 - sum % 10) % 10
    sum += first_digit * 2
  
    (0..8).each do |i|
      sum += numbers[i] * (10 - i)
    end
  
    second_digit = (10 - sum % 10) % 10
  
    unless numbers[-2] == first_digit && numbers[-1] == second_digit
      errors.add(:cpf, "is not valid, try again.")
    end
  end

  def valid_brazilian_phone_number
    return if phone_number.blank?

    sanitized_phone_number = phone_number.gsub(/\D/, '')
    return unless sanitized_phone_number.length.in?(10, 11)

    if sanitized_phone_number[0] == '1' && sanitized_phone_number[1] == '9'
      unless sanitized_phone_number[2..-1].match?(/\A\d{4})[-.]?\d{4}\z/)
        errors.add(:phone_number), "Valid number on Brasil."
      end
    else
      unless sanitized_phone_number.match?( /\A(?:9\d{4}|\d{4})[-.]?\d{4}\z/)
        errors.add(:phone_number, "Invalid number on Brazil, try again.")
      end
    end
  end
end
