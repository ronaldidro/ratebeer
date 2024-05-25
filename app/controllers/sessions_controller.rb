class SessionsController < ApplicationController
  def new
    # render the signing up page
  end

  def create
    user = User.find_by username: params[:username]
    # check that user exists and the password is correct
    if user&.authenticate(params[:password])
      if user.active
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
      else
        redirect_to signin_path, notice: "Your account is closed, please contact with admin" unless user.active
      end
    else
      redirect_to signin_path, notice: "Username and/or password mismatch"
    end
  end

  def destroy
    # resets the session
    session[:user_id] = nil
    # redirects the application to the main page
    redirect_to :root
  end
end
