class AddColumnToRecord < ActiveRecord::Migration[7.2]
  def change
    add_column :records, :publication_main_title, :string
    add_column :records, :publication_sub_title, :string
    add_column :records, :volume_other_form, :string
  end
end
