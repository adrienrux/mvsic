class AddActiveToFestival < ActiveRecord::Migration
  def change
    add_column :festivals, :active, :boolean, default: false
  end
end
