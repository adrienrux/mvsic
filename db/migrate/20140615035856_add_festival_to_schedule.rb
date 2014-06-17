class AddFestivalToSchedule < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.belongs_to :festival, index: true
    end
  end
end
