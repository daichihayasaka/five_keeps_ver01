class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.string :title
      t.text :url
      t.text :ogp_image
      t.text :ogp_title
      t.text :ogp_url
      t.references :user, null: false, foreign_key: true
      t.references :link_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
