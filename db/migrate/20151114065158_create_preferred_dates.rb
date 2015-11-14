class CreatePreferredDates < ActiveRecord::Migration
  def change
    create_table :preferred_dates do |t|
      t.date :day
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
