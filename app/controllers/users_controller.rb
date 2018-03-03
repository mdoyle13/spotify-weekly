class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_user, only: [:edit, :update, :destroy]
  before_action :ensure_user_is_current, only: [:edit, :update, :destroy]
  after_action -> { flash.discard }, if: -> { request.xhr? }

  def edit
  end

  def update
    respond_to :js
    if @user.update(user_params)
      flash[:notice] = "Successfully updated your details"
    else
      flash[:error] = @user.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @user.destroy
      redirect_to root_path
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to edit_user_path(@user)
    end
  end

  private
  def user_params
    params.require(:user).permit(:email, :auto_sync)
  end

  def load_user
    @user = User.where(id: params[:id]).first
    return not_found unless @user
  end

  def ensure_user_is_current
    return error unless @user == current_user
  end
end