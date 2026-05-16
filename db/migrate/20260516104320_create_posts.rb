class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 0
      t.datetime :published_at
      t.integer :comments_count, null: false, default: 0

      t.timestamps
    end

    add_index :posts, :status
    add_index :posts, :published_at
  end
end
