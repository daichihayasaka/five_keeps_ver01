# 5Keeps
シンプルなブックマークアプリです。グループを5つまで作成でき、リンクをグループ毎に5つまで作成できます。Ruby on Rails (6.1.4)で開発しました。(https://www.5keeps.com/)

[![5Keeps_ogp_jp](https://user-images.githubusercontent.com/72771511/140642549-2581a59d-40f4-498a-8d28-d7515683c5a2.jpg)](https://www.5keeps.com/)

## サービス概要
### 解決したい課題
ブラウザのブックマーク機能に対して、以下の課題を抱えているユーザーに、解決策を提供できるサービスです。
- ブックマークが増えすぎて、今必要な情報にすぐアクセスできない。
- ブックマークの整理が大変。

### 課題の解決方法
以下のように機能を制限し、「今」必要な情報だけを、「分かりやすく」保存できる仕様にすることで、課題を解決しています。
- グループを5つまで作成できる。
- リンクをグループ毎に5つまで作成できる。
- リンクには必ずタイトルをつける。

### 使い方
アプリのトップページをご参照ください。  
https://www.5keeps.com/

## 主な機能
### ユーザー関係
- ユーザーの作成、編集、削除
- ユーザー認証（ログインの保持を選択可）
- メールを使用したアカウント有効化
- メールを使用したパスワード再設定
- ゲストログイン機能（詳細は後述）
### グループ関係
- グループの作成、表示、編集、削除（非同期通信）
### リンク関係
- リンクの作成、表示、編集、削除（非同期通信）
- URLから、リンク先WebサイトのOGP情報を取得・表示 (RubyのNokogiri gemを使用)
- 検索機能
### その他
- お問い合わせ機能（Gmailを使用）
- 言語切り替え機能（日本語/ 英語）

## ゲストログイン機能について
様々な実装方法があると思いますので、別途詳細をまとめました。

**1. usersテーブルにboolean型の「guest属性」を追加**
（db/migrate/xxxx_add_guest_to_users.rb）

```ruby
class AddGuestToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :guest, :boolean, default: false
  end
end
```

**2. ゲストページ用のルーティングを追加**   
（config/routes.rb）
```ruby
post '/guest', to:'users#create_guest'
get '/guest', to:'static_pages#guest'
```

**3. usersコントローラーにcreate_guestアクションを作成**
（app/controllers/users_controller.rb）
```ruby
  # POST /guest
  # 現在のユーザーがゲスト => ゲストページにリダイレクト
  # 現在のユーザーがいない => 新たにゲストを作成 (email/passwordはランダムな英数字)
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
```

**4. static_pagesコントローラーにguestアクションを作成**   
（app/controllers/static_pages_controller.rb）
```ruby
  # GET /guest
  # 現在のユーザーが「nilである」または「guestではない」=> ルートにリダイレクト
  def guest    
    redirect_to root_url if !current_user || !current_user.guest?
  end
```

**5. ゲストユーザーを定期的に削除**   
Herokuのschedulerアドオンを利用し、以下のrakeタスクを1日1回、日本時間1時AMに実行してます。    
（lib/tasks/scheduler.rake）

```ruby
desc "This task is called by the Heroku scheduler add-on"
task :delete_all_guests => :environment do
  puts "Updating guests..."
  # 1日より前に作成されたゲストユーザーを全て削除
  User.where(guest: :true).where("created_at < ?", 1.day.ago).destroy_all
  puts "done."
end
```

## ER図
![er_diagram](https://user-images.githubusercontent.com/72771511/140603325-dafce5de-d449-4076-9f73-85b6b5e8b3cb.png)

## 使用技術
### バックエンド
- Ruby 2.6.3
- Ruby on Rails 6.1.4
### フロントエンド
- Vanilla JS
- Sass
### データベース
- MySQL 8.0
### インフラ
- Heroku
### テスト
- Minitest

## 今後やりたいこと
### 機能面
- スマホ画面でのUI・UXを改善する。
- 非同期通信時の処理速度をあげる。
- ソーシャルログイン機能を実装する。
- レスポンシブ対応を細分化する。(現状だとPC/ Mobileの2パターン)
### 技術面
- RSpecでテストを書き換える。
- 開発環境でDockerを導入する。
- インフラをHerokuからAWSに変更する。
- APIモードでシステムを作り変えてみる。
