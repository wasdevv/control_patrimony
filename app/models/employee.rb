class Employee < ApplicationRecord
  # Configuração do Employee
  validates :employee_id, presence: true, uniqueness: true # Employee ID only used 1 time and unique
  validates :used, inclusion: { in: [true, false] }

  # Config in CPF/PhoneNumber
  validates :cpf, presence: true, length: { is: 11}, numericality: { only_integer: true}
  validates :phone_number, presence: true
  
  validate :valid_brazilian_cpf
  validate :valid_brazilian_phone_number
  
  before_validation :generate_employee_id, on: :create

  belongs_to :user

  before_save :format_phone_number

  def used=(value)
    self[:used] = value
  end
  
  private

  # ONLY Admin user can create the Employee ID
  # AND used 1 time before login on site and
  # received the ID code, put on the employee new.
  def generate_employee_id
    self.employee_id = SecureRandom.uuid
  end

  def associate_employee_id(employee_id)
    self.employee_id = employee_id
    self.used = true
    save
  end

  # def mark_employee_id_as_used
  #   self.employee_id = nil
  #   self.employee_id_was = self.instance_variable_get(:@_unused_employee_id) # Recupera o ID gerado salvo anteriormente
  # end
  
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

    sanitized_phone_number = phone_number.to_s.gsub(/\D/, '')
    return unless (10..11).include?(sanitized_phone_number.length)

    if sanitized_phone_number.start_with?('11') && sanitized_phone_number.length == 11
      unless sanitized_phone_number.match?(/\A11[2-9]\d{8}\z/)
        errors.add(:phone_number, "unvalid number on Brasil. Must start with '11' and have 11 digits.")
      end
    else
      unless sanitized_phone_number.match?(/\A(?:[1-9]{2})?[2-9]\d{3}\d{4}\z/)
        errors.add(:phone_number, "Invalid number on Brazil, try again.")
      end
    end
  end

  def format_phone_number
    if phone_number.present? && phone_number.match?(/\A\d{11}\z/)
      # The number will format in the summary: "+ddd 9xxxx-xxxx"
      self.phone_number = "+#{phone_number[0..1]} 9#{phone_number[2..5]}-#{phone_number[6..9]}"
    end
  end
end
