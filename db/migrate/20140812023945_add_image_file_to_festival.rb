class AddImageFileToFestival < ActiveRecord::Migration
  def change
    add_column :festivals, :image_file, :string
  end
end
