class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :fullName
      t.string :username
      t.string :password
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
