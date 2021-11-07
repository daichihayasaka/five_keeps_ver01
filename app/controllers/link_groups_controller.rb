class LinkGroupsController < ApplicationController
  before_action :logged_in_user #ApplicationControllerに定義
  before_action :count_link_group, only: [:create] #グループは5つまで
  before_action :validation_link_group, only: [:create] #未入力チェック(作成時)
  before_action :correct_user, only: [:update, :destroy] #本人以外はグループの更新・削除できない
  before_action :valid_link_group, only: [:update] #未入力チェック(更新時)

  def show
    @links = current_user.links.where("link_group_id = ?", params[:id])
  end

  def create
  end

  def update
    @link_group.update(link_group_params)
  end

  def destroy
    @link_group.destroy
    @links = current_user.links.all
  end

  private
    def link_group_params
      params.require(:link_group).permit(:name)
    end

    MAX_RECORD_NUM = 5
    def count_link_group
      if current_user.link_groups.count >= MAX_RECORD_NUM
        flash.now[:danger] = t('.count_link_group.flash.danger', num: MAX_RECORD_NUM)
        render 'shared/error_flash'
      end
    end
    
    # 未入力チェック(作成時)
    # 「count_link_group」の後に実行する。
    # => 前だと6つめのグループを作成可能(更新すると表示: バリデーションは通るから)
    def validation_link_group
      @link_group = current_user.link_groups.build(link_group_params)
      unless @link_group.save
        flash.now[:danger] = t('.validation_link_group.flash.danger')
        render 'shared/error_flash'
      end
    end

    def correct_user
      @link_group = current_user.link_groups.find_by(id: params[:id])
      redirect_to root_url if @link_group.nil?
    end

    # 未入力チェック(更新時)
    # => @link_groupは「correct_user」で取得済み
    def valid_link_group
      @link_group.update(link_group_params)
      unless @link_group.update(link_group_params)
        flash.now[:danger] = t('.validation_link_group.flash.danger')
        render 'shared/error_flash'
      end
    end
end
