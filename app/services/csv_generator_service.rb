require 'csv'

class CsvGeneratorService
  def self.generate_csv
    current_date = Time.current.strftime('%Y%m%d')
    file_name = "parcels_#{current_date}.csv"

    file_path = Rails.root.join('public', file_name)
    parcels = Parcel.includes(sender: :address, receiver: :address).all
    headers = [
      "parcel ID",
      "cost",
      "weight",
      "status",
      "Sender",
      "Sender mobile number",
      "Receiver",
      "Receiver mobile number",
      "Sender address",
      "Receiver address"
    ]

    CSV.open(file_path, 'w', write_headers: true, headers: headers) do |csv|
      parcels.each do |parcel|
        sender = parcel.sender
        receiver = parcel.receiver
        sender_address = sender&.address
        receiver_address = receiver&.address

        csv << [
          parcel.id,
          parcel.cost,
          parcel.weight,
          parcel.status,
          sender&.name,
          sender_address&.mobile_number,
          receiver&.name,
          receiver_address&.mobile_number,
          format_address(sender_address),
          format_address(receiver_address)
        ]
      end
    end

    csv_file = CsvFile.find_by(name: file_name)
    if csv_file
      csv_file.file.attach(io: File.open(file_path), filename: file_name)
      csv_file.save
    else
      csv_file = CsvFile.new(name: file_name)
      csv_file.file.attach(io: File.open(file_path), filename: file_name)
      csv_file.save
    end
  end

  private

  def self.format_address(address)
    return "" if address.blank?

    [
      address.address_line_one,
      address.city,
      address.state,
      address.country,
      address.pincode
    ].compact.join(", ")
  end
end