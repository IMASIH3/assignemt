class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :address
  has_many :send_parcels, foreign_key: :sender_id, class_name: 'Parcel'
  has_many :received_parcels, foreign_key: :receiver_id, class_name: 'Parcel'
  accepts_nested_attributes_for :address
  attr_accessor :confirmation_password

  # has_many :parcels, foreign_key: 'sender_id', dependent: :destroy
  # has_many :received_parcels, class_name: 'Parcel', foreign_key: 'receiver_id', dependent: :destroy

  def name_with_address
    @name_with_address ||= [name, email, address&.address_line_one, address&.mobile_number].join('-')
  end

  def is_admin?
    is_admin
  end
end
