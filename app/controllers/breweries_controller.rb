class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show edit update destroy]
  # before_action :authenticate, only: [:destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list, :active, :retired]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :expire_brewery_cache, only: [:create, :update, :destroy, :toggle_activity]

  # GET /breweries or /breweries.json
  def index
    return if request.format.html? && fragment_exist?("brewerylist")

    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    @breweries = @active_breweries + @retired_breweries
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.turbo_stream {
          status = @brewery.active? ? "active" : "retired"
          count = @brewery.active? ? Brewery.active.count : Brewery.retired.count
          render turbo_stream: [
            turbo_stream.append("#{status}_brewery_rows", partial: "brewery_row", locals: { brewery: @brewery }),
            turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status:, count: })
          ]
        }
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to brewery_url(@brewery), notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    @brewery.destroy!

    respond_to do |format|
      format.turbo_stream {
        status = @brewery.active? ? "active" : "retired"
        count = @brewery.active? ? Brewery.active.count : Brewery.retired.count
        render turbo_stream: [
          turbo_stream.remove(@brewery),
          turbo_stream.replace("#{status}_brewery_count", partial: "brewery_count", locals: { status:, count: })
        ]
      }
      format.html { redirect_to breweries_url, notice: "Brewery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice: "brewery activity status changed to #{new_status}"
  end

  def list
  end

  def hotwire
    @brewery = Brewery.new
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    url = 'https://avoindata.prh.fi/bis/v1?totalResults=true&maxResults=500&businessLine=Oluen%20valmistus'
    response = HTTParty.get url

    @brewery_collection = response.parsed_response['results']
    @brewery_list = { data: @brewery_collection }.to_json
  end

  def active
    active_breweries = Brewery.active
    render partial: 'brewery_list', locals: { breweries: active_breweries, frame_tag: 'active' }
  end

  def retired
    retired_breweries = Brewery.retired
    render partial: 'brewery_list', locals: { breweries: retired_breweries, frame_tag: 'retired' }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    params.require(:brewery).permit(:name, :year, :active)
  end

  # def authenticate
  #   admin_accounts = { "pekka" => "beer", "arto" => "foobar", "matti" => "ittam", "vilma" => "kangas" }

  #   authenticate_or_request_with_http_basic do |username, password|
  #     raise "Wrong username or password" unless password == admin_accounts[username]

  #     return true
  #   end
  # end
end
