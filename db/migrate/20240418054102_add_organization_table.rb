class AddOrganizationTable < ActiveRecord::Migration[6.1]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :commerce_token, null: false

      t.timestamps
    end
  end
end
