class BeerclubsController < ApplicationController
  before_action :set_beerclub, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :admin_verification, only: [:destroy]

  # GET /beerclubs or /beerclubs.json
  def index
    @beerclubs = Beerclub.all
  end

  # GET /beerclubs/1 or /beerclubs/1.json
  def show
    if @beerclub.members.include?(current_user)
      @membership = Membership.find_by user_id: current_user, beerclub_id: @beerclub.id
    else
      @membership = Membership.new
      @membership.beerclub = @beerclub
    end
  end

  # GET /beerclubs/new
  def new
    @beerclub = Beerclub.new
  end

  # GET /beerclubs/1/edit
  def edit
  end

  # POST /beerclubs or /beerclubs.json
  def create
    @beerclub = Beerclub.new(beerclub_params)

    respond_to do |format|
      if @beerclub.save
        format.html { redirect_to beerclub_url(@beerclub), notice: "Beerclub was successfully created." }
        format.json { render :show, status: :created, location: @beerclub }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beerclubs/1 or /beerclubs/1.json
  def update
    respond_to do |format|
      if @beerclub.update(beerclub_params)
        format.html { redirect_to beerclub_url(@beerclub), notice: "Beerclub was successfully updated." }
        format.json { render :show, status: :ok, location: @beerclub }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beerclub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beerclubs/1 or /beerclubs/1.json
  def destroy
    @beerclub.destroy!

    respond_to do |format|
      format.html { redirect_to beerclubs_url, notice: "Beerclub was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beerclub
    @beerclub = Beerclub.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def beerclub_params
    params.require(:beerclub).permit(:name, :founded, :city)
  end

  def admin_verification
    redirect_to beerclubs_path, notice: 'only admin can do this' unless current_user.admin
  end
end
