class SessionsController < ApplicationController
  def new
  end

  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      session[:user_id] = @user.id
      flash[:notice] = "Successfully logged in!"
      redirect_to root_path
    else
      flash[:alert] = "There was a problem signing you in."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out!"
    redirect_to root_path
  end
end
