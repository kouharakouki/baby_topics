class Contact < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates_format_of :phone_number, with: /\A\d{10,11}\z/
  validates :message, presence: true
end
