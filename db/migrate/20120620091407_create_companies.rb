class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_description
      t.string :asx_code

      t.timestamps
    end
  end
end
