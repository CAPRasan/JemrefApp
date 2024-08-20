class FixRecordTypeColimn < ActiveRecord::Migration[7.2]
  def change
    remove_column :records, :type, :string
  end
end
