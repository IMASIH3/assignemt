class SearchController < ApplicationController
  def index
    if params[:search].present?
      @parcels = Parcel.where(order_id: params[:search])
    else
      @parcels = []
    end
  end
end
