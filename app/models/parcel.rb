class Parcel < ApplicationRecord
	paginates_per 10

	STATUS = ['Sent', 'In Transit', 'Delivered']
	PAYMENT_MODE = ['COD', 'Prepaid']


	after_create :generate_order_id
	validates :weight, :status, presence: true
	validates :cost, :status, presence: true
	validates :status, inclusion: STATUS
	validates :payment_mode, inclusion: PAYMENT_MODE

	belongs_to :service_type
	belongs_to :sender, class_name: 'User'
	belongs_to :receiver, class_name: 'User'

	after_create :send_notification

	private

	def generate_order_id
		self.order_id = SecureRandom.random_number(100000..999999)
		save
	end

	def send_notification
		UserMailer.with(parcel: self).status_email.deliver_later
	end

end
