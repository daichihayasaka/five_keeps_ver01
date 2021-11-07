class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        # remember_meチェックスボックスの確認
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_url #friendly forwarding
      else
        # 有効化未完了時にログインボタンを押した時
        flash[:warning] = t('.flash.warning')
        redirect_to root_url
      end
    else
      flash.now[:danger] = t('.flash.danger')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? #連続ロウアウト問題への対応
    redirect_to root_url
  end
end
