class CreateCompanyKeywords < ActiveRecord::Migration
  def change
    create_table :company_keywords do |t|
      t.string :company_keyword
      t.integer :company_id
      t.string :company_name

      t.timestamps
    end
  end
end
