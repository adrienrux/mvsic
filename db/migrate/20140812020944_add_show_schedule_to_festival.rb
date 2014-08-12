class AddShowScheduleToFestival < ActiveRecord::Migration
  def change
    add_column :festivals, :show_schedule, :boolean, default: false
  end
end
