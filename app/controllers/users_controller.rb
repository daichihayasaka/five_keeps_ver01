class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :destroy] #ApplicationControllerに定義
  before_action :correct_user, only: [:edit, :update, :destroy] #本人以外がアクセスできないページ
  before_action :not_guest_user, only: [:edit, :update, :destroy] #guestがアクセスできないページ

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t('.flash.info')
      redirect_to root_url
    else
      render 'new'
    end
  end

  # POST /guest
  # 現在のユーザーがゲスト => ゲスト用のページにリダイレクト
  # 現在のユーザーがいない => 新たにゲストを作成 (emailとpasswordはランダムな値)
  def create_guest
    if current_user && current_user.guest?
      redirect_to guest_path
    else
      user = User.create(name: "Guest User",
                                    email: SecureRandom.alphanumeric(15) + "@guest.com",
                                    password: SecureRandom.alphanumeric(10),
                                    guest: 1)
      log_in user
      flash[:success] = t('.flash.success')
      redirect_to guest_path
    end
  end

  def edit
  end

  # 変更可能な項目：name, passowrd (emailは変更不可)
  def update
    if @user.update(user_update_params)
      flash[:success] = t('.flash.success')
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('.flash.success')
    redirect_to root_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                                :password_confirmation)
    end

    def  user_update_params
      params.require(:user).permit(:name, :password, :password_confirmation)
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # guestかどうか確認
    def not_guest_user
      user = User.find(params[:id])
      if user.guest?
        redirect_to guest_path
      end
    end
end
