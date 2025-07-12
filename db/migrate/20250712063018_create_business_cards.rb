class CreateBusinessCards < ActiveRecord::Migration[8.0]
  def change
    create_table :business_cards do |t|
      t.string :full_name
      t.string :company_name
      t.string :department
      t.string :post
      t.string :telephone_number
      t.string :mail
      t.text :address
      t.text :raw_response

      t.timestamps
    end
  end
end
