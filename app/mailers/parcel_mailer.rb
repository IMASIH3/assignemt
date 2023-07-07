class ParcelMailer < ApplicationMailer

  def status_updated_notification_sender(parcel)
    @parcel = parcel
    mail(to: @parcel.sender.email, subject: "Parcel Status Updated")
  end

  def status_updated_notification_receiver(parcel)
    @parcel = parcel
    mail(to: @parcel.receiver.email, subject: "Parcel Status Updated")
  end
end
