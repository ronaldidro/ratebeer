class PlacesController < ApplicationController
  def index
  end

  def show
    # @restaurant = BeermappingApi.get_place(params[:id])
    places = BeermappingApi.places_in(session[:last_city])
    @restaurant = places.find{ |p| p.id == params[:id] }
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherstackApi.current_in(params[:city])
    @city = params[:city]

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{@city}"
    else
      session[:last_city] = @city
      render :index, status: 418
    end
  end
end
