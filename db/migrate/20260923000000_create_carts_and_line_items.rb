class CreateCartsAndLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      t.references :user, index: { unique: true }, foreign_key: true
      t.timestamps
    end

    create_table :line_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.timestamps
    end
    add_index :line_items, [:cart_id, :product_id], unique: true

    change_column :products, :price, :decimal, precision: 12, scale: 2, default: 0
  end
end
