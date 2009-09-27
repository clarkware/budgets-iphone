class CreateBudget < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.string  :name
      t.decimal :amount, :precision => 8, :scale => 2
      t.integer :user_id
      t.timestamps
    end
  end

  def self.down
    drop_table :budgets
  end
end
