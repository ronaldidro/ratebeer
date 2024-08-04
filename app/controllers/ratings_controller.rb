class RatingsController < ApplicationController
  before_action :expire_brewery_cache, only: [:create]

  PAGE_SIZE = 5

  def index
    @order = params[:order] || 'desc'
    @page = params[:page]&.to_i || 1
    @last_page = (Beer.count / PAGE_SIZE.to_f).ceil
    offset = (@page - 1) * PAGE_SIZE

    # object = Rails.cache.read('rating_stats') || {}
    # @recent = object[:recent]       || Rating.recent
    # @breweries = object[:breweries] || Brewery.top(3)
    # @beers = object[:beers]         || Beer.top(3)
    # @styles = object[:styles]       || Style.top(3)
    # @users = object[:users]         || User.top(3)
    # @ratings = object[:ratings]     || Rating.all

    @recent = Rating.order(created_at: @order).limit(PAGE_SIZE).offset(offset)
    @ratings = @recent

    if turbo_frame_request?
      render partial: "recent", locals: { ratings: @recent, page: @page, order: @order, last_page: @last_page }
    else
      render :index
    end
  end

  def show
    rating = Rating.find(params[:id])
    if turbo_frame_request?
      render partial: 'details', locals: { rating: }
    else
      render :show
    end
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to ratings_path
  end

  def remove
    destroy_ids = request.body.string.split(',')
    # Loop through multiple rating IDs and delete them if they exist and belong to the current user
    destroy_ids.each do |id|
      rating = Rating.find_by(id:)
      rating.destroy if rating && current_user == rating.user
    # Rescue in case one of the rating IDs is invalid so we can continue deleting the rest
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end
    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', status: :ok, user: @user }
    end
  end

  def best_beers
    best_beers = Beer.top(3)
    render partial: 'best', locals: { records: best_beers, tag_name: 'best_beers', record_name: 'Beer' }
  end

  def best_breweries
    best_breweries = Brewery.top(3)
    render partial: 'best', locals: { records: best_breweries, tag_name: 'best_breweries', record_name: 'Brewery' }
  end

  def best_styles
    best_styles = Brewery.top(3)
    render partial: 'best', locals: { records: best_styles, tag_name: 'best_styles', record_name: 'Style' }
  end

  def most_active_users
    most_active_users = User.top(3)
    render partial: 'most_active_users', locals: { users: most_active_users }
  end
end
