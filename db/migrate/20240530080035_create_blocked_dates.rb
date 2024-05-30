class CreateBlockedDates < ActiveRecord::Migration[7.1]
  def change
    create_table :blocked_dates do |t|
      t.date :date, null: false

      t.timestamps
    end
  end
end
