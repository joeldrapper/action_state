class CreateExamples < ActiveRecord::Migration[7.0]
  def change
    create_table :examples do |t|
      t.integer :integer
      t.string :string
      t.datetime :datetime
    end
  end
end
