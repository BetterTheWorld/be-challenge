class AddReportsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :name, null: false
      t.string :location, null: false
      t.string :currency, null: false
      t.string :symbol, null: false
      t.string :external_report_id, null: false
      t.string :format, null: false

      t.timestamps
    end
  end
end
