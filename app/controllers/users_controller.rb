class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    if !@user.searches.blank?
      @user_searches = @user.searches.order('created_at DESC').group_by { |c| c.created_at.to_date }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Last.fm Recommendation Engine!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
