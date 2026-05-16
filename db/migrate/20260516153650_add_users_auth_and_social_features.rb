class AddUsersAuthAndSocialFeatures < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role

    add_reference :posts, :user, foreign_key: true
    add_column :posts, :likes_count, :integer, null: false, default: 0

    add_reference :comments, :user, foreign_key: true
    add_column :comments, :likes_count, :integer, null: false, default: 0

    create_table :likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :likes, [ :user_id, :likeable_type, :likeable_id ], unique: true, name: "index_likes_uniqueness"

    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, foreign_key: { to_table: :users }
      t.references :notifiable, polymorphic: true, null: false
      t.string :action, null: false
      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, [ :user_id, :read_at ]
    add_index :notifications, :created_at
  end
end
