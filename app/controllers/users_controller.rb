class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :show]
  before_action :correct_user, only: [:edit, :update]
  before_action :load_user, only: [:show]

  def edit
  end

  def update
    if @user.update user_params
      flash[:success] = t "application.flash.user_updated"
      redirect_to root_url
    else
      render :edit
    end
  end

  def show
  end

  private
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? load_user
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation, :avatar
  end

  def load_user
    @user = User.find params[:id]
  end

end
