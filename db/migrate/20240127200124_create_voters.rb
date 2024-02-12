class CreateVoters < ActiveRecord::Migration[7.1]
  def change
    create_table :voters do |t|
      t.string :email
      t.string :zip_code
      t.timestamp :voted_at
      t.timestamp :signed_in_at

      t.timestamps
    end
  end
end
