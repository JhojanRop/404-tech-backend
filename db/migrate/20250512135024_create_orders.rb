class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.string :products, default: '[]'
      t.string :status
      t.integer :total

      t.timestamps
    end
  end
end
