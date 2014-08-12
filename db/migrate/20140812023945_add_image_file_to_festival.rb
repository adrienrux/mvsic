class AddImageFileToFestival < ActiveRecord::Migration
  def change
    add_column :festivals, :image_file, :string

    Festival.where(name: 'TomorrowWorld').first.update_attribute(:image_file, 'bubble.jpg')
    Festival.where(name: 'Electric Zoo').first.update_attribute(:image_file, 'sunlight.jpg')
    Festival.where(name: 'Decibel').first.update_attribute(:image_file, 'ponytail.jpg')
    Festival.where(name: 'Voodoo Experience').first.update_attribute(:image_file, 'hoodie.jpg')
  end
end
