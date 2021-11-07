class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # activate済みの場合は、else処理を実行
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t('.flash.success')
      redirect_to root_url
    else
      flash[:danger] = t('.flash.danger')
      redirect_to root_url
    end
  end
end
