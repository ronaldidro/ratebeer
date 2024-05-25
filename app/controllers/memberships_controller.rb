class MembershipsController < ApplicationController
  def new
    @membership = Membership.new
    set_beerclubs
  end

  def create
    @membership = Membership.new params.require(:membership).permit(:beerclub_id)
    @membership.user = current_user

    if @membership.save
      redirect_to beerclub_url(@membership.beerclub), notice: "#{current_user.username} welcome to the club."
    else
      set_beerclubs
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.delete
    redirect_to current_user, notice: "Membership in #{membership.beerclub.name} ended."
  end

  private

  def set_beerclubs
    @beerclubs = Beerclub.all.select { |b| current_user.beerclubs.exclude?(b) }
  end
end
