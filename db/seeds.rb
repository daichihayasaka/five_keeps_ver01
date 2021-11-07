# メインのサンプルユーザーを1人作成する
User.create!(name:  "Example User",
  email: "example@railstutorial.org",
  password:              "foobar",
  password_confirmation: "foobar",
  activated: true,
  activated_at: Time.zone.now)

  # ゲストユーザーを1人作成する
User.create!(name:  "Guest User",
  email: "random@guest.com",
  password:              "random",
  password_confirmation: "random",
  guest:     true,
  activated: true,
  activated_at: Time.zone.now)
