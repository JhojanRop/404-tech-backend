class CreateReviews < ActiveRecord::Migration[8.0]
  def change
    create_table :reviews do |t|
      t.string :name
      t.string :review
      t.datetime :date_created

      t.timestamps
    end
  end
end
