class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :title
      t.string :description
      t.string :category, default: '[]'
      t.string :brand, default: '[]'
      t.string :image, default: '[]'
      t.float :price
      t.float :oldPrice
      t.boolean :onSale
      t.float :discountPercentage
      t.integer :rating
      t.integer :stock
      t.string :tags, default: '[]'
      t.string :thumbail

      t.timestamps
    end
  end
end
