class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :first_name
      t.string  :last_name
      t.string  :email, null: false
      t.boolean :admin, default: false
    end

    change_table :schedules do |t|
      t.references :user, index: true
    end
  end
end
