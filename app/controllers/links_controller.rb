class LinksController < ApplicationController
  # LinkのURLから、リンク先WebサイトのOGP情報を取得する為の、スクレイピングに利用
  require 'open-uri'
  require 'nokogiri'

  before_action :logged_in_user #ApplicationControllerに定義
  before_action :count_link, only: [:create] #リンクはグループ毎に5つまで
  before_action :correct_user, only: [:update, :destroy] #本人以外はリンクの更新・削除できない

  def create
    @link = current_user.links.build(link_params)
    # バリデーション
    unless @link.valid?
      flash.now[:danger] = t('.flash.danger')
      render 'shared/error_flash'
    end
    # スクレイピングが成功した場合の処理
    # => 失敗の場合は「get_html_info」のrescue内で実行 (@link.save)
    if doc = get_html_info(params[:link][:url])
      @link.ogp_image = doc.css('//meta[property="og:image"]/@content').to_s
      if !doc.css('//meta[property="og:title"]/@content').to_s.blank?
        @link.ogp_title = doc.css('//meta[property="og:title"]/@content').to_s
      else
        @link.ogp_title = doc.title
      end
      @link.ogp_url = doc.css('//meta[property="og:url"]/@content').to_s
      @link.save
    end
  end

  def update
    # バリデーション
    if params[:link][:title].blank? || params[:link][:url].blank?
      flash.now[:danger] = t('.create.flash.danger')
      render 'shared/error_flash'        
    end
    # スクレイピングが成功した場合の処理    
    if doc = get_html_info(params[:link][:url])
      @link.ogp_image = doc.css('//meta[property="og:image"]/@content').to_s
      if !doc.css('//meta[property="og:title"]/@content').to_s.blank?
        @link.ogp_title = doc.css('//meta[property="og:title"]/@content').to_s
      else
        @link.ogp_title = doc.title
      end
      @link.ogp_url = doc.css('//meta[property="og:url"]/@content').to_s
      @link.update(link_params)
    else 
      #スクレイピングが失敗した場合の処理
      @link.ogp_image = ""
      @link.ogp_title = ""
      @link.ogp_url = ""
      @link.update(link_params)
    end
  end

  def destroy
    @link.destroy
  end

  # GET /search
  # Link検索機能 (未入力 => home.js.erbへrender)
  def search
    if params[:title].blank?
      @link_group  = current_user.link_groups.build
      @link_groups = current_user.link_groups.all
      @link = current_user.links.build
      @links = current_user.links.all
      render 'static_pages/home'
    else
      @links = current_user.links.where('title LIKE ?', "%#{params[:title]}%")
    end
  end

  private
    def link_params
      params.require(:link).permit(:title, :url, :link_group_id)
    end

    # リンクの数は、グループ毎に5つまで
    MAX_RECORD_NUM = 5
    def count_link
      links = current_user.links.where("link_group_id = ?", params[:link][:link_group_id])
      if links.count >= MAX_RECORD_NUM
        flash.now[:danger] = t('.count_link.flash.danger', num: MAX_RECORD_NUM)
        render 'shared/error_flash'
      end
    end

    # 入力されたURLから、HTMLの情報を取得
    def get_html_info(url)
      if @link.valid?
        begin
          html = URI.open(url, "user-agent"=>"user-agent").read
          Nokogiri::HTML.parse(html)
        rescue
          @link.save
          return false
        end
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @link = current_user.links.find_by(id: params[:id])
      redirect_to root_url if @link.nil?
    end
end
