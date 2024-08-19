class CreateRecords < ActiveRecord::Migration[7.2]
  def change
    create_table :records do |t|
      t.integer :publish_form
      t.string :author_name
      t.string :main_title
      t.string :sub_title
      t.integer :publish_date
      t.string :publisher
      t.string :compiled_by
      t.string :publication
      t.integer :volume
      t.integer :no
      t.text :memo
      t.integer :user_id
      t.timestamps
    end
  end
end
