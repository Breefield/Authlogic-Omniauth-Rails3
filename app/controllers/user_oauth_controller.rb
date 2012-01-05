class UserOauthController < ApplicationController
  def create
    @current_user = User.find_or_create_from_oauth(auth_hash)
    if current_user
      UserSession.create(current_user, true)
      redirect_to accounts_url, :notice => "Logged in"
    else
      redirect_to root_url, :flash => {:error => "Not authorized"}
    end
  end
  
  def failure
    redirect_to root_url, :flash => {:error => "Not authorized. #{params[:message]}"}
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end