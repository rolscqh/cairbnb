class CreateAddFieldsToUsers < ActiveRecord::Migration
  def change
    create_table :add_fields_to_users do |t|
	    add_column :users, :provider, :string
	    add_column :users, :uid, :string
	    add_column :users, :image, :string
      t.timestamps null: false
    end
  end
end
