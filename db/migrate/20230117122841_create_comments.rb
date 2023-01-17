class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :name
      t.belongs_to :movie, null: false, foreign_key: true
      t.timestamps
    end
  end
end