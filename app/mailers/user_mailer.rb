class UserMailer < ApplicationMailer

  def status_email
    @parcel = params[:parcel]
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url  = 'http://localhost:3000/search'
    mail(to: @receiver.email, subject: 'New Parcel Information')
  end


  def sender_status_email
    @parcel = params[:parcel]
    @sender = @parcel.sender
    @receiver = @parcel.receiver
    @url  = 'http://localhost:3000/search'
    mail(to: @sender.email, subject: 'New Parcel Information')
  end
end
