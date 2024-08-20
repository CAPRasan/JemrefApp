class ChangeColumnToRecords < ActiveRecord::Migration[7.2]
  def change
    remove_column :records, :publish_form, :integer
    remove_column :records, :user_id, :integer
    add_column :records, :type, :string, null: false, default: 0
    add_column :records, :status, :integer, null: false, default: 0
    add_reference :records, :user, foreign_key: true
  end
end
