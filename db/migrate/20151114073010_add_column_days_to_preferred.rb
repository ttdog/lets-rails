class AddColumnDaysToPreferred < ActiveRecord::Migration
  def change
    remove_column :preferred_dates, :day, :date

    add_column :preferred_dates, :year, :integer
    add_column :preferred_dates, :month, :integer
        add_column :preferred_dates, :day, :integer
  end
  # 
  # def up
  #   change_column :preferred_date, :day, :integer
  # end
  #
  # def down
  #   change_column :preferred_date, :day, :date
  # end
end
