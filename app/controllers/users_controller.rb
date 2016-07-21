class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @followers = @user.followers
    @followed_users = @user.followed_users
  end
end
