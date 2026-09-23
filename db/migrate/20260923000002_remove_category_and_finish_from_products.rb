class RemoveCategoryAndFinishFromProducts < ActiveRecord::Migration[6.1]
  def change
    remove_column :products, :category, :string
    remove_column :products, :finish, :string
  end
end
