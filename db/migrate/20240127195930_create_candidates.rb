class CreateCandidates < ActiveRecord::Migration[7.1]
  def change
    create_table :candidates do |t|
      t.string :name
      t.integer :vote_count, default: 0

      t.timestamps
    end
  end
end
