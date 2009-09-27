class CreateExpenses < ActiveRecord::Migration
  def self.up
    create_table :expenses do |t|
      t.string  :name
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :budget_id

      t.timestamps
    end
  end

  def self.down
    drop_table :expenses
  end
end
