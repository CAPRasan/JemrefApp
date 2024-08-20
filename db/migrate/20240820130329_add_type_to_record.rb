class AddTypeToRecord < ActiveRecord::Migration[7.2]
  def change
    add_column :records, :type, :string
  end
end
