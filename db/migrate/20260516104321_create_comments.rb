class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :post, null: false, foreign_key: true
      t.references :parent, foreign_key: { to_table: :comments }

      t.timestamps
    end

    add_index :comments, [ :post_id, :parent_id ]
  end
end
