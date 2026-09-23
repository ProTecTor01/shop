class AddCategoryToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :category, :string
    reversible do |direction|
      direction.up { execute "UPDATE products SET category = 'Other' WHERE category IS NULL" }
    end
    change_column_null :products, :category, false
    add_index :products, :category
  end
end
