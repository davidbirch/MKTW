class CreateCompanyPrices < ActiveRecord::Migration
  def change
    create_table :company_prices do |t|
      t.datetime :price_time
      t.decimal :price_value
      t.integer :company_id
      t.string :company_name

      t.timestamps
    end
  end
end
