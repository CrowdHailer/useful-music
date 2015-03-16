Sequel.migration do
  up do
    alter_table(:orders) do
      rename_column :basket_amount, :basket_total
      rename_column :discount_amount, :discount_value
      rename_column :tax_amount, :tax_payment
      add_column :payment_gross, :integer, :null => false
      add_column :payment_net, :integer, :null => false
    end
  end

  down do
    alter_table(:orders) do
      rename_column :basket_total, :basket_amount
      rename_column :discount_value, :discount_amount
      rename_column :tax_payment, :tax_amount
      drop_column :payment_gross
      drop_column :payment_net
    end
  end
end
