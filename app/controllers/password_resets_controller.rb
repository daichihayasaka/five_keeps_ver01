class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t('.flash.info')
      redirect_to root_url
    else
      flash.now[:danger] = t('.flash.danger')
      render 'new'
    end
  end

  def edit
  end

  def update
    # バリデーション(未入力: モデルではallow nil)
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      # 再設定済み => 再設定用リンクを使用不可にする
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t('.flash.success')
      redirect_to root_url
    else
      # 更新に失敗 => エラーメッセージ(未入力以外)
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # editとupdateで必要な@userの取得をまとめて行う
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認
    def valid_user
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # リセットトークンの期限切れを確認
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = t('password_resets.check_expiration.flash.danger')
        redirect_to new_password_reset_url
      end
    end
end
