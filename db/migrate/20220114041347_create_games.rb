class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :purpose
      t.text :description

      t.timestamps
    end
  end
end
