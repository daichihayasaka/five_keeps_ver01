class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  def set_locale
    I18n.locale = locale
  end

  def locale
    @locale ||= params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

private
  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t('application.logged_in_user.flash.danger')
      redirect_to login_url
    end
  end
end
