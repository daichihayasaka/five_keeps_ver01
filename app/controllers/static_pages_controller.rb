class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @link_group  = current_user.link_groups.build
      @link_groups = current_user.link_groups.all
      @link = current_user.links.build
      @links = current_user.links.all
    end
  end

  def guest
    # 現在のユーザーが「nilである」または「guestではない」=> ルートにリダイレクト
    redirect_to root_url if !current_user || !current_user.guest?
    if logged_in?
      @link_group  = current_user.link_groups.build
      @link_groups = current_user.link_groups.all
      @link = current_user.links.build
      @links = current_user.links.all
    end
  end

  def about
  end

  def terms
  end

  def privacy
  end
end
