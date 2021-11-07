require "test_helper"

class LinksInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @link_group = link_groups(:rails)
  end

  test "link interface with Ajax" do
    log_in_as(@user)
    get root_path
    # Linkを作成する(無効な送信①: タイトルが未入力)
    assert_no_difference 'Link.count' do
      post links_path, params: { link: { title: "",
                                                      url: "https://www.yahoo.co.jp/",
                                                      link_group_id: @link_group.id } },
                              xhr: true
    end
    assert_not flash.empty?

    # Linkを作成する(無効な送信②: URLが未入力)
    assert_no_difference 'Link.count' do
      post links_path, params: { link: { title: "hoge",
                                                      url: "",
                                                      link_group_id: @link_group.id } },
                              xhr: true
    end
    assert_not flash.empty?

    # Linkを作成する(無効な送信③：リンク数が5つ)
    assert_no_difference 'Link.count' do
      post links_path, params: { link: { title: "hoge",
                                                      url: "https://www.yahoo.co.jp/",
                                                      link_group_id: @link_group.id } },
                              xhr: true
    end
    assert_not flash.empty?

    # Linkを作成する(無効な送信④：URLが正しくない)
    assert_no_difference 'Link.count' do
      post links_path, params: { link: { title: "hoge",
                                                      url: "url",
                                                      link_group_id: @link_group.id } },
                              xhr: true
    end
    assert_not flash.empty?

    # Linkを削除する
    first_link = @user.links.first
    assert_difference 'Link.count', -1 do
      delete link_path(first_link), xhr: true
    end

    # Linkを作成する(有効な送信)
    # title = "i18n API"
    # assert_difference 'Link.count', 1 do
    #   post links_path, params: { link: { title: title,
    #                                                   url: "https://www.yahoo.co.jp/",
    #                                                   link_group_id: @link_group.id } },
    #                           xhr: true
    # end
    # assert_match title, response.body

    # Linkを編集する
    updated_title = "i18n API 2"
    last_link = @user.links.last
    assert_no_difference 'Link.count' do
      patch link_path(last_link),
                params: { link: { title: updated_title,
                                        url: "https://www.yahoo.co.jp/",
                                        link_group_id: @link_group.id } },
                xhr: true
    end
    assert_match updated_title, response.body
  end
end
