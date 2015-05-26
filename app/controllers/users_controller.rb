class UsersController < ApplicationController
  attr_accessor :name, :email

  def show
    # Usersコントローラにリクエストが正常に送信されると、
    # params[:id]の部分はユーザーidの1に置き換わります。
    # User.find(1)と同じ意味
    # routes.rbでresources :usersしてるから。
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
#    @user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
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
