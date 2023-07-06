class UserlistController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /userlist or /userlist.json
  def index
    @users = User.all
  end

  # GET /userlist/1 or /userlist/1.json
  def show
    sender = User.find(params[:id]) # Assuming your User model represents senders
  end

  # GET /userlist/new
  def new
    @user = User.new
    @user.build_address
  end

  # GET /userlist/1/edit
  def edit
  end


  # POST /userlist or /userlist.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.password == @user.confirmation_password && @user.save
        format.html { redirect_to userlist_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /userlist/1 or /userlist/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to userlist_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /userlist/1 or /userlist/1.json
  def destroy
    @user.destroy
    redirect_to userlist_index_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password, :confirmation_password, address_attributes: [:id, :address_line_one, :address_line_two, :city, :state, :country, :pincode, :mobile_number, :_destroy])
  end

  # def user_params
  #   params.require(:user).permit(:name, :email, address_attributes: [:address_line_one, :address_line_two,
  #                                                                    :city, :state, :country,
  #                                                                    :pincode, :mobile_number])
  # end
end