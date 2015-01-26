class CreateInQuotexQuotes < ActiveRecord::Migration
  def change
    create_table :in_quotex_quotes do |t|
      
      t.string :product_name
      t.text :product_spec
      t.date :quote_date
      t.integer :task_id
      t.integer :last_updated_by_id
      t.string :wf_state
      t.integer :qty
      t.string :unit
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.integer :supplier_id
      t.decimal :shipping_cost, :precision => 10, :scale => 2
      t.decimal :tax, :precision => 10, :scale => 2
      t.decimal :other_cost, :precision => 10, :scale => 2
      t.decimal :quote_total, :precision => 10, :scale => 2
      t.integer :lead_time_day
      t.text :payment_term
      t.text :quote_condition
      t.integer :good_for_day
      t.string :supplier_quote_num
      t.string :supplier_contact
      t.boolean :void, :default => false
      t.integer :entered_by_id
      t.integer :project_id
      t.boolean :approved, :default => false
      t.date :approved_date     
      t.timestamps
      t.integer :category_id
      t.integer :sub_category_id
      t.integer :approved_by_id
    end
    
    add_index :in_quotex_quotes, :task_id
    add_index :in_quotex_quotes, :project_id
    add_index :in_quotex_quotes, :supplier_id
    add_index :in_quotex_quotes, :wf_state
    add_index :in_quotex_quotes, :approved
    add_index :in_quotex_quotes, :void
    add_index :in_quotex_quotes, :product_name
    add_index :in_quotex_quotes, :quote_date
    add_index :in_quotex_quotes, :category_id
    add_index :in_quotex_quotes, :approved_by_id
  end
end
