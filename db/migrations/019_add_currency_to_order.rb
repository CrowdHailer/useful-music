Sequel.migration do
  up do
    alter_table(:orders) do
      add_column :currency, String
      add_constraint(:allowed_currencies, :currency => ['USD', 'EUR', 'GBP'])
    end
  end

  down do
    alter_table(:orders) do
      drop_column :currency
    end
  end
end
