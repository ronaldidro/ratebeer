class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :beerclub_id
      t.integer :user_id

      t.timestamps
    end
  end
end
