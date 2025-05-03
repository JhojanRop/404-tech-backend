class CreateProductos < ActiveRecord::Migration[8.0]
  def change
    create_table :productos do |t|
      t.string :title
      t.string :description
      t.string :category
      t.float :price
      t.float :discountPercentage
      t.integer :rating
      t.integer :stock
      t.string :tags, array: true, default: []
      t.string :thumbail

      t.timestamps
    end
  end
end
