ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers

  # ⬇︎をコメントアウトした
  # parallelize(workers: :number_of_processors)
  # 参考：https://stackoverflow.com/questions/57863565/running-rails-test-is-throwing-bad-file-descriptor-errnoebadf-error

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # テストユーザーがログイン中の場合にtrueを返す (テスト用のlogged_in?メソッド)
  # ・sessions_helperは使えないので、current_userは使えない
  # ・sessionメソッドは使える
  # ・テストユーザーがログインできているかチェック！
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザーとしてログインする (単体テスト用のlog_inメソッド)
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# オープンクラス
class ActionDispatch::IntegrationTest
  # テストユーザーとしてログインする (統合テスト用のlog_inメソッド)
  # => 統合テストではsessionメソッドを使えない
  # => ストーリーで考える
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end
