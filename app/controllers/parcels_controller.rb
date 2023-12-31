class ParcelsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parcel, only: %i[ show edit update destroy ]

  # GET /parcels or /parcels.json
  def index
    if current_user.is_admin?
      @parcels = Parcel.includes(:sender, :receiver, :service_type).order(created_at: :desc).all.page(params[:page])
    else
      @parcels = Parcel.includes(:sender, :receiver, :service_type).where(sender_id: current_user.id).order(created_at: :desc).page(params[:page])
    end
  end
  

  # GET /parcels/1 or /parcels/1.json
  def show
  end

  # GET /parcels/new
  def new
    @parcel = Parcel.new
    @users = User.joins(:address).where(addresses: { user_creator: current_user.id }).map { |user| [user.name_with_address, user.id] }
    @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # GET /parcels/1/edit
  def edit
    @users = User.all.map { |user| [user.name_with_address, user.id] }
    @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]}
  end

  # POST /parcels or /parcels.json
  def create
    @parcel = Parcel.new(parcel_params)

    respond_to do |format|
      if @parcel.save
        format.html { redirect_to @parcel, notice: 'Parcel was successfully created.' }
        format.json { render :show, status: :created, location: @parcel }
      else
        format.html do
          @users = User.all.map{|user| [user.name_with_address, user.id]}
          @service_types = ServiceType.all.map{|service_type| [service_type.name, service_type.id]} 
          render :new, status: :unprocessable_entity
        end
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parcels/1 or /parcels/1.json
  def update
    respond_to do |format|
      if @parcel.update(parcel_params)
        ParcelMailer.status_updated_notification_sender(@parcel).deliver_later
        ParcelMailer.status_updated_notification_receiver(@parcel).deliver_later
        format.html { redirect_to @parcel, notice: 'Parcel was successfully updated.' }
        format.json { render :show, status: :ok, location: @parcel }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @parcel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parcels/1 or /parcels/1.json
  def destroy
    @parcel.destroy
    respond_to do |format|
      format.html { redirect_to parcels_url, notice: 'Parcel was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parcel
      @parcel = Parcel.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def parcel_params
      params.require(:parcel).permit(:weight, :status, :service_type_id,
                                     :payment_mode, :sender_id, :receiver_id,
                                     :cost, :order_id)
    end
end
